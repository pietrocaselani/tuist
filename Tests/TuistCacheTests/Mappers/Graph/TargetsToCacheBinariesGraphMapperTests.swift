import Foundation
import TuistCore
import TuistGraph
import XCTest

@testable import TuistCache
@testable import TuistCacheTesting
@testable import TuistCoreTesting
@testable import TuistGraphTesting
@testable import TuistSupportTesting

final class TargetsToCacheBinariesGraphMapperTests: TuistUnitTestCase {
    var cache: MockCacheStorage!
    var cacheGraphContentHasher: MockCacheGraphContentHasher!
    var cacheGraphMutator: MockCacheGraphMutator!
    var subject: TargetsToCacheBinariesGraphMapper!
    var config: Config!

    override func setUp() {
        super.setUp()
        cache = MockCacheStorage()
        cacheGraphContentHasher = MockCacheGraphContentHasher()
        cacheGraphMutator = MockCacheGraphMutator()
        config = .test()
        subject = TargetsToCacheBinariesGraphMapper(
            config: config,
            cache: cache,
            cacheGraphContentHasher: cacheGraphContentHasher,
            sources: [],
            cacheProfile: .test(),
            cacheOutputType: .framework,
            cacheGraphMutator: cacheGraphMutator
        )
    }

    override func tearDown() {
        config = nil
        cache = nil
        cacheGraphContentHasher = nil
        cacheGraphMutator = nil
        subject = nil
        super.tearDown()
    }

    func test_map_when_a_source_is_not_available() throws {
        // Given
        subject = TargetsToCacheBinariesGraphMapper(
            config: config,
            cache: cache,
            cacheGraphContentHasher: cacheGraphContentHasher,
            sources: ["B", "C", "D"],
            cacheProfile: .test(),
            cacheOutputType: .framework,
            cacheGraphMutator: cacheGraphMutator
        )
        let projectPath = try temporaryPath()
        let graph = Graph.test(
            projects: [
                projectPath: .test(),
            ],
            targets: [
                projectPath: [
                    "A": .test(name: "A"),
                    "B": .test(name: "B"),
                ],
            ]
        )

        // When / Then
        XCTAssertThrowsSpecific(
            try subject.map(graph: graph),
            FocusTargetsGraphMapperError.missingTargets(missingTargets: ["C", "D"], availableTargets: ["A", "B"])
        )
    }

    func test_map_when_all_binaries_are_fetched_successfully() throws {
        let path = try temporaryPath()
        let project = Project.test(path: path)

        // Given
        let cFramework = Target.test(name: "C", platform: .iOS, product: .framework)
        let cGraphTarget = GraphTarget.test(path: path, target: cFramework)
        let cXCFrameworkPath = path.appending(component: "C.xcframework")
        let cHash = "C"

        let bFramework = Target.test(name: "B", platform: .iOS, product: .framework)
        let bGraphTarget = GraphTarget.test(path: path, target: bFramework)
        let bHash = "B"
        let bXCFrameworkPath = path.appending(component: "B.xcframework")

        let app = Target.test(name: "App", platform: .iOS, product: .app)
        let appGraphTarget = GraphTarget.test(path: path, target: app)
        let appHash = "App"

        let inputGraph = Graph.test(
            name: "input",
            projects: [path: project],
            dependencies: [
                .target(name: bFramework.name, path: bGraphTarget.path): [
                    .target(name: cFramework.name, path: cGraphTarget.path),
                ],
                .target(name: app.name, path: appGraphTarget.path): [
                    .target(name: bFramework.name, path: bGraphTarget.path),
                ],
            ]
        )
        let outputGraph = Graph.test(
            name: "output",
            projects: inputGraph.projects,
            dependencies: inputGraph.dependencies
        )

        let contentHashes = [
            cGraphTarget: cHash,
            bGraphTarget: bHash,
            appGraphTarget: appHash,
        ]
        cacheGraphContentHasher.contentHashesStub = { _, _, _, _ in
            contentHashes
        }

        cache.existsStub = { name, hash in
            switch hash {
            case bHash:
                XCTAssertEqual(name, "B")
                return true
            case cHash:
                XCTAssertEqual(name, "C")
                return true
            default:
                return false
            }
        }

        cache.fetchStub = { name, hash in
            switch hash {
            case bHash:
                XCTAssertEqual(name, "B")
                return bXCFrameworkPath
            case cHash:
                XCTAssertEqual(name, "C")
                return cXCFrameworkPath
            default:
                XCTFail("Unexpected call to fetch")
                return "/"
            }
        }
        cacheGraphMutator.stubbedMapResult = outputGraph

        // When
        let (got, _) = try subject.map(graph: inputGraph)

        // Then
        XCTAssertEqual(
            got,
            outputGraph
        )
    }

    func test_map_when_one_of_the_binaries_fails_cannot_be_fetched() throws {
        let path = try temporaryPath()
        let project = Project.test(path: path)

        // Given
        let cFramework = Target.test(name: "C", platform: .iOS, product: .framework)
        let cGraphTarget = GraphTarget.test(path: path, target: cFramework)
        let cHash = "C"

        let bFramework = Target.test(name: "B", platform: .iOS, product: .framework)
        let bGraphTarget = GraphTarget.test(path: path, target: bFramework)
        let bHash = "B"
        let bXCFrameworkPath = path.appending(component: "B.xcframework")

        let app = Target.test(name: "App", platform: .iOS, product: .app)
        let appGraphTarget = GraphTarget.test(path: path, target: app)
        let appHash = "App"

        let inputGraph = Graph.test(
            name: "input",
            projects: [path: project],
            dependencies: [
                .target(name: bFramework.name, path: bGraphTarget.path): [
                    .target(name: cFramework.name, path: cGraphTarget.path),
                ],
                .target(name: app.name, path: appGraphTarget.path): [
                    .target(name: bFramework.name, path: bGraphTarget.path),
                ],
            ]
        )
        let outputGraph = Graph.test(
            name: "output",
            projects: inputGraph.projects,
            dependencies: inputGraph.dependencies
        )

        let contentHashes = [
            cGraphTarget: cHash,
            bGraphTarget: bHash,
            appGraphTarget: appHash,
        ]
        let error = TestError("error downloading C")
        cacheGraphContentHasher.contentHashesStub = { _, _, _, _ in
            contentHashes
        }

        cache.existsStub = { name, hash in
            switch hash {
            case bHash:
                XCTAssertEqual(name, "B")
                return true
            case cHash:
                XCTAssertEqual(name, "C")
                return true
            default:
                return false
            }
        }

        cache.fetchStub = { name, hash in
            switch hash {
            case bHash:
                XCTAssertEqual(name, "B")
                return bXCFrameworkPath
            case cHash:
                XCTAssertEqual(name, "C")
                throw error
            default:
                XCTFail("Unexpected call to fetch")
                return "/"
            }
        }
        cacheGraphMutator.stubbedMapResult = outputGraph

        // Then
        XCTAssertThrowsSpecific(try subject.map(graph: inputGraph), error)
    }

    func test_map_forwards_correct_artifactType_to_hasher() throws {
        // Given
        let path = try temporaryPath()
        let project = Project.test(path: path)

        subject = TargetsToCacheBinariesGraphMapper(
            config: config,
            cache: cache,
            cacheGraphContentHasher: cacheGraphContentHasher,
            sources: [],
            cacheProfile: .test(),
            cacheOutputType: .xcframework,
            cacheGraphMutator: cacheGraphMutator
        )

        let cFramework = Target.test(name: "C", platform: .iOS, product: .framework)
        let cGraphTarget = GraphTarget.test(path: path, target: cFramework)

        let bFramework = Target.test(name: "B", platform: .iOS, product: .framework)
        let bGraphTarget = GraphTarget.test(path: path, target: bFramework)

        let app = Target.test(name: "App", platform: .iOS, product: .app)
        let appGraphTarget = GraphTarget.test(path: path, target: app)

        let inputGraph = Graph.test(
            name: "input",
            projects: [path: project],
            dependencies: [
                .target(name: bFramework.name, path: bGraphTarget.path): [
                    .target(name: cFramework.name, path: cGraphTarget.path),
                ],
                .target(name: app.name, path: appGraphTarget.path): [
                    .target(name: bFramework.name, path: bGraphTarget.path),
                ],
            ]
        )
        let outputGraph = Graph.test(
            name: "output",
            projects: inputGraph.projects,
            dependencies: inputGraph.dependencies
        )
        cacheGraphMutator.stubbedMapResult = outputGraph

        var invokedCacheOutputType: CacheOutputType?
        var invokedCacheProfile: TuistGraph.Cache.Profile?
        cacheGraphContentHasher.contentHashesStub = { _, cacheProfile, cacheOutputType, _ in
            invokedCacheOutputType = cacheOutputType
            invokedCacheProfile = cacheProfile
            return [:]
        }

        // When
        _ = try subject.map(graph: inputGraph)

        // Then
        XCTAssertEqual(invokedCacheProfile, .test())
        XCTAssertEqual(invokedCacheOutputType, .xcframework)
    }
}
