import Foundation

struct XRPCDateFormatStyle {
    
    let primary = Date.ISO8601FormatStyle(includingFractionalSeconds: true)
    let secondary = Date.ISO8601FormatStyle()

}

extension XRPCDateFormatStyle: Codable {

    init(from decoder: Decoder) {}
    func encode(to encoder: Encoder) {}

}

extension XRPCDateFormatStyle: ParseableFormatStyle {

    func format(_ value: Date) -> String {
        primary.format(value)
    }
    
    var parseStrategy: Self {
        self
    }

}

extension XRPCDateFormatStyle: ParseStrategy {
    
    func parse(_ value: String) throws -> Date {
        do {
            return try primary.parse(value)
        } catch {
            return try secondary.parse(value)
        }
    }

}

extension ParseStrategy where Self == XRPCDateFormatStyle {
    
    static var xrpc: Self { Self() }

}

extension FormatStyle where Self == XRPCDateFormatStyle {
    
    static var xrpc: Self { Self() }

}

extension ParseableFormatStyle where Self == XRPCDateFormatStyle {

    static var xrpc: Self { Self() }

}
