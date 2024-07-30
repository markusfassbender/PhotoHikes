//
//  TrackingViewModelTests.swift
//  PhotoHikesTests
//
//  Created by Markus on 23.07.24.
//

import XCTest

@testable import PhotoHikes

final class TrackingViewModelTests: XCTestCase {
    
    // TODO: write more unit tests when dependency injection is available
    
    // MARK: isTracking
    
    func testInitial_given_when_thenIsNotTracking() async {
        // given
        let viewModel = await makeViewModel()
        
        // when
        let isTracking = await viewModel.isTracking
        
        // then
        XCTAssertFalse(isTracking)
    }
    
    func testSetUp_given_when_thenIsNotTracking() async {
        // given
        let viewModel = await makeViewModel()
        
        // when
        await viewModel.setUp()
        let isTracking = await viewModel.isTracking
        
        // then
        XCTAssertFalse(isTracking)
    }
    
    // MARK: - Helpers
    
    @MainActor
    private func makeViewModel() -> TrackingViewModel {
        TrackingViewModel()
    }
}
