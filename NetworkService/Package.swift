// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "NetworkService",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "NetworkService",
            targets: ["NetworkService"])
    ],
    targets: [
        .target(
            name: "NetworkService"),
        .testTarget(
            name: "NetworkServiceTests",
            dependencies: ["NetworkService"])
    ]
)
