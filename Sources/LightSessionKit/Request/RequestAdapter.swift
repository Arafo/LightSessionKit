//
//  RequestAdapter.swift
//  
//
//  Created by Marcen, Rafael on 2/10/21.
//

import Foundation

/// Protocol used in combination with the `LightSessionManager` for adapting any request before they are performed.
public protocol RequestAdapter {

    /// Called before a request is executed, allowing the adapter to alter it.
    ///
    /// - Parameters:
    ///   - request: The request that will be executed.
    ///   - manager: The manager which will perform the request.
    /// - Returns: The altered request to be executed.
    func adapt(_ request: URLRequest, for manager: LightSessionManager) async -> URLRequest
}
