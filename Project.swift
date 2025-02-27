import ProjectDescription
import ProjectDescriptionHelpers

let baseSettings: SettingsDictionary = ["EXCLUDED_ARCHS": "arm64"]

func debugSettings() -> SettingsDictionary {
    var settings = baseSettings
    settings["ENABLE_TESTABILITY"] = "YES"
    return settings
}

func releaseSettings() -> SettingsDictionary {
    baseSettings
}

func modulesTargetsAndSchemes() -> [(targets: [Target], scheme: Scheme)] {
    [
        Target.module(
            name: "TuistSupport",
            hasIntegrationTests: true,
            dependencies: [
                .external(name: "ArgumentParser"),
                .external(name: "Checksum"),
                .external(name: "CombineExt"),
                .external(name: "CryptoSwift"),
                .external(name: "GraphViz"),
                .external(name: "KeychainAccess"),
                .external(name: "Logging"),
                .external(name: "PathKit"),
                .external(name: "Queuer"),
                .external(name: "RxBlocking"),
                .external(name: "RxRelay"),
                .external(name: "RxSwift"),
                .external(name: "Signals"),
                .external(name: "Stencil"),
                .external(name: "StencilSwiftKit"),
                .external(name: "Swifter"),
                .external(name: "SwiftToolsSupport-auto"),
                .external(name: "XcodeProj"),
                .external(name: "Zip"),
            ]
        ),
        Target.module(
            name: "TuistKit",
            hasTesting: false,
            hasIntegrationTests: true,
            dependencies: [
                .target(name: "TuistSupport"),
                .target(name: "TuistGenerator"),
                .target(name: "TuistCache"),
                .target(name: "TuistAutomation"),
                .target(name: "ProjectDescription"),
                .target(name: "ProjectAutomation"),
                .target(name: "TuistLoader"),
                .target(name: "TuistScaffold"),
                .target(name: "TuistSigning"),
                .target(name: "TuistDependencies"),
                .target(name: "TuistLinting"),
                .target(name: "TuistCloud"),
                .target(name: "TuistMigration"),
                .target(name: "TuistAsyncQueue"),
                .target(name: "TuistAnalytics"),
                .target(name: "TuistPlugin"),
                .target(name: "TuistGraph"),
                .target(name: "TuistTasks"),
            ],
            testDependencies: [
                .target(name: "TuistAutomation"),
                .target(name: "TuistSupportTesting"),
                .target(name: "TuistCoreTesting"),
                .target(name: "ProjectDescription"),
                .target(name: "ProjectAutomation"),
                .target(name: "TuistLoaderTesting"),
                .target(name: "TuistCacheTesting"),
                .target(name: "TuistGeneratorTesting"),
                .target(name: "TuistScaffoldTesting"),
                .target(name: "TuistCloudTesting"),
                .target(name: "TuistAutomationTesting"),
                .target(name: "TuistSigningTesting"),
                .target(name: "TuistDependenciesTesting"),
                .target(name: "TuistLintingTesting"),
                .target(name: "TuistMigrationTesting"),
                .target(name: "TuistAsyncQueueTesting"),
                .target(name: "TuistGraphTesting"),
                .target(name: "TuistPlugin"),
                .target(name: "TuistPluginTesting"),
                .target(name: "TuistTasksTesting"),
            ],
            integrationTestsDependencies: [
                .target(name: "TuistCoreTesting"),
                .target(name: "TuistSupportTesting"),
                .target(name: "ProjectDescription"),
                .target(name: "ProjectAutomation"),
                .target(name: "TuistLoaderTesting"),
                .target(name: "TuistCloudTesting"),
                .target(name: "TuistGraphTesting"),
            ]
        ),
        Target.module(
            name: "TuistEnvKit",
            hasTesting: false,
            dependencies: [
                .target(name: "TuistSupport"),
            ],
            testDependencies: [
                .target(name: "TuistSupportTesting"),
            ]
        ),
        Target.module(
            name: "TuistGraph",
            dependencies: [
                .target(name: "TuistSupport"),
            ],
            testDependencies: [
                .target(name: "TuistCore"),
                .target(name: "TuistCoreTesting"),
                .target(name: "TuistSupport"),
                .target(name: "TuistSupportTesting"),
            ],
            testingDependencies: [
                .target(name: "TuistSupport"),
                .target(name: "TuistSupportTesting"),
            ]
        ),
        Target.module(
            name: "TuistCore",
            hasIntegrationTests: true,
            dependencies: [
                .target(name: "ProjectDescription"),
                .target(name: "TuistSupport"),
                .target(name: "TuistGraph"),
            ],
            testDependencies: [
                .target(name: "TuistSupport"),
                .target(name: "TuistGraph"),
                .target(name: "TuistSupportTesting"),
                .target(name: "TuistGraphTesting"),
            ],
            testingDependencies: [
                .target(name: "TuistSupport"),
                .target(name: "TuistGraph"),
                .target(name: "TuistSupportTesting"),
                .target(name: "TuistGraphTesting"),
            ],
            integrationTestsDependencies: [
                .target(name: "TuistSupportTesting"),
            ]
        ),
        Target.module(
            name: "TuistGenerator",
            hasIntegrationTests: true,
            dependencies: [
                .target(name: "TuistCore"),
                .target(name: "TuistGraph"),
                .target(name: "TuistSupport"),
                .external(name: "SwiftGenKit"),
            ],
            testDependencies: [
                .target(name: "TuistCoreTesting"),
                .target(name: "TuistSupportTesting"),
                .target(name: "TuistGraphTesting"),
            ],
            testingDependencies: [
                .target(name: "TuistCoreTesting"),
                .target(name: "TuistSupportTesting"),
                .target(name: "TuistGraphTesting"),
            ],
            integrationTestsDependencies: [
                .target(name: "TuistCoreTesting"),
                .target(name: "TuistSupportTesting"),
                .target(name: "TuistGraphTesting"),
                .target(name: "TuistSigningTesting"),
            ]
        ),
        Target.module(
            name: "TuistCloud",
            dependencies: [
                .target(name: "TuistCore"),
                .target(name: "TuistGraph"),
                .target(name: "TuistSupport"),
            ],
            testDependencies: [
                .target(name: "TuistSupportTesting"),
                .target(name: "TuistCoreTesting"),
                .target(name: "TuistGraphTesting"),
            ],
            testingDependencies: [
                .target(name: "TuistCore"),
                .target(name: "TuistGraphTesting"),
            ]
        ),
        Target.module(
            name: "TuistTasks",
            hasTests: false,
            hasIntegrationTests: true,
            dependencies: [
                .target(name: "TuistCore"),
                .target(name: "TuistSupport"),
            ],
            testingDependencies: [
                .target(name: "TuistGraphTesting"),
            ],
            integrationTestsDependencies: [
                .target(name: "TuistSupportTesting"),
                .target(name: "TuistGraphTesting"),
            ]
        ),
        Target.module(
            name: "TuistCache",
            hasIntegrationTests: true,
            dependencies: [
                .target(name: "TuistCore"),
                .target(name: "TuistGraph"),
                .target(name: "TuistSupport"),
                .target(name: "TuistCloud"),
            ],
            testDependencies: [
                .target(name: "TuistCore"),
                .target(name: "TuistGraph"),
                .target(name: "TuistSupport"),
                .target(name: "TuistCloud"),
                .target(name: "TuistSupportTesting"),
                .target(name: "TuistCoreTesting"),
                .target(name: "TuistGraphTesting"),
            ],
            testingDependencies: [
                .target(name: "TuistCore"),
                .target(name: "TuistGraph"),
                .target(name: "TuistSupport"),
                .target(name: "TuistCloud"),
                .target(name: "TuistCoreTesting"),
                .target(name: "TuistGraphTesting"),
                .target(name: "TuistSupportTesting"),
            ],
            integrationTestsDependencies: [
                .target(name: "TuistCore"),
                .target(name: "TuistGraph"),
                .target(name: "TuistSupport"),
                .target(name: "TuistCloud"),
                .target(name: "TuistSupportTesting"),
                .target(name: "TuistCoreTesting"),
                .target(name: "TuistGraphTesting"),
            ]
        ),
        Target.module(
            name: "TuistScaffold",
            hasIntegrationTests: true,
            dependencies: [
                .target(name: "TuistCore"),
                .target(name: "TuistGraph"),
                .target(name: "TuistSupport"),
            ],
            testDependencies: [
                .target(name: "TuistSupportTesting"),
                .target(name: "TuistCoreTesting"),
                .target(name: "TuistGraphTesting"),
            ],
            testingDependencies: [
                .target(name: "TuistGraphTesting"),
            ],
            integrationTestsDependencies: [
                .target(name: "TuistSupportTesting"),
                .target(name: "TuistGraphTesting"),
            ]
        ),
        Target.module(
            name: "TuistLoader",
            hasIntegrationTests: true,
            dependencies: [
                .target(name: "TuistCore"),
                .target(name: "TuistGraph"),
                .target(name: "TuistSupport"),
                .target(name: "ProjectDescription"),
            ],
            testDependencies: [
                .target(name: "TuistGraphTesting"),
                .target(name: "TuistSupportTesting"),
                .target(name: "TuistCoreTesting"),
            ],
            testingDependencies: [
                .target(name: "TuistCore"),
                .target(name: "ProjectDescription"),
                .target(name: "TuistSupportTesting"),
                .target(name: "TuistGraphTesting"),
            ],
            integrationTestsDependencies: [
                .target(name: "TuistGraphTesting"),
                .target(name: "TuistSupportTesting"),
                .target(name: "ProjectDescription"),
            ]
        ),
        Target.module(
            name: "TuistAsyncQueue",
            dependencies: [
                .target(name: "TuistCore"),
                .target(name: "TuistGraph"),
                .target(name: "TuistSupport"),
            ],
            testDependencies: [
                .target(name: "TuistSupportTesting"),
                .target(name: "TuistCoreTesting"),
                .target(name: "TuistGraphTesting"),
            ],
            testingDependencies: [
                .target(name: "TuistGraphTesting"),
            ]
        ),
        Target.module(
            name: "TuistPlugin",
            dependencies: [
                .target(name: "TuistGraph"),
                .target(name: "TuistLoader"),
                .target(name: "TuistSupport"),
                .target(name: "TuistScaffold"),
            ],
            testDependencies: [
                .target(name: "ProjectDescription"),
                .target(name: "TuistLoader"),
                .target(name: "TuistLoaderTesting"),
                .target(name: "TuistGraphTesting"),
                .target(name: "TuistSupport"),
                .target(name: "TuistSupportTesting"),
                .target(name: "TuistScaffoldTesting"),
                .target(name: "TuistCoreTesting"),
            ],
            testingDependencies: [
                .target(name: "TuistGraph"),
            ]
        ),
        Target.module(
            name: "ProjectDescription",
            hasTesting: false,
            testDependencies: [
                .target(name: "TuistSupportTesting"),
                .target(name: "TuistSupport"),
            ]
        ),
        Target.module(
            name: "ProjectAutomation",
            hasTests: false,
            hasTesting: false
        ),
        Target.module(
            name: "TuistSigning",
            hasIntegrationTests: true,
            dependencies: [
                .target(name: "TuistCore"),
                .target(name: "TuistGraph"),
                .target(name: "TuistSupport"),
            ],
            testDependencies: [
                .target(name: "TuistSupportTesting"),
                .target(name: "TuistCoreTesting"),
                .target(name: "TuistGraphTesting"),
            ],
            testingDependencies: [
                .target(name: "TuistGraphTesting"),
            ],
            integrationTestsDependencies: [
                .target(name: "TuistSupportTesting"),
                .target(name: "TuistCoreTesting"),
                .target(name: "TuistGraphTesting"),
            ]
        ),
        Target.module(
            name: "TuistAnalytics",
            hasTesting: false,
            dependencies: [
                .target(name: "TuistAsyncQueue"),
                .target(name: "TuistCloud"),
                .target(name: "TuistCore"),
                .target(name: "TuistGraph"),
                .target(name: "TuistLoader"),
            ],
            testDependencies: [
                .target(name: "TuistSupportTesting"),
                .target(name: "TuistGraphTesting"),
                .target(name: "TuistCoreTesting"),
            ]
        ),
        Target.module(
            name: "TuistMigration",
            hasIntegrationTests: true,
            dependencies: [
                .target(name: "TuistCore"),
                .target(name: "TuistGraph"),
                .target(name: "TuistSupport"),
            ],
            testDependencies: [
                .target(name: "TuistSupportTesting"),
                .target(name: "TuistCoreTesting"),
                .target(name: "TuistGraphTesting"),
            ],
            testingDependencies: [
                .target(name: "TuistGraphTesting"),
            ],
            integrationTestsDependencies: [
                .target(name: "TuistSupportTesting"),
                .target(name: "TuistCoreTesting"),
                .target(name: "TuistGraphTesting"),
            ]
        ),
        Target.module(
            name: "TuistLinting",
            dependencies: [
                .target(name: "TuistCore"),
                .target(name: "TuistGraph"),
                .target(name: "TuistSupport"),
            ],
            testDependencies: [
                .target(name: "TuistCoreTesting"),
                .target(name: "TuistSupportTesting"),
                .target(name: "TuistGraphTesting"),
            ],
            testingDependencies: [
                .target(name: "TuistGraphTesting"),
            ]
        ),
        Target.module(
            name: "TuistDependencies",
            dependencies: [
                .target(name: "ProjectDescription"),
                .target(name: "TuistCore"),
                .target(name: "TuistGraph"),
                .target(name: "TuistSupport"),
            ],
            testDependencies: [
                .target(name: "TuistCoreTesting"),
                .target(name: "TuistGraphTesting"),
                .target(name: "TuistLoaderTesting"),
                .target(name: "TuistSupportTesting"),
            ],
            testingDependencies: [
                .target(name: "TuistGraphTesting"),
            ]
        ),
        Target.module(
            name: "TuistAutomation",
            hasIntegrationTests: true,
            dependencies: [
                .target(name: "TuistCore"),
                .target(name: "TuistGraph"),
                .target(name: "TuistSupport"),
            ],
            testDependencies: [
                .target(name: "TuistSupportTesting"),
                .target(name: "TuistCoreTesting"),
                .target(name: "TuistGraphTesting"),
            ],
            testingDependencies: [
                .target(name: "TuistCore"),
                .target(name: "TuistCoreTesting"),
                .target(name: "ProjectDescription"),
                .target(name: "TuistSupportTesting"),
                .target(name: "TuistGraphTesting"),
            ],
            integrationTestsDependencies: [
                .target(name: "TuistSupportTesting"),
                .target(name: "TuistGraphTesting"),
            ]
        ),
    ]
}

func otherTargets() -> [Target] {
    [
        Target.target(
            name: "tuistenv",
            product: .commandLineTool,
            dependencies: [
                .target(name: "TuistEnvKit"),
            ]
        ),
        Target.target(
            name: "tuist",
            product: .commandLineTool,
            dependencies: [
                .target(name: "TuistKit"),
                .target(name: "ProjectDescription"),
                .target(name: "ProjectAutomation"),
            ]
        ),
        Target.target(
            name: "TuistIntegrationTests",
            product: .unitTests,
            dependencies: [
                .target(name: "TuistGenerator"),
                .target(name: "TuistSupportTesting"),
                .target(name: "TuistSupport"),
                .target(name: "TuistCoreTesting"),
                .target(name: "TuistGraphTesting"),
                .target(name: "TuistLoaderTesting"),
            ]
        ),
    ]
}

let modules = modulesTargetsAndSchemes()

let project = Project(
    name: "Tuist",
    options: [
        .textSettings(indentWidth: 4, tabWidth: 4),
    ],
    settings: .settings(
        configurations: [
            .debug(name: "Debug", settings: debugSettings(), xcconfig: nil),
            .release(name: "Release", settings: releaseSettings(), xcconfig: nil),
        ]
    ),
    targets: otherTargets() + modules.map(\.targets).flatMap { $0 },
    schemes: modules.map(\.scheme),
    additionalFiles: ["CHANGELOG.md"]
)
