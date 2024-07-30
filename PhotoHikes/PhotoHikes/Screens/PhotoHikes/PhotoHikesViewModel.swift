//
//  PhotoHikesViewModel.swift
//  PhotoHikes
//
//  Created by Markus on 30.07.24.
//

import SwiftUI

@Observable @MainActor
final class PhotoHikesViewModel {
    
    // MARK: - Properties
    
    private let dependencies: AppDependency
    
    var trackingViewModel: TrackingViewModel?
    
    // MARK: - Initialize
    
    init(dependencies: AppDependency) {
        self.dependencies = dependencies
    }
    
    // MARK: - Methods
    
    func setUp() async {
        await dependencies.setUp()
        
        trackingViewModel = await TrackingViewModel(
            flickrService: dependencies.flickrService,
            locationService: dependencies.locationService
        )
    }
}
