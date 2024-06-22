// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Verdure",
    platforms: [.macOS(.v12),
                .iOS(.v13)],
    products: [
        .library(
            name: "Verdure",
            targets: ["Verdure"]),
    ],
    dependencies: [
        .package(url: "git@github.com:zilmarinen/Deltille.git",
                 branch: "main"),
        .package(path: "../Bivouac"),
        //.package(url: "git@github.com:nicklockwood/Euclid.git", branch: "main"),
        .package(url: "git@github.com:3Squared/PeakOperation.git", branch: "develop"),
        .package(path: "../Euclid")
    ],
    targets: [
        .target(
            name: "Verdure",
            dependencies: ["Deltille",
                           "Bivouac",
                           "Euclid",
                           "PeakOperation"]),
    ]
)
