//
//  TrackingViewModel.swift
//  PhotoHikes
//
//  Created by Markus on 23.07.24.
//

import SwiftUI

@Observable final class TrackingViewModel {
    var isTracking: Bool
    
    init() {
        isTracking = false
    }
}
