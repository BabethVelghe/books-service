//
//  File.swift
//  
//
//  Created by Babeth Velghe on 26/02/2024.
//

import Fluent
import Vapor


final class Book: Model, Content {
   static let schema = "books"
    @ID(key: .id)
    var id: UUID?
    @Field(key: "title")
    var title : String
    @Field(key: "author")
    var author : String
    
    init() { }
    
    init(id: UUID? = nil, title: String, author: String) {
        self.id = id
        self.title = title
        self.author = author
    }
    
}

/**
extension Book : Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("title", as: String.self, is: !.empty && .alphanumeric)
        
    }
}
 */


