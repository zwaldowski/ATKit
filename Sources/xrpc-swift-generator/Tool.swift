import ArgumentParser
import Foundation
import SwiftSyntax
import UniformTypeIdentifiers

@main
struct Tool: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "xrpc-swift-generator",
        abstract: "A tool for generating Swift code for XRPC definitions.")

    @Option(
        name: .shortAndLong,
        help: "The directory in which to place generated Swift files",
        completion: .directory,
        transform: URL.directory)
    var output: URL

    @Option(
        name: .long,
        help: "Sets the default visibility for generated Swift types and their properties.")
    var visibility = Visibility.internal

    @Option(
        name: [ .customShort("a"), .customLong("alias") ],
        help: ArgumentHelp("Replaces the domain in the names of generated Swift types. Can be specified multiple times.", valueName: "com.example=Example"))
    var aliases = [Alias]()

    @Option(help: "The top-level Swift module name.")
    var moduleName: String

    @Argument(
        help: "Paths to JSON XRPC definitions to convert.",
        completion: .file(extensions: [ "json" ]),
        transform: URL.file)
    var inputs: [URL]

    func run() throws {
        let typeNames = TypeNameGenerator(aliases: aliases)
        let lexicons = try inputs.map { input in
            var lexicon = try Lexicon(contentsOf: input)
            lexicon.swiftTypeNamePrefix = typeNames.makeTypeName(lexicon.id)
            lexicon.swiftIdentifierPrefix = typeNames.makeIdentifier(lexicon.id)
            return lexicon
        }
        let lexiconsByID = lexicons.dictionary()

        for lexicon in lexicons {
            let task = DefinitionFileGenerator(lexicon: lexicon, visibility: visibility, lexiconsByID: lexiconsByID, moduleName: moduleName)
            let definitionFile = try task.generateSourceFile()
            try definitionFile.write(to: output
                .appending(component: lexicon.id)
                .appendingPathExtension(for: .swiftSource))
        }

        let recordsTask = RecordsFileGenerator(lexicons: lexicons, visibility: visibility)
        let records = try recordsTask.generateRecordsFile()
        try records.write(to: output
            .appending(component: "Record")
            .appendingPathExtension(for: .swiftSource))
    }
}
