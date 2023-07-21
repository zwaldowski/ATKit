import Foundation

// TODO docs
public protocol XRPCRequest: Sendable {
    
    // TODO docs
    associatedtype Input: Sendable = Void
    
    // TODO docs
    associatedtype Output: Sendable = Void
    
    /// The identifier of the procedure used with the remote service.
    static var name: String { get }
    // TODO docs
    static var httpMethod: String { get }
    
    // TODO docs
    var urlQueryItems: [URLQueryItem] { get }

}

public extension XRPCRequest {
    
    var urlQueryItems: [URLQueryItem] { [] }

}
