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
    
    let dependencies: AppDependency
    
    var didInitializeDependencies: Bool = false
    
    // MARK: - Initialize
    
    init(dependencies: AppDependency) {
        self.dependencies = dependencies
    }
    
    // MARK: - Methods
    
    func setUp() async {
        await dependencies.setUp()
        didInitializeDependencies = true
    }
}
