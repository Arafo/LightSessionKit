//
//  HTTPMethod.swift
//  
//
//  Created by Marcen, Rafael on 2/10/21.
//

import Foundation

/// HTTP method to use for `URLRequest`s made by `LightSessionManager`.
public enum HTTPMethod: String {
    case options = "OPTIONS"
    case get = "GET"
    case head = "HEAD"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
    case trace = "TRACE"
    case connect = "CONNECT"
}
