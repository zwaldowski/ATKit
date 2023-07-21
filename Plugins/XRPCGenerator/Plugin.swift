import Foundation
import PackagePlugin

@main
struct Plugin: BuildToolPlugin {

    /// The configuration for the plugin.
    struct Configuration: Codable {
        
        /// The visibility of the generated files.
        enum Visibility: String, Codable {
            /// The generated files should have `internal` access level.
            case `internal`
            /// The generated files should have `public` access level.
            case `public`
        }
        
        /// The visibility of the generated files.
        var visibility: Visibility?
        
        /// Relative path from the target directory to where lexicons are located.
        var lexicons: String?
        
        /// Replaces domain(s) in the names of generated Swift types.
        var alias: [String: String]?

    }

    func createBuildCommands(context: PluginContext, target: Target) throws -> [PackagePlugin.Command] {
        let target = target as! SwiftSourceModuleTarget
        let tool = try context.tool(named: "xrpc-swift-generator")

        let configurationPath = target.directory.appending(subpath: "xrpc-swift.json")
        let configurationURL = URL(fileURLWithPath: "\(configurationPath)")
        let configurationData = try Data(contentsOf: configurationURL)
        let configuration = try JSONDecoder().decode(Configuration.self, from: configurationData)

        let lexicons = configuration.lexicons ?? "lexicons"
        let lexiconsSubpath = lexicons.hasSuffix("/") ? lexicons : "\(lexicons)/"
        let lexiconsPath = target.directory.appending(subpath: lexiconsSubpath)
        let sourcePaths = target
            .sourceFiles(withSuffix: "json")
            .map(\.path)
            .filter { $0.string.hasPrefix(lexiconsPath.string) }

        let outputPath = context.pluginWorkDirectory

        var arguments = [
            "--output=\(outputPath)",
            "--module-name=\(target.moduleName)"
        ]

        if let visiblity = configuration.visibility {
            arguments.append("--visibility=\(visiblity.rawValue)")
        }

        for (key, value) in configuration.alias ?? [:] {
            arguments.append("--alias")
            arguments.append("\(key)=\(value)")
        }

        arguments.append(contentsOf: sourcePaths.map(\.string))

        let inputFiles = [ configurationPath ] + sourcePaths
        let outputFiles = [ outputPath.appending("Record.swift") ] + sourcePaths.map {
            outputPath.appending("\(lexiconID(from: $0, lexiconsPath: lexiconsPath)).swift")
        }

        return [ .buildCommand(
            displayName: "Generating XRPC lexicon",
            executable: tool.path,
            arguments: arguments,
            inputFiles: inputFiles,
            outputFiles: outputFiles) ]
    }

    func lexiconID(from path: Path, lexiconsPath: Path) -> some StringProtocol {
        path.removingLastComponent()
            .appending(path.stem)
            .string
            .trimmingPrefix("\(lexiconsPath)")
            .replacing("/", with: ".")
    }
}
