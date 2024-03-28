// The Swift Programming Language
// https://docs.swift.org/swift-book

import OpenAPIRuntime
import OpenAPIVapor
import Vapor
import Fluent
import FluentPostgresDriver


//APIBookService(api: Client(serverURL: try! Servers.server1(), transport: URLSessionTransport()))


/**
struct Book {
    let id : String
    let title : String
    let author : String
}

extension Book {
    static let books: [Book] = [
        Book(id: "1", title: "Siren", author: "Kiera Cass"),
        Book(id: "1", title: "After", author: "Anna Todd")
    ]
} */

@main struct booksServiceServer {
    static func main() async throws {
        
        let app = Vapor.Application()
        
        app.databases.use(DatabaseConfigurationFactory.postgres(configuration: .init(
            hostname: Environment.get("DATABASE_HOST") ?? "localhost",
            port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? SQLPostgresConfiguration.ianaPortNumber,
            username: Environment.get("DATABASE_USERNAME") ?? "vapor_username",
            password: Environment.get("DATABASE_PASSWORD") ?? "vapor_password",
            database: Environment.get("DATABASE_NAME") ?? "vapor_database",
            tls: .prefer(try .init(configuration: .clientDefault)))
        ), as: .psql)
        
        app.migrations.add(CreateBooks())
        try app.autoMigrate().wait()
        
        
        let transport = VaporTransport(routesBuilder: app)
        let handler = Handler(app: app)
        try handler.registerHandlers(on: transport, serverURL: URL(string: "/api")!)
        try await app.execute()
    }
}
