import SwiftSyntax
import SwiftSyntaxMacros

struct XRPCTagMacro: MemberMacro {
    
    static func expansion(of node: AttributeSyntax, providingMembersOf declaration: some DeclGroupSyntax, in context: some MacroExpansionContext) throws -> [DeclSyntax] {
        []
    }
    
}
