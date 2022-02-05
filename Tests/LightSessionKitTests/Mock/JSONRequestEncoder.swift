//
//  JSONRequestEncoder.swift
//  
//
//  Created by Marcen, Rafael on 2/10/21.
//

import Foundation
import LightSessionKit

/// Implementation of a `RequestEncoder` for encoding JSON data.
public struct JSONRequestEncoder: RequestEncoder {

    // MARK: - Properties

    /// Closure for creating the json encoder to use for encoding.
    public var createEncoder: () throws -> JSONEncoder

    // MARK: - Init

    /// Creates a `JSONRequestEncoder`.
    ///
    /// - Parameter createEncoder: Closure for creating the encoder to use.
    public init(createEncoder: @escaping () throws -> JSONEncoder = { JSONEncoder() }) {
        self.createEncoder = createEncoder
    }

    // MARK: - RequestEncoder

    public func encode<Body: Encodable>(body: Body, in request: URLRequest, for manager: LightSessionManager) -> URLRequest {
        var request = request

        let encoder = try? createEncoder()
        request.httpBody = try? encoder?.encode(body)

        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        return request
    }
}
