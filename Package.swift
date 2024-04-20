// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "books-service",
    platforms: [
        .macOS(.v13)
    ],dependencies: [
        .package(url: "https://github.com/apple/swift-openapi-generator", from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-openapi-runtime", from: "1.0.0"),
        .package(url: "https://github.com/swift-server/swift-openapi-vapor", from: "1.0.0"),
        .package(url: "https://github.com/vapor/vapor", from: "4.89.0"),
        .package(url: "https://github.com/vapor/fluent.git", from: "4.8.0"),
        .package(url: "https://github.com/vapor/postgres-nio.git", from: "1.14.0"),
        .package(url: "https://github.com/vapor/fluent-postgres-driver.git", from: "2.7.2"),
        .package(url: "https://github.com/apple/swift-log.git", from: "1.5.0"),
        .package(url: "https://github.com/pointfreeco/swift-dependencies", from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-metrics", from: "2.4.1"),
        .package(url: "https://github.com/swift-server/swift-prometheus", exact: "2.0.0-alpha.1"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .executableTarget(
            name: "booksServiceServer",
            dependencies: [
                .product(name: "OpenAPIRuntime", package: "swift-openapi-runtime"),
                .product(name: "OpenAPIVapor", package: "swift-openapi-vapor"),
                .product(name: "Vapor", package: "vapor"),
                .product(name: "Fluent", package: "fluent"),
                .product(name: "FluentPostgresDriver", package: "fluent-postgres-driver"),
                .product(name: "PostgresNIO",package: "postgres-nio"),
                .product(name: "Logging", package: "swift-log"),
                .product(name: "Dependencies", package: "swift-dependencies"),
                .product(name: "Metrics", package: "swift-metrics"),
                .product(name: "Prometheus", package: "swift-prometheus")
            ],
            plugins: [.plugin(name: "OpenAPIGenerator", package: "swift-openapi-generator")]
        ),
    ]
)

