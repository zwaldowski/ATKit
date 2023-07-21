import Foundation
import SwiftSyntax

extension Collection {

    var ifNotEmpty: Self? {
        isEmpty ? nil : self
    }

}

extension StringProtocol {

    var firstLetterCapitalized: String {
        prefix(1).capitalized(with: Locale(identifier: "en_US_POSIX")) + dropFirst()
    }

    var firstLetterLowercased: String {
        prefix(1).lowercased(with: Locale(identifier: "en_US_POSIX")) + dropFirst()
    }

}

extension Sequence {

    func isUnique<Key>(by key: (Element) -> Key) -> Bool where Key: Hashable {
        var seen = Set<Key>()
        return allSatisfy { element in
            seen.insert(key(element)).inserted
        }
    }

    func isUnique() -> Bool where Element: Hashable {
        isUnique { $0 }
    }

    func joinedCamelCase() -> String where Element: StringProtocol {
        lazy.filter{ !$0.isEmpty }
            .enumerated()
            .lazy
            .map { $0.offset == 0 ? $0.element.firstLetterLowercased : $0.element.firstLetterCapitalized }
            .joined()
    }
}

extension URL {
    static func directory(_ filePath: String = ".") -> Self {
        Self(filePath: filePath, directoryHint: .isDirectory)
    }

    static func file(_ filePath: String) -> Self {
        Self(filePath: filePath, directoryHint: .notDirectory)
    }
}

extension SyntaxProtocol {
    func write(to url: URL) throws {
        try FileManager.default.createDirectory(at: url.deletingLastPathComponent(), withIntermediateDirectories: true)
        let bytes = Data("\(self)\n".utf8)
        try bytes.write(to: url)
    }
}

extension Collection where Element: Identifiable {
    func dictionary() -> [Element.ID: Element] {
        Dictionary(lazy.map { ($0.id, $0) }, uniquingKeysWith: { first, second in first })
    }
}
