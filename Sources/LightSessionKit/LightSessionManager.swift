//
//  LightSessionManager.swift
//  
//
//  Created by Marcen, Rafael on 2/10/21.
//

import Foundation

open class LightSessionManager {
    
    // MARK: - Public Properties

    /// The base URL to which the manager will perform requests.
    ///
    /// When passing a relative path to perform requests, they will be resolved against this URL to produce
    /// the full absolute URL.
    public var baseURL: URL?
    
    /// The unique id of this manager.
    ///
    /// This value is used for the `sessionDescription`.
    public let uniqueId: String
    
    /// The `URLSessionConfiguration` which is used with the `URLSession` to perform requests.
    public let configuration: URLSessionConfiguration
    
    // MARK: - Handlers

    /// The `RequestAdapter`s to adapt requests before they are performed.
    public var adapters: [RequestAdapter] = []

    /// The `RequestEncoder` to encode `Encodable` objects into a request.
    public var encoder: RequestEncoder?
    
    // MARK: - Private Properties

    private let session: URLSession
    
    // MARK: - Init

    /// Creates an instance of the `HTTPSessionManager`.
    ///
    /// - Parameters:
    ///   - baseURL: The base URL for the manager. The default value is `nil`.
    ///   - configuration: The configuration to use for the `URLSession` of this manager. The default value is `.default`.
    ///   - uniqueId: The unique id for this manager. This value is used for the `sessionDescription`. The default value is created using a `UUID`.
    public init(baseURL: URL? = nil, configuration: URLSessionConfiguration = .default, uniqueId: String = UUID().uuidString) {
        self.baseURL = baseURL
        self.configuration = configuration
        self.uniqueId = uniqueId

        session = URLSession(configuration: configuration)
        session.sessionDescription = "com.LightSessionManager.session.\(uniqueId)"
    }
    
    // MARK: - Create Request

    /// Creates a request to be performed.
    ///
    /// - Parameters:
    ///   - path: The path for the request.
    ///   - method: The HTTP method for the request.
    ///   - parameters: Optional extra query parameters for the request.
    /// - Returns: A promise for when the request is created.
    public func createRequest(withPath path: String, method: HTTPMethod) throws -> URLRequest {
        guard let url = self.getURL(forPath: path) else {
            throw InternalError("Invalid path passed: \(path)")
        }
                    
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        return request
    }
    
    /// Creates a request to be performed.
    ///
    /// - Parameters:
    ///   - path: The path for the request.
    ///   - body: The body for the request.
    ///   - method: The HTTP method for the request.
    ///   - parameters: Optional extra query parameters for the request.
    /// - Returns: The request.
    public func createRequest<Body: Encodable>(withPath path: String, body: Body?, method: HTTPMethod) async throws -> URLRequest {
        guard let url = self.getURL(forPath: path) else {
            throw InternalError("Invalid path passed: \(path)")
        }
            
        guard let encoder = self.encoder else {
            throw InternalError("Cannot perform requests with encodable bodies without setting a RequestEncoder.")            }
            
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        return encoder.encode(body: body, in: request, for: self)
    }
    
    /// Performs a `GET` request and returns the response.
    ///
    /// - Parameters:
    ///   - path: The path for the request.
    ///   - parameters: The query parameters for the request.
    /// - Returns: The response of the request.
    public func get(_ path: String) async throws -> Response {
        try await createRequest(withPath: path, method: .get)
            .prepare({ return await self.adapt($0) })
            .fetch(with: session)
    }
    
    /// Performs a `POST` request and returns the response.
    ///
    /// For this request no response data is decoded.
    ///
    /// - Parameters:
    ///   - path: The path for the request.
    ///   - body: The body to encode into the request.
    /// - Returns: The response of the request.
    public func post<Body: Codable>(_ path: String, body: Body) async throws -> Response {
        try await createRequest(withPath: path, body: body, method: .post)
            .prepare({ return await self.adapt($0) })
            .fetch(with: session)
    }
    
    // MARK: - Private
    
    private func getURL(forPath path: String) -> URL? {
        guard !path.isEmpty else {
            guard let url = baseURL else {
                fatalError("Cannot request an empty path when the base url is `nil`.")
            }
            return url
        }
        return URL(string: path, relativeTo: baseURL)
    }
    
    private func adapt(_ request: URLRequest) async -> URLRequest {
        return await self.adapters.asyncReduce(request) { result, adapter in
            return await adapter.adapt(result, for: self)
        }
    }
}

private extension URLRequest {
    func prepare(_ transform: @escaping (Self) async -> Self) async -> Self {
        return await transform(self)
    }
    
    func fetch(with session: URLSession) async throws -> Response {
        let (data, httpResponse) = try await session.data(for: self)
        return Response(request: self, httpResponse: httpResponse, data: data)
    }
}

private extension Sequence {
    func asyncReduce<Result>(
        _ initialResult: Result,
        _ nextPartialResult: ((Result, Element) async throws -> Result)
    ) async rethrows -> Result {
        var result = initialResult
        for element in self {
            result = try await nextPartialResult(result, element)
        }
        return result
    }
}
