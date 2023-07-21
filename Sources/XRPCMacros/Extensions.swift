import SwiftSyntax

extension Collection {
    
    var only: Element? {
        guard let first,
              dropFirst().isEmpty else { return nil }
        return first
    }
    
}

extension ModifierListSyntax? {
    
    var isPublic: Bool {
        self?.contains { $0.name.tokenKind == .keyword(.public) } == true
    }
    
}

extension AttributeListSyntax? {
    
    var tag: ExprSyntax? {
        self?.lazy.compactMap { element in
            guard case .attribute(let attribute) = element,
                  let identifier = attribute.attributeName.as(SimpleTypeIdentifierSyntax.self),
                  identifier.name.text == "XRPCTag",
                  let arguments = attribute.argument?.as(TupleExprElementListSyntax.self),
                  let tagName = arguments.first(where: { $0.label == nil })
            else { return nil }
            return tagName.expression
        }.first
    }
    
    var isOpen: Bool {
        self?.contains { element in
            guard case .attribute(let attribute) = element,
                  let identifier = attribute.attributeName.as(SimpleTypeIdentifierSyntax.self) else { return false }
            return identifier.name.text == "XRPCOpen"
        } == true
    }
    
}

extension EnumDeclSyntax {

    var enumCases: [EnumCaseDeclSyntax] {
        memberBlock.members.compactMap { member in
            guard let caseDecl = member.as(MemberDeclListItemSyntax.self)?
                .decl.as(EnumCaseDeclSyntax.self) else { return nil }
            return caseDecl
        }
    }
    
}

extension EnumCaseElementSyntax {

    var onlyType: TypeSyntax? {
        associatedValue?.parameterList.only?.type
    }
    
}
