import Foundation

extension SettingsDictionary {
    public mutating func merge(_ other: SettingsDictionary) {
        merge(other) { $1 }
    }

    public func merging(_ other: SettingsDictionary) -> SettingsDictionary {
        merging(other) { $1 }
    }
}

extension SettingValue {
    fileprivate init(_ string: String) {
        self = .init(stringLiteral: string)
    }

    fileprivate init(_ bool: Bool) {
        self = .init(booleanLiteral: bool)
    }
}

public enum SwiftCompilationMode: String {
    case singlefile
    case wholemodule
}

public enum SwiftOptimizationLevel: String {
    case o = "-O"
    case oNone = "-Onone"
    case oSize = "-Osize"
}

extension SettingsDictionary {
    // MARK: - Code signing

    /// Sets `"CODE_SIGN_STYLE"` to `"Manual"`,` "CODE_SIGN_IDENTITY"` to `identity`, and `"PROVISIONING_PROFILE_SPECIFIER"` to `provisioningProfileSpecifier`
    public func manualCodeSigning(identity: String? = nil, provisioningProfileSpecifier: String? = nil) -> SettingsDictionary {
        var manualCodeSigning: SettingsDictionary = ["CODE_SIGN_STYLE": "Manual"]
        manualCodeSigning["PROVISIONING_PROFILE_SPECIFIER"] = provisioningProfileSpecifier.map { SettingValue($0) }

        let merged = merging(manualCodeSigning)

        guard let identity = identity else {
            return merged
        }

        return merged.codeSignIdentity(identity)
    }

    /// Sets `"CODE_SIGN_STYLE"` to `"Automatic"` and `"DEVELOPMENT_TEAM"` to `devTeam`
    public func automaticCodeSigning(devTeam: String) -> SettingsDictionary {
        merging([
            "CODE_SIGN_STYLE": "Automatic",
            "DEVELOPMENT_TEAM": SettingValue(devTeam),
        ])
    }

    /// Sets `"CODE_SIGN_IDENTITY"` to `"Apple Development"`
    public func codeSignIdentityAppleDevelopment() -> SettingsDictionary {
        codeSignIdentity("Apple Development")
    }

    /// Sets `"CODE_SIGN_IDENTITY"` to `identity`
    public func codeSignIdentity(_ identity: String) -> SettingsDictionary {
        merging(["CODE_SIGN_IDENTITY": SettingValue(identity)])
    }

    // MARK: - Versioning

    /// Sets `"CURRENT_PROJECT_VERSION"` to `version`
    public func currentProjectVersion(_ version: String) -> SettingsDictionary {
        merging(["CURRENT_PROJECT_VERSION": SettingValue(version)])
    }

    /// Sets `"VERSIONING_SYSTEM"` to `"apple-generic"`
    public func appleGenericVersioningSystem() -> SettingsDictionary {
        merging(["VERSIONING_SYSTEM": "apple-generic"])
    }

    /// Sets "VERSION_INFO_STRING" to `version`. If `prefix` and `suffix` are not `nil`, they're used as `"VERSION_INFO_PREFIX"` and `"VERSION_INFO_SUFFIX"` respectively.
    public func versionInfo(_ version: String, prefix: String? = nil, suffix: String? = nil) -> SettingsDictionary {
        var versionSettings: SettingsDictionary = ["VERSION_INFO_STRING": SettingValue(version)]
        versionSettings["VERSION_INFO_PREFIX"] = prefix.map { SettingValue($0) }
        versionSettings["VERSION_INFO_SUFFIX"] = suffix.map { SettingValue($0) }

        return merging(versionSettings)
    }

    // MARK: - Swift Settings

    /// Sets `"SWIFT_VERSION"` to `version`
    public func swiftVersion(_ version: String) -> SettingsDictionary {
        merging(["SWIFT_VERSION": SettingValue(version)])
    }

    /// Sets `"OTHER_SWIFT_FLAGS"` to `flags`
    public func otherSwiftFlags(_ flags: String...) -> SettingsDictionary {
        merging(["OTHER_SWIFT_FLAGS": SettingValue(flags.joined(separator: " "))])
    }

    /// Sets `"SWIFT_COMPILATION_MODE"` to the available `SwiftCompilationMode` (`"singlefile"` or `"wholemodule"`)
    public func swiftCompilationMode(_ mode: SwiftCompilationMode) -> SettingsDictionary {
        merging(["SWIFT_COMPILATION_MODE": SettingValue(mode)])
    }

    /// Sets `"SWIFT_OPTIMIZATION_LEVEL"` to the available `SwiftOptimizationLevel` (`"-O"`, `"-Onone"` or `"-Osize"`)
    public func swiftOptimizationLevel(_ level: SwiftOptimizationLevel) -> SettingsDictionary {
        merging(["SWIFT_OPTIMIZATION_LEVEL": SettingValue(level)])
    }

    // MARK: - Bitcode

    /// Sets `"ENABLE_BITCODE"` to `"YES"` or `"NO"`
    public func bitcodeEnabled(_ enabled: Bool) -> SettingsDictionary {
        merging(["ENABLE_BITCODE": SettingValue(enabled)])
    }
}
