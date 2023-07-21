import Foundation
import XRPCSupport

// TODO docs
@XRPCClosed @XRPCTag("$type")
public enum XRPCBlob: Sendable {

    @XRPCTag("blob")
    case ref(Ref)

    // TODO docs
    public struct Ref: Sendable, Hashable, Codable {

        // TODO docs
        public let cid: XRPCLink
        // TODO docs
        public let mimeType: String
        // TODO docs
        public let size: Int64?

        enum CodingKeys: String, CodingKey {
            case cid = "ref", mimeType, size
        }

    }

}
