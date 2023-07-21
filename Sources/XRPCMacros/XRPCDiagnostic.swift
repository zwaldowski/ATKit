import SwiftDiagnostics
import SwiftSyntax

struct XRPCDiagnostic: DiagnosticMessage {
    
    enum ID: String {
        case invalidType = "invalid type"
        case invalidCase = "invalid case"
    }
    
    var id: ID
    var message: String
    var severity: DiagnosticSeverity {
        .error
    }
    
    var diagnosticID: MessageID {
        MessageID(domain: "XRPC", id: id.rawValue)
    }
    
}

extension DiagnosticsError {
    
    static func xrpc(_ id: XRPCDiagnostic.ID, in syntax: some SyntaxProtocol, message: String) -> Self {
        Self(diagnostics: [
            Diagnostic(node: Syntax(syntax), message: XRPCDiagnostic(id: id, message: message))
        ])
    }
    
}
