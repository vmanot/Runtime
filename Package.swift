// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "Runtime",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
        .tvOS(.v13),
        .watchOS(.v6)
    ],
    products: [
        .library(name: "Runtime", targets: ["Runtime"])
    ],
    dependencies: [
        .package(url: "https://github.com/vmanot/Compute.git", .branch("master")),
        .package(url: "https://github.com/vmanot/FoundationX.git", .branch("master")),
        .package(url: "https://github.com/vmanot/Swallow.git", .branch("master"))
    ],
    targets: [
        .target(
            name: "Runtime",
            dependencies: [
                "Compute",
                "FoundationX",
                "Swallow"
            ],
            path: "Sources",
            swiftSettings: [
                .unsafeFlags(["-Onone"])
            ]
        )
    ]
)
