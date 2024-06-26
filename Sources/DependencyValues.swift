//
//  DependencyValues.swift
//  books-service
//
//  Created by Babeth Velghe on 20/04/2024.
//

import Vapor
import Dependencies

extension DependencyValues {
    var request: Request {
        get { self[RequestKey.self] }
        set { self[RequestKey.self] = newValue }
    }
    
    private enum RequestKey : DependencyKey {
        static var liveValue: Request {
            fatalError("Value of type \(Value.self) is not registered in this context")
        }
    }
}
