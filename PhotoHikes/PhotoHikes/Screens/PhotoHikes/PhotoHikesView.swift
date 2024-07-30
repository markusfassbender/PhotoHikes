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
        if viewModel.didInitializeDependencies {
            Text("Loading...")
                .task {
                    await viewModel.setUp()
                }
        } else {
            NavigationStack() {
                TrackingView()
            }
        }
    }
}

// MARK: - Preview

#Preview {
    let viewModel = PhotoHikesViewModel(dependencies: AppDependency())
    return PhotoHikesView(viewModel: viewModel)
}

