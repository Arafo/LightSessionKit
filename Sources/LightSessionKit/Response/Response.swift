//
//  Response.swift
//  
//
//  Created by Marcen, Rafael on 2/10/21.
//

import Foundation

/// Structure containing all data associated with a response of a request.
public struct Response {
    /// The original request send to the server.
    public var request: URLRequest

    /// The `URLResponse` received from the server.
    public var httpResponse: URLResponse

    /// The optional `Data` received from the server.
    public var data: Data
}
