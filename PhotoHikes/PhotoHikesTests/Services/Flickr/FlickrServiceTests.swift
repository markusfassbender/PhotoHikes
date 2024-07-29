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
    
    private var mockCoordinates: FlickrSearchCoordinates!
    private var mockNetworkService: NetworkServiceMock!
    
    override func setUp() {
        super.setUp()
        mockCoordinates = FlickrSearchCoordinates(latitude: 50.7381021, longitude: 7.1101411)
        mockNetworkService = NetworkServiceMock()
    }
    
    override func tearDown() {
        mockNetworkService = nil
        mockCoordinates = nil
        super.tearDown()
    }
    
    func testLoadImage_givenError_thenThrowsError() async throws {
        // given
        let service = makeService()
        
        mockNetworkService.load_mockMethod = { _ in
            throw MockError.failure
        }
        
        // when
        // then
        do {
            _ = try await service.loadImage(at: mockCoordinates)
        } catch MockError.failure {
            // success
        } catch {
            XCTFail("expected 'MockError.failure'!")
        }
    }
    
    func testLoadImage_givenJSONData_thenThrowsError() async throws {
        // given
        let service = makeService()
        
        mockNetworkService.load_mockValue = dataSuccessEmptyList
        
        // when
        // then
        do {
            _ = try await service.loadImage(at: mockCoordinates)
        } catch FlickrServiceError.emptyPhotoList {
            // success
        } catch {
            XCTFail("expected 'FlickrServiceError.emptyPhotoList'!")
        }
    }
    
    func testLoadImageFromPhoto_givenError_thenThrowsError() async throws {
        // given
        let service = makeService()
        let mockPhoto = FlickrImageList.Photo(
            id: "53888638560",
            server: "65535",
            secret: "84b58e50cc"
        )
        
        mockNetworkService.load_mockMethod = { _ in
            throw MockError.failure
        }
        
        // when
        // then
        do {
            _ = try await service.loadImage(from: mockPhoto)
        } catch MockError.failure {
            // success
        } catch {
            XCTFail("expected 'MockError.failure'!")
        }
    }
    
    func testLoadImageFromPhoto_givenData_thenReturnsData() async throws {
        // given
        let service = makeService()
        let mockPhoto = FlickrImageList.Photo(
            id: "53888638560",
            server: "65535",
            secret: "84b58e50cc"
        )
        let mockData = Data()
        
        mockNetworkService.load_mockMethod = { urlRequest in
            let urlString = try XCTUnwrap(urlRequest.url?.absoluteString)
            guard let urlComponents = URLComponents(string: urlString) else {
                XCTFail("expected 'urlComponents' to be initialized")
                throw MockError.failure
            }
            
            XCTAssertEqual(urlComponents.scheme, "https")
            XCTAssertEqual(urlComponents.host, "live.staticflickr.com")
            XCTAssertEqual(urlComponents.path, "/65535/53888638560_84b58e50cc.jpg")
            XCTAssertNil(urlComponents.queryItems)
            
            return mockData
        }
        
        // when
        let imageData = try await service.loadImage(from: mockPhoto)
        
        // then
        XCTAssertEqual(imageData, mockData)
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
            _ = try await service.loadImageList(at: mockCoordinates)
        } catch MockError.failure {
            // success
        } catch {
            XCTFail("expected 'MockError.failure'!")
        }
    }
    
    func testloadImageList_givenJSONData_thenReturnsData() async throws {
        // given
        let service = makeService()
        
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
            XCTAssertEqual(urlComponents.queryItems?.first { $0.name == "lat" }?.value, "50.73810")
            XCTAssertEqual(urlComponents.queryItems?.first { $0.name == "lon" }?.value, "7.11014")
            
            // improvement: test all parameters..
            
            return dataSuccessOnePhoto
        }
        
        // when
        let imageList = try await service.loadImageList(at: mockCoordinates)
        
        // then
        let photo = imageList.data.photos.first
        XCTAssertEqual(photo?.id, "53888638560")
        XCTAssertEqual(photo?.server, "65535")
        XCTAssertEqual(photo?.secret, "84b58e50cc")
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

private let dataSuccessOnePhoto = """
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

private let dataSuccessEmptyList = """
jsonFlickrApi({
    "photos": {
        "page": 1,
        "pages": 1,
        "perpage": 250,
        "total": 0,
        "photo": []
    }
})
""".data(using: .utf8)!
