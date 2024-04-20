// The Swift Programming Language
// https://docs.swift.org/swift-book

import OpenAPIRuntime
import OpenAPIVapor
import Vapor
import Fluent
import FluentPostgresDriver
import Logging
import Metrics
import Prometheus

@main struct booksServiceServer {
    static func main() async throws {
        let registry = PrometheusCollectorRegistry()
        MetricsSystem.bootstrap(PrometheusMetricsFactory(registry: registry))
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
        
        app.get("metrics") { request in
            var buffer: [UInt8] = []
            buffer.reserveCapacity(1024)
            registry.emit(into: &buffer)
            return String(decoding: buffer, as: UTF8.self)
        }
        
//        let passwordProtected = app.grouped(User.authenticator())
//        passwordProtected.post("login") { req async throws -> UserToken in
//            let user = try req.auth.require(User.self)
//            let token = try user.generateToken()
//            try await token.save(on: req.db)
//            return token
//        }
        
        let authMiddleware = AuthMiddleware()
        app.middleware.use(authMiddleware as Middleware)
        //let transport = VaporTransport(routesBuilder: app.grouped(authMiddleware))
        let transport = VaporTransport(routesBuilder: app)
        let handler = Handler(app: app, logger: logger)
        try handler.registerHandlers(on: transport, serverURL: Servers.server1(), middlewares: [MetricsMiddleware(counterPrefix: "BooksServiceServer")])
        
        let host = ProcessInfo.processInfo.environment["HOST"] ?? "localhost"
        let port = ProcessInfo.processInfo.environment["PORT"].flatMap(Int.init) ?? 8080
        
        app.http.server.configuration.address = .hostname(host, port: port)
        try await app.execute()
    }
}
