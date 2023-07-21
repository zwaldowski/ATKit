// swift-tools-version: 5.9

import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "ATKit",
    platforms: [
        .iOS(.v16),
        .macOS(.v13)
    ],
    products: [
        .library(name: "ATKit", targets: [ "ATKit" ]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.2.0"),
        .package(url: "https://github.com/apple/swift-syntax.git", exact: "509.0.0-swift-DEVELOPMENT-SNAPSHOT-2023-06-17-a")
    ],
    targets: [
        // Client Library
        .target(
            name: "ATKit",
            dependencies: [ "XRPC" ],
            plugins: [ "XRPCGenerator" ]),

        // Support Library
        .target(
            name: "XRPC",
            dependencies: [ "XRPCSupport" ]),

        // Code Generator
        .plugin(
            name: "XRPCGenerator",
            capability: .buildTool,
            dependencies: [ "xrpc-swift-generator" ]),
        .executableTarget(
            name: "xrpc-swift-generator",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "SwiftSyntaxBuilder", package: "swift-syntax"),
                "XRPCSupport"
            ]),

        // Misc
        .target(
            name: "XRPCSupport",
            dependencies: [ "XRPCMacros" ]),
        .macro(
            name: "XRPCMacros",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax")
            ]),
    ]
)
