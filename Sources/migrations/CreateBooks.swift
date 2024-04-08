//
//  File.swift
//  
//
//  Created by Babeth Velghe on 26/02/2024.
//

import Fluent

struct CreateBooks: AsyncMigration {
    func prepare(on database: FluentKit.Database) async throws {
        return try await database.schema("books")
            .id()
            .field("title", .string, .required)
            .field("author", .string)
            .create()
    }
    
    func revert(on database: FluentKit.Database) async throws {
        try await database.schema("hotspots").delete()
    }
    
    
}
