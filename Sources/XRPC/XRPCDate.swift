import Foundation

// TODO docs
public struct XRPCDate: RawRepresentable, Sendable, Hashable, Codable {
    
    public internal(set) var rawValue: String
    public init?(rawValue: String) {
        guard let date = try? Date(rawValue, strategy: .xrpc) else { return nil }
        self.rawValue = rawValue
        self.date = date
    }
    
    // TODO docs
    public var date: Date {
        didSet {
            rawValue = date.formatted(.xrpc)
        }
    }
    
    // TODO docs
    public init(date: Date) {
        self.date = date
        self.rawValue = date.formatted(.xrpc)
    }

}
