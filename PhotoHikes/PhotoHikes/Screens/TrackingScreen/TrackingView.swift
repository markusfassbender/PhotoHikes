//
//  TrackingView.swift
//  PhotoHikes
//
//  Created by Markus on 23.07.24.
//

import SwiftUI

@MainActor
struct TrackingView: View {
    
    @State var viewModel: TrackingViewModel
    
    private var trackingButtonTitle: LocalizedStringKey {
        viewModel.isTracking ? "Stop" : "Start"
    }
    
    var body: some View {
        description
            .padding()
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(trackingButtonTitle) {
                        viewModel.trackingButtonTapped()
                    }
                }
            }
    }
    
    @ViewBuilder
    private var description: some View {
        if let errorMessage = viewModel.errorMessage {
            errorView(errorMessage)
        } else if viewModel.isTracking {
            if viewModel.trackedPhotos.isEmpty {
                trackingStartedView
            } else {
                trackedPhotosView
            }
        } else {
            if viewModel.trackedPhotos.isEmpty {
                placeholderView
            } else {
                trackedPhotosView
            }
        }
    }
    
    @ViewBuilder
    private func errorView(_ errorMessage: LocalizedStringKey) -> some View {
        Text(errorMessage)
    }
    
    @ViewBuilder
    private var placeholderView: some View {
        VStack {
            Text("🏃‍➡️")
                .font(.largeTitle)
                .padding(.bottom)
            
            Text("Start tracking and move to automatically add new photos to the stream.")
        }
    }
    
    @ViewBuilder
    private var trackingStartedView: some View {
        Text("Tracking started...")
    }
    
    @ViewBuilder
    private var trackedPhotosView: some View {
        ScrollView {
            LazyVStack(content: {
                ForEach(viewModel.trackedPhotos, id: \.self) { uiImage in
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                }
            })
        }
    }
}

// MARK: - Preview

#Preview {
    let viewModel = TrackingViewModel(
        flickrService: FlickrServiceMock(),
        locationService: LocationServiceMock()
    )
    return TrackingView(viewModel: viewModel)
}
