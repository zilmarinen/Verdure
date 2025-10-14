// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Verdure",
    platforms: [.macOS(.v15),
                .iOS(.v17)],
    products: [
        .library(name: "Verdure",
                 targets: ["Verdure"]),
    ],
    dependencies: [
//        .package(url: "git@github.com:zilmarinen/Deltille.git",
//                 branch: "main"),
        .package(path: "../Alluvium"),
        .package(path: "../Deltille"),
        .package(url: "git@github.com:nicklockwood/Euclid.git", 
                 branch: "main"),
        .package(path: "../Lattice"),
    ],
    targets: [
        .target(name: "Verdure",
                dependencies: ["Alluvium",
                               "Deltille",
                               "Euclid",
                               "Lattice"]),
    ]
)
