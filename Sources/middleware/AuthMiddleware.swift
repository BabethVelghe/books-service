//
//  File.swift
//  
//
//  Created by Babeth Velghe on 08/04/2024.
//

import Vapor
import Dependencies

enum TaskLocals {
    @TaskLocal
    static var authorization: String?
}

struct AuthMiddleware : AsyncBasicAuthenticator {
    //typealias User
    func authenticate(basic: Vapor.BasicAuthorization, for request: Vapor.Request) async throws {
        request.auth.login(User(name: "", email: basic.username, passwordHash: basic.password))
    }
    
    
    
//    func respond(to request: Vapor.Request, chainingTo responder: any AsyncResponder) async throws -> Vapor.Response {
////        try await withDependencies {
////            $0.request = request
////        } operation: {
////            try await responder.respond(to: request)
////        }
////        try await TaskLocals.$authorization.withValue(request.headers.bearerAuthorization) {
////            try await responder.respond(to: request)
////        }
//    }
    
}
