import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftDiagnostics

struct XRPCUnionMacro: MemberMacro, ConformanceMacro, MemberAttributeMacro {
    
    struct Case {
        var identifier: TokenSyntax
        var tag: ExprSyntax?
        var type: TypeSyntax
    }
    
    static func expansion(of node: AttributeSyntax, providingMembersOf declaration: some DeclGroupSyntax, in context: some MacroExpansionContext) throws -> [DeclSyntax] {
        
        guard let enumDecl = declaration.as(EnumDeclSyntax.self) else {
            throw DiagnosticsError.xrpc(.invalidType, in: node, message: "'@\(node.attributeName)' cannot be applied to class, struct, or actor types")
        }
        
        let tag = enumDecl.attributes.tag ?? #""type""#
        let publicModifier = enumDecl.modifiers.isPublic ? "public " : ""
        let wantsUnknownCase = enumDecl.attributes.isOpen
        
        let cases = try enumDecl.enumCases.flatMap { enumCase -> [Case] in
            guard enumCase.attributes.tag == nil || enumCase.elements.count == 1 else {
                throw DiagnosticsError.xrpc(.invalidCase, in: enumCase, message: "'@XRPCTag' cannot be applied to multiple cases")
            }
            
            return try enumCase.elements.map { element in
                guard let type = element.onlyType else {
                    throw DiagnosticsError.xrpc(.invalidCase, in: element, message: "'@\(node.attributeName)' cases must have exactly one associated value")
                }
                
                return Case(identifier: element.identifier, tag: enumCase.attributes.tag, type: type)
            }
        }
        
        let unknownCase = wantsUnknownCase ? DeclSyntax("""
        case unknown([Swift.String: XRPC.XRPCUnknown])
        """) : nil
        
        let typeEnum = DeclSyntax("""
        private enum Kind: String, Codable {
            \(generateTypeEnumCases(cases))
        
        }
        """)
        
        let codingKeys = DeclSyntax("""
        private enum CodingKeys: String, CodingKey {
            
            case type = \(tag)
        
        }
        """)
        
        let decode = DeclSyntax("""
        \(raw: publicModifier)init(from decoder: Swift.Decoder) throws {
            let typeContainer = try decoder.container(keyedBy: CodingKeys.self)
            let container = try decoder.singleValueContainer()
            let type = \(generateDecodeTypeExpr(wantsUnknownCase: wantsUnknownCase))
            switch type {
            \(generateDecodeSwitchCases(cases, wantsUnknownCase: wantsUnknownCase))
            }
        }
        """)
        
        let encode = DeclSyntax("""
                \(raw: publicModifier)func encode(to encoder: Swift.Encoder) throws {
            var typeContainer = encoder.container(keyedBy: CodingKeys.self)
            var container = encoder.singleValueContainer()
            switch self {
            \(generateEncodeSwitchCases(cases, wantsUnknownCase: wantsUnknownCase))
            }
        }
        """)
        
        return [ unknownCase, typeEnum, codingKeys, decode, encode ].compactMap { $0 }
    }
    
    static func expansion(of node: AttributeSyntax, providingConformancesOf declaration: some DeclGroupSyntax, in context: some MacroExpansionContext) throws -> [(TypeSyntax, GenericWhereClauseSyntax?)] {
        [ ("Codable", nil) ]
    }
    
    static func expansion(of node: AttributeSyntax, attachedTo declaration: some DeclGroupSyntax, providingAttributesFor member: some DeclSyntaxProtocol, in context: some MacroExpansionContext) throws -> [AttributeSyntax] {
        []
    }
    
    @MemberDeclListBuilder
    static func generateTypeEnumCases(_ cases: [Case]) -> MemberDeclListSyntax {
        for element in cases {
            if let tag = element.tag {
                DeclSyntax("""
                
                case \(element.identifier) = \(tag)
                """)
            } else {
                DeclSyntax("""
                
                case \(element.identifier)
                """)
            }
        }
    }
    
    static func generateDecodeTypeExpr(wantsUnknownCase: Bool) -> ExprSyntax {
        if wantsUnknownCase {
            """
            try? typeContainer.decode(Kind.self, forKey: .type)
            """
        } else {
            """
            try typeContainer.decode(Kind.self, forKey: .type)
            """
        }
    }
    
    @SwitchCaseListBuilder
    static func generateDecodeSwitchCases(_ cases: [Case], wantsUnknownCase: Bool) -> SwitchCaseListSyntax {
        for element in cases {
            """
            case .\(element.identifier):
                self = try .\(element.identifier)(container.decode(\(element.type).self))
            
            """
        }
        
        if wantsUnknownCase {
            """
            case nil:
                self = try .unknown(container.decode([Swift.String: XRPC.XRPCUnknown].self))
            
            """
        }
    }
    
    @SwitchCaseListBuilder
    static func generateEncodeSwitchCases(_ cases: [Case], wantsUnknownCase: Bool) -> SwitchCaseListSyntax {
        for element in cases {
            """
            case .\(element.identifier)(let value):
                try typeContainer.encode(Kind.\(element.identifier), forKey: .type)
                try container.encode(value)
            """
        }
        
        if wantsUnknownCase {
            """
            case .unknown(let value):
                try container.encode(value)
            """
        }
    }

}
