// TODO docs
public enum XRPCUnknown: Sendable, Equatable, Codable {
    
    case string(String)
    case number(Int)
    case boolean(Bool)
    case object([String: XRPCUnknown])
    case array([XRPCUnknown])
    case null
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .string(let value):
            try container.encode(value)
        case .number(let value):
            try container.encode(value)
        case .boolean(let bool):
            try container.encode(bool)
        case .object(let object):
            try container.encode(object)
        case .array(let array):
            try container.encode(array)
        case .null:
            try container.encodeNil()
        }
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let value = try? container.decode(String.self) {
            self = .string(value)
        } else if let value = try? container.decode(Int.self) {
            self = .number(value)
        } else if let value = try? container.decode(Bool.self) {
            self = .boolean(value)
        } else if let value = try? container.decode([String: XRPCUnknown].self) {
            self = .object(value)
        } else if let value = try? container.decode([XRPCUnknown].self) {
            self = .array(value)
        } else if container.decodeNil() {
            self = .null
        } else {
            let context = DecodingError.Context(codingPath: container.codingPath, debugDescription: "Not a JSON value")
            throw DecodingError.typeMismatch(XRPCUnknown.self, context)
        }
    }

}
