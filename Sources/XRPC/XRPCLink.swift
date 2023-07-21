import Foundation

// TODO docs
public struct XRPCLink: RawRepresentable, Sendable, Hashable, Codable {

    public let rawValue: String
    public init(rawValue: String) {
        self.rawValue = rawValue
    }

    enum CodingKeys: String, CodingKey {
        case link = "$link"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.rawValue = try container.decode(String.self, forKey: .link)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(rawValue, forKey: .link)
    }

}
