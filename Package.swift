// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Verdure",
    platforms: [.macOS(.v11),
                .iOS(.v13)],
    products: [
        .library(
            name: "Verdure",
            targets: ["Verdure"]),
    ],
    dependencies: [
        .package(url: "git@github.com:nicklockwood/Euclid.git", branch: "main"),
        .package(path: "../Bivouac"),
    ],
    targets: [
        .target(
            name: "Verdure",
            dependencies: ["Bivouac", "Euclid"]),
    ]
)
