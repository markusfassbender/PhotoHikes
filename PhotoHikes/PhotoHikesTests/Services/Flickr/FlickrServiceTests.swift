//
//  FlickrServiceTests.swift
//  PhotoHikesTests
//
//  Created by Markus on 29.07.24.
//

import XCTest

@testable import PhotoHikes
@testable import NetworkService

final class FlickrServiceTests: XCTestCase {
    
    private var mockNetworkService: NetworkServiceMock!
    
    override func setUp() {
        super.setUp()
        mockNetworkService = NetworkServiceMock()
    }
    
    override func tearDown() {
        mockNetworkService = nil
        super.tearDown()
    }
    
    func testLoadImageList_givenError_thenThrowsError() async throws {
        // given
        let service = makeService()
        
        mockNetworkService.load_mockMethod = { _ in
            throw MockError.failure
        }
        
        // when
        // then
        do {
            _ = try await service.loadImageList()
        } catch MockError.failure {
            // success
        } catch {
            XCTFail("expected 'MockError.failure'!")
        }
    }
    
    func testloadImageList_givenData_thenReturnsData() async throws {
        // given
        let service = makeService()
        let mockData = dataSuccess
        
        mockNetworkService.load_mockMethod = { urlRequest in
            let urlString = try XCTUnwrap(urlRequest.url?.absoluteString)
            guard let urlComponents = URLComponents(string: urlString) else {
                XCTFail("expected 'urlComponents' to be initialized")
                throw MockError.failure
            }
            
            XCTAssertEqual(urlComponents.scheme, "https")
            XCTAssertEqual(urlComponents.host, "api.flickr.com")
            XCTAssertEqual(urlComponents.path, "/services/rest/")
            XCTAssert(urlComponents.queryItems?.contains { $0.name == "api_key" } == true)
            XCTAssertEqual(urlComponents.queryItems?.first { $0.name == "method" }?.value, "flickr.photos.search")
            
            // improvement: test all parameters..
            
            return mockData
        }
        
        // when
        let imageList = try await service.loadImageList()
        
        // then
        XCTAssertEqual(imageList.data.photos.first?.id, "53888638560")
    }
    
    // MARK: - Helpers
    
    private func makeService() -> FlickrService {
        FlickrService(networkService: mockNetworkService)
    }
}

// MARK: - Error

private enum MockError: Error {
    case failure
}

// MARK: - JSON

private let dataSuccess = """
jsonFlickrApi({
    "photos": {
        "page": 1,
        "pages": 853,
        "perpage": 250,
        "total": 213229,
        "photo": [
            {
                "id": "53888638560",
                "owner": "98501737@N06",
                "secret": "84b58e50cc",
                "server": "65535",
                "farm": 66,
                "title": "",
                "ispublic": 1,
                "isfriend": 0,
                "isfamily": 0
            }
        ]
    }
})
""".data(using: .utf8)!
