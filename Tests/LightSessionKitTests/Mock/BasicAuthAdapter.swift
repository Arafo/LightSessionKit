//
//  BasicAuthAdapter.swift
//  
//
//  Created by Marcen, Rafael on 2/10/21.
//

import Foundation
import LightSessionKit

public class BasicAuthAdapter: RequestAdapter {
    
    public let value: String = "Basic \(UUID().description)"
    public let header: String = "Authorization"

    // MARK: - Init
    
    public init() {}
    
    // MARK: - RequestAdapter

    public func adapt(_ request: URLRequest, for manager: LightSessionManager) -> URLRequest {
        var request = request
        request.setValue(value, forHTTPHeaderField: header)
        return request
    }
}
