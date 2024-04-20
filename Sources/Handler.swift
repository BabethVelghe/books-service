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
import Logging
import Dependencies

struct Handler: APIProtocol {
    @Dependency(\.request) var request
    // let passwordProtected : RoutesBuilder
    
    var logger : Logger =  .init(label: "my-Handler")
    let app : Application
    
    init(app: Application , logger: Logger ) {
        self.app = app
        //self.passwordProtected = passwordProtected
    }
    
    func getAllBooks(_ input: Operations.getAllBooks.Input) async throws -> Operations.getAllBooks.Output {
        let books = try await Book.query(on: app.db).all()
        logger.info("successfull GET-request to database")
        
        var booksArray: Array<Components.Schemas.Book> = []
        books.forEach { book in
            booksArray.append(Components.Schemas.Book(id: "\(String(describing: book.id))", title: book.title, author: book.author))
        }
        logger.info("Converted books of database to return object")
        return .ok(.init(body: .json(booksArray)))

        
        // return .ok(.init(body: .json([Components.Schemas.Book(id: "", title: "", author: "")])))
        
    }
    
    func getById(_ input: Operations.getById.Input) async throws -> Operations.getById.Output {
        let id = UUID(uuidString: input.path.id)
        guard let book = try await Book.find(id, on: app.db) else {
            logger.debug("Can't find Book in database!")
            throw Abort(.notFound)
        }
        
        return .ok(.init(body: .json(Components.Schemas.Book(id: "\(String(describing: book.id))", title: book.title, author: book.author))))
        
    }
    
    
    func createBook(_ input: Operations.createBook.Input) async throws -> Operations.createBook.Output {
        guard case .json(let bookInput) = input.body else {
            logger.debug("Something went wrong with the Input.body")
            fatalError()
        }
      
        let id = UUID(uuidString: bookInput.id)
        var book = Book(id: id, title: bookInput.title, author: bookInput.author)
        try await book.save(on: app.db)
        
        let bookapi: Components.Schemas.Book
            switch input.body {
                case .json(let json): bookapi = json
                case .none:
                    bookapi = .init(id: "", title: "", author: "")
                    break
        }
        
        return .created(.init(body: .json(bookapi)))
    }
    
    func updateBook(_ input: Operations.updateBook.Input) async throws -> Operations.updateBook.Output {
        guard case .json(let bookInput) = input.body else {
            logger.debug("Something went wrong with the Input.body")
            fatalError()
        }
        let id = UUID(uuidString: bookInput.id)
        guard let bookDb = try await Book.find(id, on: app.db) else {
            throw Abort(.notFound)
        }
        bookDb.id = UUID(uuidString: bookInput.id)
        bookDb.title = bookInput.title
        bookDb.author = bookInput.author
            
        try await bookDb.update(on: app.db)
        
        let updatedBook: Components.Schemas.Book
            switch input.body {
                case .json(let json): updatedBook = json
                case .none:
                    updatedBook = .init(id: "", title: "", author: "")
                    break
        }
        return .ok(.init(body: .json(updatedBook)))
         

    }
    func createUser(_ input: Operations.createUser.Input) async throws -> Operations.createUser.Output {
        guard case .json(let userInput) = input.body else {
            fatalError()
        }
        
        let userCreate = User.Create(name: userInput.name, email: userInput.email, password: userInput.password, confirmPassword: userInput.confirmPassword)
        
        guard userInput.password == userInput.confirmPassword else {
            throw Abort(.badRequest, reason: "Passwords did not match")
        }
        
        
        let user = try User(
            name: userCreate.name,
            email: userCreate.email,
            passwordHash: Bcrypt.hash(userCreate.password)
        )
        // Save the user to the database
        try await user.save(on: app.db)
        
        
        
        let userapi = Components.Schemas.User(name: user.name , email: user.email, passwordHash: user.passwordHash)

        return .created(.init(body: .json(userapi)))
    }
    

    
    
 /**   func login(_ input: Operations.login.Input) async throws -> Operations.login.Output {
        guard case .json(let userInput) = input.body else {
            fatalError()
        }
        
        // Authenticate the user
        
        guard let user = try req.auth.require(User.self) else {
            throw Abort(.unauthorized, reason: "Invalid email or password")
        }

        // Generate the user token
        let token = try user.generateToken()

        // Save the token to the database
        try await token.save(on: app.db)

        // Return the generated token
        //return Operations.login.Output(token: token)
    } */
    
}
