import Foundation
import XRPCSupport

@XRPCClosed
enum Definition {
    case array(ArrayValue)
    case blob(Blob)
    case boolean(Boolean)
    case bytes(Bytes)
    @XRPCTag("cid-link")
    case cidLink(CIDLink)
    case integer(Integer)
    case null(Null)
    case object(Object)
    @XRPCTag("params")
    case parameters(Parameters)
    case procedure(Procedure)
    case query(Query)
    case record(Record)
    @XRPCTag("ref")
    case reference(Reference)
    case string(StringValue)
    case subscription(Subscription)
    case token(Token)
    case unknown(Unknown)

    struct ArrayValue: Codable {
        var description: String?
        var items: Object.Property
        var minLength: Int?
        var maxLength: Int?
    }

    struct Blob: Codable {
        var description: String?
        var accept: [String]?
        var maxSize: Int?
    }

    struct Boolean: Codable {
        var description: String?
        var `default`: Bool?
        var const: Bool?
    }

    struct Bytes: Codable {
        var description: String?
        var minLength: Int?
        var maxLength: Int?
    }

    struct CIDLink: Codable {
        var description: String?
    }

    struct Integer: Codable {
        var description: String?
        var minimum: Int?
        var maximum: Int?
        var `enum`: [Int]?
        var `default`: Int?
        var const: Int?
    }
    
    struct Null: Codable {
        var description: String?
    }

    struct Object: Codable {
        var description: String?
        var properties: [String: Property]
        var required: [String]?
        var nullable: [String]?
        
        @XRPCClosed
        enum Property {
            indirect case array(ArrayValue)
            case blob(Blob)
            case boolean(Boolean)
            case bytes(Bytes)
            @XRPCTag("cid-link")
            case cidLink(CIDLink)
            case integer(Integer)
            @XRPCTag("ref")
            case reference(Reference)
            case string(StringValue)
            case union(Union)
            case unknown(Unknown)
            
            var description: String? {
                switch self {
                case .array(let value):
                    return value.description
                case .blob(let value):
                    return value.description
                case .boolean(let value):
                    return value.description
                case .bytes(let value):
                    return value.description
                case .cidLink(let value):
                    return value.description
                case .integer(let value):
                    return value.description
                case .reference(let value):
                    return value.description
                case .string(let value):
                    return value.description
                case .union(let value):
                    return value.description
                case .unknown(let value):
                    return value.description
                }
            }
        }

    }

    struct Parameters: Codable {
        var description: String?
        var required: [String]?
        var properties: [String: Property]

        @XRPCClosed
        enum Property {
            indirect case array(ArrayValue)
            case boolean(Boolean)
            case integer(Integer)
            case string(StringValue)

            var description: String? {
                switch self {
                case .array(let value):
                    return value.description
                case .boolean(let value):
                    return value.description
                case .integer(let value):
                    return value.description
                case .string(let value):
                    return value.description
                }
            }

            struct ArrayValue: Codable {
                var description: String?
                var items: Property
                var minLength: Int?
                var maxLength: Int?
                
                @XRPCClosed
                enum Item {
                    case boolean(Boolean)
                    case integer(Integer)
                    case string(StringValue)
                    case unknown(Unknown)
                }
            }
        }
    }

    struct Procedure: Codable {
        var description: String?
        var parameters: Parameters?
        var input: Body?
        var output: Body?
        var errors: [ErrorValue]?

        struct Body: Codable {
            var description: String?
            var encoding: String
            var schema: Schema?
            
            @XRPCClosed
            enum Schema {
                case object(Object)
                @XRPCTag("ref")
                case reference(Reference)
                case union(Union)
            }
        }

        struct ErrorValue: Codable {
            var description: String?
            var name: String
        }
    }

    struct Query: Codable {
        var description: String?
        var parameters: Parameters?
        var output: Procedure.Body
        var errors: [Procedure.ErrorValue]?
    }

    struct Record: Codable {
        var description: String?
        var key: String
        var record: Object
    }

    struct Reference: Codable {
        var description: String?
        var ref: String
    }

    struct StringValue: Codable {
        var description: String?
        var format: Format?
        var minLength: Int?
        var maxLength: Int?
        var minGraphemes: Int?
        var maxGraphemes: Int?
        var knownValues: [String]?
        var `enum`: [String]?
        var `default`: String?
        var `const`: String?

        struct Format: RawRepresentable, Hashable, Codable {
            let rawValue: String

            static let atIdentifier = Self(rawValue: "at-identifier")
            static let atURI = Self(rawValue: "at-uri")
            static let cid = Self(rawValue: "cid")
            static let dateTime = Self(rawValue: "datetime")
            static let did = Self(rawValue: "did")
            static let handle = Self(rawValue: "handle")
            static let language = Self(rawValue: "language")
            static let nsid = Self(rawValue: "nsid")
            static let uri = Self(rawValue: "uri")
        }
    }

    struct Subscription: Codable {
        var description: String?
        var parameters: Parameters?
        var message: Message?
        var errors: [Procedure.ErrorValue]?

        struct Message: Codable {
            var description: String?
            var schema: Procedure.Body.Schema
        }
    }

    struct Token: Codable {
        var description: String?
    }

    struct Union: Codable {
        var description: String?
        var refs: [String]
        var closed: Bool?
    }

    struct Unknown: Codable {
        var description: String?
    }

    var description: String? {
        switch self {
        case .array(let value):
            return value.description
        case .blob(let value):
            return value.description
        case .boolean(let value):
            return value.description
        case .bytes(let value):
            return value.description
        case .cidLink(let value):
            return value.description
        case .integer(let value):
            return value.description
        case .null(let value):
            return value.description
        case .object(let value):
            return value.description
        case .parameters(let value):
            return value.description
        case .procedure(let value):
            return value.description
        case .query(let value):
            return value.description
        case .record(let value):
            return value.description
        case .reference(let value):
            return value.description
        case .string(let value):
            return value.description
        case .subscription(let value):
            return value.description
        case .token(let value):
            return value.description
        case .unknown(let value):
            return value.description
        }
    }
}
