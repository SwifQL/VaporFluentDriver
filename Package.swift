// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwifQLVapor",
    platforms: [
       .macOS(.v10_14)
    ],
    products: [
        .library(name: "SwifQLVapor", targets: ["SwifQLVapor"]),
        ],
        dependencies: [
        .package(url: "https://github.com/MihaelIsaev/SwifQL.git", from:"1.0.0"),
        .package(url: "https://github.com/MihaelIsaev/SwifQLNIO.git", from:"2.0.0"),
        .package(url: "https://github.com/apple/swift-nio.git", from: "2.10.0"),
        .package(url: "https://github.com/vapor/vapor.git", from: "4.0.0-beta.2"),
        .package(url: "https://github.com/vapor/fluent.git", from: "4.0.0-beta.2"),
        .package(url: "https://github.com/vapor/fluent-postgres-driver.git", from: "2.0.0-beta.2"),
        //.package(url: "https://github.com/vapor/fluent-mysql-driver.git", from: "4.0.0-beta.2"),
        ],
    targets: [
        .target(name: "SwifQLVapor", dependencies: ["NIO", "SwifQL", "SwifQLNIO", "Fluent", "FluentPostgresDriver", "Vapor"]),
        .testTarget(name: "SwifQLVaporTests", dependencies: ["SwifQLVapor"]),
        ]
)
