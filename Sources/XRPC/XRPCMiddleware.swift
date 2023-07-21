import Foundation

// TODO docs
public protocol XRPCMiddleware: Sendable {
    
    /// Intercepts an outgoing HTTP request and an incoming HTTP response.
    func intercept(_ request: URLRequest, baseURL: URL, serviceName: String, next: (URLRequest) async throws -> (Data, URLResponse)) async throws -> (Data, URLResponse)
    
}
