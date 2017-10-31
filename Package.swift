// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SLTools",
    products: [
        .library(
            name: "SLTools",
            targets: ["SLTools"]),
    ],
    dependencies: [
        .package(url: "https://github.com/IBM-Swift/Kitura.git", from: "2.0.0"),
        .package(url: "https://github.com/IBM-Swift/BlueCryptor.git", from: "0.8.18"),
    ],
    targets: [
        .target(
            name: "SLTools",
            dependencies: ["Kitura", "Cryptor"]),
        .testTarget(
            name: "SLToolsTests",
            dependencies: ["SLTools"]),
    ]
)
