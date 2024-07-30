//
//  PhotoHikesApp.swift
//  PhotoHikes
//
//  Created by Markus on 23.07.24.
//

import SwiftUI

@main
struct PhotoHikesApp: App {
    
    private let dependencies: AppDependency
    private let viewModel: PhotoHikesViewModel
    
    init() {
        let dependencies = AppDependency()
        self.dependencies = dependencies
        self.viewModel = PhotoHikesViewModel(dependencies: dependencies)
    }
    
    var body: some Scene {
        WindowGroup {
            PhotoHikesView(viewModel: viewModel)
        }
    }
}
