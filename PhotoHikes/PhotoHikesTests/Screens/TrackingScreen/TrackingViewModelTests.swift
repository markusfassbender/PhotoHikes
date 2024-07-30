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
    
    // MARK: - Set Up
    
    override func setUp() async throws {
        try await super.setUp()
     
        mockFlickrService = FlickrServiceMock()
        mockLocationService = await LocationServiceMock()
    }
    
    override func tearDown() {
        mockLocationService = nil
        mockFlickrService = nil
        
        super.tearDown()
    }
    
    // MARK: - Tests
    
    func testInitial_given_thenIsNotTracking() async {
        // given
        let viewModel = await makeViewModel()
        
        // when
        // then
        let isTracking = await viewModel.isTracking
        XCTAssertFalse(isTracking)
    }
    
    func testInitial_given_thenTrackedPhotosIsEmpty() async {
        // given
        let viewModel = await makeViewModel()
        
        // when
        // then
        let trackedPhotos = await viewModel.trackedPhotos
        XCTAssert(trackedPhotos.isEmpty)
    }
    
    func testInitial_given_thenErrorMessageIsNil() async {
        // given
        let viewModel = await makeViewModel()
        
        // when
        // then
        let errorMessage = await viewModel.errorMessage
        XCTAssertNil(errorMessage)
    }
    
    func testStartTracking_given_thenIsTracking() async {
        // given
        let viewModel = await makeViewModel()
        
        // when
        await viewModel.startTracking()
        
        // then
        let isTracking = await viewModel.isTracking
        XCTAssertTrue(isTracking)
    }
    
    func testStopTracking_given_thenIsNotTracking() async {
        // given
        let viewModel = await makeViewModel()
        
        // when
        await viewModel.startTracking()
        await viewModel.stopTracking()
        
        // then
        let isTracking = await viewModel.isTracking
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
