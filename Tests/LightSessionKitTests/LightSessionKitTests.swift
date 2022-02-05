import XCTest
@testable import LightSessionKit

final class LightSessionKitTests: XCTestCase {
                    
    private let session = LightSessionManager(baseURL: URL(string: "https://jsonplaceholder.typicode.com"))
        
    public override func tearDown() {
        session.adapters.removeAll()
        session.encoder = nil
    }
        
    func test_get_post() async {
        XCTAssertNotNil(session.baseURL)
            
        let expectation = expectation(description: "Void test")
        
        do {
            _ = try await session.get("/posts/1")
            expectation.fulfill()
        } catch {}

        await waitForExpectations(timeout: 3, handler: nil)
    }
    
    func test_get_posts() async {
        XCTAssertNotNil(session.baseURL)
            
        let expectation = expectation(description: "Void test")
            
        do {
            _ = try await session.get("/posts")
                .decode([Post].self, decoder: JSONDecoder())
            expectation.fulfill()
        } catch {}

        await waitForExpectations(timeout: 3, handler: nil)
    }
    
    func test_get_post_basic_auth_adapter() async {
        let adapter = BasicAuthAdapter()
        session.adapters.append(adapter)
    
        let expectation = expectation(description: "Void test")
        do {
            let response = try await session.get("/posts/1")
            let header = response.request.allHTTPHeaderFields?[adapter.header]
            XCTAssertEqual(header, adapter.value)
            expectation.fulfill()
        } catch {}
        await waitForExpectations(timeout: 10, handler: nil)
    }
        
    func test_post() async {
        XCTAssertNotNil(session.baseURL)
        
        session.encoder = JSONRequestEncoder()
            
        let expectation = expectation(description: "Void test")
            
        let post = Post(userId: 1, id: 1, title: "test", body: "test")
        do {
            _ = try await session.post("/posts", body: post)
            expectation.fulfill()
        } catch {}
            
        await waitForExpectations(timeout: 10, handler: nil)
    }
        
    func test_post_json_encoder() async {
        XCTAssertNotNil(session.baseURL)
            
        session.encoder = JSONRequestEncoder()
            
        let expectation = expectation(description: "Void test")
            
        let post = Post(userId: 1, id: 1, title: "test", body: "test")
        do {
            let response = try await session.post("/posts", body: post)
            let header = response.request.allHTTPHeaderFields?["Content-Type"]
            XCTAssertEqual(header, "application/json; charset=UTF-8")
            expectation.fulfill()
        } catch {}
            
        await waitForExpectations(timeout: 3, handler: nil)
    }
}
