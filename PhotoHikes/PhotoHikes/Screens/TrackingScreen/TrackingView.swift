//
//  TrackingView.swift
//  PhotoHikes
//
//  Created by Markus on 23.07.24.
//

import SwiftUI

struct TrackingView: View {
    
    @State var viewModel = TrackingViewModel()
    
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
            .task {
                await viewModel.setUp()
            }
    }
    
    @ViewBuilder
    private var description: some View {
        if let errorMessage = viewModel.errorMessage {
            Text(errorMessage)
        } else if viewModel.isTracking {
            if viewModel.trackedImages.isEmpty {
                Text("Tracking started...")
            } else {
                ScrollView {
                    LazyVStack(content: {
                        ForEach(viewModel.trackedImages, id: \.self) { uiImage in
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFit()
                        }
                    })
                }
            }
        } else {
            VStack {
                Text("🏃‍➡️")
                    .font(.largeTitle)
                    .padding(.bottom)
                
                Text("Start tracking and move to automatically add new photos to the stream.")
            }
        }
    }
}

// MARK: - Preview

#Preview {
    TrackingView()
}
