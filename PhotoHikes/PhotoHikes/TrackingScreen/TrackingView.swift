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
        Text("Hello, World!")
            .padding()
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(trackingButtonTitle) {
                        viewModel.isTracking.toggle()
                    }
                }
            }
    }
}

// MARK: - Preview

#Preview {
    TrackingView()
}
