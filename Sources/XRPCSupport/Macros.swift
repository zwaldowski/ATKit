@attached(member, names: named(unknown), named(Kind), named(CodingKeys), named(init(from:)), named(encode(to:)))
@attached(conformance)
public macro XRPCOpen() = #externalMacro(module: "XRPCMacros", type: "XRPCUnionMacro")

@attached(member, names: named(Kind), named(CodingKeys), named(init(from:)), named(encode(to:)))
@attached(conformance)
public macro XRPCClosed() = #externalMacro(module: "XRPCMacros", type: "XRPCUnionMacro")

@attached(member)
public macro XRPCTag(_ tag: StaticString) = #externalMacro(module: "XRPCMacros", type: "XRPCTagMacro")
