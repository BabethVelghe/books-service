//
//  File.swift
//  
//
//  Created by Babeth Velghe on 08/04/2024.
//
import Fluent
import Vapor

final class myBooks: Model, Content {
    static let schema = "myBooks"
    
    
    @ID(key: .id)
    var id: UUID?
    
    @Parent(key: "user_id")
    var user: User
    @Parent(key: "book_id")
    var book: Book
    
    @Field(key:"read")
    var read : Bool
    
    init() { }
    
    init(id: UUID? = nil, user: User, book: Book, read: Bool) {
        self.id = id
        self.user = user
        self.book = book
        self.read = read
    }
}
