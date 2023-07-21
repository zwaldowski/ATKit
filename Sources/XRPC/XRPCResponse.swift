import Foundation
import SwiftUI
import Foundation

// TODO docs
public protocol XRPCResponseKey {
    
    // TODO docs
    associatedtype Value: Sendable
    
    // TODO docs
    static var name: String { get }

}

// TODO docs
public struct XRPCResponse<Output> where Output: Decodable {
    
    // TODO docs
    public let output: Output
    
    // TODO docs
    let response: HTTPURLResponse

}
