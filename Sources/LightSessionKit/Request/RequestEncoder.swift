//
//  RequestEncoder.swift
//  
//
//  Created by Marcen, Rafael on 2/10/21.
//

import Foundation

/// Protocol used in combination with the `LightSessionManager` for encoding `Encodable` objects into request bodies.
public protocol RequestEncoder {

    /// Called before a request is executed, allowing the adapter to alter it.
    ///
    /// - Parameters:
    ///   - body: The body to encode.
    ///   - request: The request in which to encode the body.
    ///   - manager: The manager which will perform the request.
    /// - Returns: The altered request to be executed.
    func encode<Body: Encodable>(body: Body, in request: URLRequest, for manager: LightSessionManager) -> URLRequest
}
