//
//  TrackingViewModelTests.swift
//  PhotoHikesTests
//
//  Created by Markus on 23.07.24.
//

import XCTest

@testable import PhotoHikes

final class TrackingViewModelTests: XCTestCase {
    
    private var mockFlickrService: FlickrServiceMock!
    private var mockLocationService: LocationServiceMock!
    
    override func setUp() async throws {
        try await super.setUp()
     
        mockFlickrService = FlickrServiceMock()
        mockLocationService = await LocationServiceMock()
        await mockLocationService.setOnUpdateLocation { _ in }
    }
    
    override func tearDown() {
        mockLocationService = nil
        mockFlickrService = nil
        
        super.tearDown()
    }
    
    // MARK: isTracking
    
    func testInitial_given_when_thenIsNotTracking() async {
        // given
        let viewModel = await makeViewModel()
        
        // when
        let isTracking = await viewModel.isTracking
        
        // then
        XCTAssertFalse(isTracking)
    }
    
    // MARK: - Helpers
    
    @MainActor
    private func makeViewModel() -> TrackingViewModel {
        TrackingViewModel(
            flickrService: mockFlickrService,
            locationService: mockLocationService
        )
    }
}
