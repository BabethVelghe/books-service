//
//  File.swift
//  
//
//  Created by Babeth Velghe on 08/04/2024.
//

import Fluent


struct CreatemyBooks : AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("myBooks")
            .id()
            .field("user_id", .uuid, .required, .references("users", "id"))
            .field("book_id", .string, .required, .references("books", "id"))
            .field("read", .bool)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema("myBooks").delete()
    }
}
