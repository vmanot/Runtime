// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "Runtime",
    platforms: [
        .iOS(.v13),
        .macOS(.v11),
        .tvOS(.v13),
        .watchOS(.v6)
    ],
    products: [
        .library(name: "Runtime", targets: ["RuntimeShims", "Runtime"])
    ],
    dependencies: [
        .package(url: "https://github.com/vmanot/Compute.git", .branch("master")),
        .package(url: "https://github.com/vmanot/FoundationX.git", .branch("master")),
        .package(url: "https://github.com/vmanot/Swallow.git", .branch("master"))
    ],
    targets: [
        .target(
            name: "RuntimeShims",
            path: "Sources/RuntimeShims"
        ),
        .target(
            name: "Runtime",
            dependencies: [
                "Compute",
                "FoundationX",
                "RuntimeShims",
                "Swallow"
            ],
            path: "Sources/Runtime"
        )
    ]
)
