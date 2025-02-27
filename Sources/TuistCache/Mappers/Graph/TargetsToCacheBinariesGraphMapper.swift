import Foundation
import RxBlocking
import RxSwift
import TSCBasic
import TuistCore
import TuistGraph
import TuistSupport

enum FocusTargetsGraphMapperError: FatalError, Equatable {
    case missingTargets(missingTargets: [String], availableTargets: [String])

    var description: String {
        switch self {
        case let .missingTargets(missingTargets: missingTargets, availableTargets: availableTargets):
            return "Targets \(missingTargets.joined(separator: ", ")) cannot be found. Available targets are \(availableTargets.joined(separator: ", "))"
        }
    }

    var type: ErrorType {
        switch self {
        case .missingTargets:
            return .abort
        }
    }
}

public final class TargetsToCacheBinariesGraphMapper: GraphMapping {
    // MARK: - Attributes

    /// Cache.
    private let cache: CacheStoring

    /// Graph content hasher.
    private let cacheGraphContentHasher: CacheGraphContentHashing

    /// Cache graph mapper.
    private let cacheGraphMutator: CacheGraphMutating

    /// Configuration object.
    private let config: Config

    /// List of targets that will be generated as sources instead of pre-compiled targets from the cache.
    private let sources: Set<String>

    /// The type of artifact that the hasher is configured with.
    private let cacheOutputType: CacheOutputType

    /// The caching profile.
    private let cacheProfile: TuistGraph.Cache.Profile

    // MARK: - Init

    public convenience init(
        config: Config,
        cacheStorageProvider: CacheStorageProviding,
        sources: Set<String>,
        cacheProfile: TuistGraph.Cache.Profile,
        cacheOutputType: CacheOutputType
    ) {
        self.init(
            config: config,
            cache: Cache(storageProvider: cacheStorageProvider),
            cacheGraphContentHasher: CacheGraphContentHasher(),
            sources: sources,
            cacheProfile: cacheProfile,
            cacheOutputType: cacheOutputType
        )
    }

    init(config: Config,
         cache: CacheStoring,
         cacheGraphContentHasher: CacheGraphContentHashing,
         sources: Set<String>,
         cacheProfile: TuistGraph.Cache.Profile,
         cacheOutputType: CacheOutputType,
         cacheGraphMutator: CacheGraphMutating = CacheGraphMutator())
    {
        self.config = config
        self.cache = cache
        self.cacheGraphContentHasher = cacheGraphContentHasher
        self.cacheGraphMutator = cacheGraphMutator
        self.sources = sources
        self.cacheProfile = cacheProfile
        self.cacheOutputType = cacheOutputType
    }

    // MARK: - GraphMapping

    public func map(graph: Graph) throws -> (Graph, [SideEffectDescriptor]) {
        let graphTraverser = GraphTraverser(graph: graph)
        let availableTargets = Set(
            graphTraverser.allTargets().map(\.target.name)
        )
        let missingTargets = sources.subtracting(availableTargets)
        guard
            missingTargets.isEmpty
        else {
            throw FocusTargetsGraphMapperError.missingTargets(
                missingTargets: missingTargets.sorted(),
                availableTargets: availableTargets.sorted()
            )
        }
        let single = AsyncThrowingStream<Graph, Error> { continuation in
            Task.detached {
                do {
                    let hashes = try self.cacheGraphContentHasher.contentHashes(
                        for: graph,
                        cacheProfile: self.cacheProfile,
                        cacheOutputType: self.cacheOutputType,
                        excludedTargets: self.sources
                    )
                    let result = try self.cacheGraphMutator.map(
                        graph: graph,
                        precompiledArtifacts: await self.fetch(hashes: hashes),
                        sources: self.sources
                    )
                    continuation.yield(result)
                    continuation.finish()
                } catch {
                    continuation.finish(throwing: error)
                }
            }
        }.asObservable().asSingle()
        return try (single.toBlocking().single(), [])
    }

    // MARK: - Helpers

    private func fetch(hashes: [GraphTarget: String]) async throws -> [GraphTarget: AbsolutePath] {
        try await hashes.concurrentMap { target, hash -> (GraphTarget, AbsolutePath?) in
            if try await self.cache.exists(name: target.target.name, hash: hash) {
                let path = try await self.cache.fetch(name: target.target.name, hash: hash)
                return (target, path)
            } else {
                return (target, nil)
            }
        }.reduce(into: [GraphTarget: AbsolutePath]()) { acc, next in
            guard let path = next.1 else { return }
            acc[next.0] = path
        }
    }
}
