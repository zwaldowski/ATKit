struct TypeNameGenerator {
    var aliases: [Alias]

    func makeTypeName(_ nsid: String) -> String {
        if let (prefix, suffix) = resolveAlias(nsid) {
            return "\(prefix)\(makeIdentifier(suffix, prefixed: true))"
        } else {
            return makeIdentifier(nsid, prefixed: false)
        }
    }

    func makeIdentifier(_ nsid: String) -> String {
        if let (_, suffix) = resolveAlias(nsid) {
            return makeIdentifier(suffix, prefixed: true).firstLetterLowercased
        } else {
            return makeIdentifier(nsid, prefixed: false).firstLetterLowercased
        }
    }

    private func resolveAlias(_ nsid: String) -> (Substring, Substring)? {
        aliases
            .compactMap { nsid.hasPrefix($0.pattern) ? ($0.prefix, nsid.trimmingPrefix("\($0.pattern).")) : nil }
            .min { $0.0.utf8.count < $1.0.utf8.count }
    }

    private func makeIdentifier(_ nsid: some StringProtocol, prefixed: Bool) -> String {
        nsid.split(separator: ".")
            .dropFirst(prefixed ? 0 : 1)
            .filter { $0 != "defs" }
            .map { $0.firstLetterCapitalized }
            .joined()
    }
}
