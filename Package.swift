// swift-tools-version:4.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwifQLVapor",
    products: [
        .library(name: "SwifQLVapor", targets: ["SwifQLVapor"]),
        ],
    dependencies: [
        .package(url: "https://github.com/MihaelIsaev/SwifQL.git", from:"1.0.0"),
        .package(url: "https://github.com/apple/swift-nio.git", from: "1.10.0"),
        .package(url: "https://github.com/vapor/core.git", from: "3.0.0"),
        .package(url: "https://github.com/vapor/postgresql.git", from: "1.0.0"),
        .package(url: "https://github.com/vapor/mysql.git", from: "3.0.0"),
        ],
    targets: [
        .target(name: "SwifQLVapor", dependencies: ["NIO", "Core", "SwifQL", "MySQL", "PostgreSQL"]),
        .testTarget(name: "SwifQLVaporTests", dependencies: ["SwifQLVapor"]),
        ],
    swiftLanguageVersions: [.v4_2]
)
