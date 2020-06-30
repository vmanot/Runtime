// swift-tools-version:5.1

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
        .package(url: "git@github.com:vmanot/Compute.git", .branch("master")),
        .package(url: "git@github.com:vmanot/FoundationX.git", .branch("master")),
        .package(url: "git@github.com:vmanot/LinearAlgebra.git", .branch("master")),
        .package(url: "git@github.com:vmanot/Swallow.git", .branch("master"))
    ],
    targets: [
        .target(
            name: "Runtime",
            dependencies: [
                "Compute",
                "FoundationX",
                "LinearAlgebra",
                "Swallow"
            ],
            path: "Sources",
            swiftSettings: [
                .unsafeFlags(["-Onone"])
            ]
        )
    ],
    swiftLanguageVersions: [
        .version("5.1")
    ]
)
