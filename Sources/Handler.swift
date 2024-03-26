//
//  File.swift
//  
//
//  Created by Babeth Velghe on 25/03/2024.
//


import OpenAPIRuntime
import OpenAPIVapor
import Vapor
import Fluent
import FluentPostgresDriver

struct Handler: APIProtocol {
    
    let app : Application
    init(app: Application) {
        self.app = app
    }
    
    func getAllBooks(_ input: Operations.getAllBooks.Input) async throws -> Operations.getAllBooks.Output {
        
        guard let database = app.db else {
            throw Abort(.internalServerError, reason: "Failed to initialize database")
        }
        let books = try await Book.query(on: database).all()
        
        var booksArray: Array<Components.Schemas.Book> = []
        books.forEach { book in
            booksArray.append(Components.Schemas.Book(id: "\(String(describing: book.id))", title: book.title, author: book.author))
        }
        return .ok(.init(body: .json(booksArray)))

        
        // return .ok(.init(body: .json([Components.Schemas.Book(id: "", title: "", author: "")])))
        
    }
    
    
}
