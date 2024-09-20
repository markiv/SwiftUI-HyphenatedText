// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftUI-Hyphenated-Text",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "SwiftUI-Hyphenated-Text",
            targets: ["SwiftUI-Hyphenated-Text"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "SwiftUI-Hyphenated-Text"),
        .testTarget(
            name: "SwiftUI-Hyphenated-TextTests",
            dependencies: ["SwiftUI-Hyphenated-Text"]
        ),
    ]
)
