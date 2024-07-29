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
    
    func testLoadImage_givenData_thenReturnsImage() async throws {
        // given
        let service = makeService()
        let mockData = Data()
        
        mockNetworkService.load_MockValue = mockData
        
        // when
        let image = try await service.loadImage()
        
        // then
        XCTAssertEqual(image, mockData)
    }
    
    // MARK: - Helpers
    
    private func makeService() -> FlickrService {
        FlickrService(networkService: mockNetworkService)
    }
}
