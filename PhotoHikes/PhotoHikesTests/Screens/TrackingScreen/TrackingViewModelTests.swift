//
//  TrackingViewModelTests.swift
//  PhotoHikesTests
//
//  Created by Markus on 23.07.24.
//

import XCTest

@testable import PhotoHikes

final class TrackingViewModelTests: XCTestCase {
    
    // MARK: isTracking
    
    func testInitial_given_when_thenIsNotTracking() {
        // given
        let viewModel = makeViewModel()
        
        // when
        // then
        XCTAssertFalse(viewModel.isTracking)
    }
    
    func testInitial_given_whenToggleIsTracking_thenIsTracking() {
        // given
        let viewModel = makeViewModel()
        
        // when
        viewModel.isTracking.toggle()
        
        // then
        XCTAssertTrue(viewModel.isTracking)
    }
    
    func testSetUp_given_when_thenIsNotTracking() async {
        // given
        let viewModel = makeViewModel()
        
        // when
        await viewModel.setUp()
        
        // then
        XCTAssertFalse(viewModel.isTracking)
    }
    
    // MARK: - Helpers
    
    private func makeViewModel() -> TrackingViewModel {
        TrackingViewModel()
    }
}
