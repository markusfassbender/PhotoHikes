import XCTest

@testable import NetworkService

final class NetworkServiceTests: XCTestCase {
    
    private var mockURLSession: URLSession!
    
    override func setUp() {
        super.setUp()
        
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [
            URLProtocolMock.self
        ]
        mockURLSession = URLSession(configuration: configuration)
    }
    
    override func tearDown() {
        mockURLSession = nil
        super.tearDown()
    }
    
    func testLoad_given500Error_thenThrowError() async throws {
        // given
        let service = makeService()
        let url = try XCTUnwrap(URL(string: "https://apple.com"))
        let request = URLRequest(url: url)
        let response = HTTPURLResponse(url: url, statusCode: 500, httpVersion: nil, headerFields: nil)
        
        URLProtocolMock.mockURLs[url] = (
            error: NetworkServiceMockError.failure,
            data: nil,
            response: response
        )
        
        // when
        // then
        do {
            _ = try await service.load(request)
        } catch {
            // pass with expected error
        }
    }
    
    func testLoad_given200EmptyData_thenReturnEmptyData() async throws {
        // given
        let service = makeService()
        let url = try XCTUnwrap(URL(string: "https://apple.com"))
        let request = URLRequest(url: url)
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        URLProtocolMock.mockURLs[url] = (
            error: nil,
            data: Data(),
            response: response
        )
        
        // when
        let result = try await service.load(request)
        
        // then
        XCTAssertTrue(result.isEmpty)
    }
    
    // MARK: - Helpers
    
    private func makeService() -> NetworkService {
        NetworkService(urlSession: mockURLSession)
    }
}

// MARK: Mock Error

private enum NetworkServiceMockError: Error {
    case failure
}
