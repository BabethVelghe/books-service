// The Swift Programming Language
// https://docs.swift.org/swift-book

import OpenAPIRuntime
import OpenAPIVapor
import Vapor
import Fluent
import FluentPostgresDriver
import Logging

@main struct booksServiceServer {
    static func main() async throws {
        
        let app = Vapor.Application()
        var logger : Logger =  .init(label: "BookService")
        logger.logLevel = .trace
        
        logger.info("Setting up database");
        app.databases.use(DatabaseConfigurationFactory.postgres(configuration: .init(
            hostname: Environment.get("DATABASE_HOST") ?? "localhost",
            port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? SQLPostgresConfiguration.ianaPortNumber,
            username: Environment.get("DATABASE_USERNAME") ?? "vapor_username",
            password: Environment.get("DATABASE_PASSWORD") ?? "vapor_password",
            database: Environment.get("DATABASE_NAME") ?? "vapor_database",
            tls: .prefer(try .init(configuration: .clientDefault)))
        ), as: .psql)
        logger.info("Database connection secure");
        logger.info("Setting up migrations...");
        app.migrations.add(CreateBooks())
        app.migrations.add(CreateUser())
        app.migrations.add(CreateUserToken())
        try app.autoMigrate().wait()
        logger.info("migrations successfull added")
        
        
        let transport = VaporTransport(routesBuilder: app)
        let handler = Handler(app: app, logger: logger)
        try handler.registerHandlers(on: transport, serverURL: URL(string: "/api")!)
        try await app.execute()
    }
}
