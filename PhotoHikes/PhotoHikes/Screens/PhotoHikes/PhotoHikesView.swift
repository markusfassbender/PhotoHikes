//
//  PhotoHikesView.swift
//  PhotoHikes
//
//  Created by Markus on 23.07.24.
//

import SwiftUI

struct PhotoHikesView: View {
    
    @State var viewModel: PhotoHikesViewModel
    
    var body: some View {
        if let trackingViewModel = viewModel.trackingViewModel {
            NavigationStack() {
                TrackingView(viewModel: trackingViewModel)
            }
        } else {
            Text("Loading...")
                .task {
                    await viewModel.setUp()
                }
        }
    }
}
