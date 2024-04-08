//
//  File.swift
//  
//
//  Created by Babeth Velghe on 08/04/2024.
//

import Fluent
import Vapor
import OpenAPIVapor
import HTTPTypes
import OpenAPIRuntime

enum TaskLocals {

    @TaskLocal
    static var authorization: String?
}

struct AuthMiddleware : ServerMiddleware {
    public func intercept(
        _ request: HTTPRequest,
        body: HTTPBody?,
        metadata: ServerRequestMetadata,
        operationID: String,
        next: @Sendable (HTTPRequest, HTTPBody?, ServerRequestMetadata)
            async throws -> (HTTPResponse, HTTPBody?)
    ) async throws -> (HTTPResponse, HTTPBody?) {
        let auth = request.headerFields[.authorization]
        return try await TaskLocals.$authorization.withValue(auth) {
            try await next(request, body, metadata)
        }
    }
}
