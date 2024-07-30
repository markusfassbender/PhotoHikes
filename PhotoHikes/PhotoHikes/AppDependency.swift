//
//  AppDependency.swift
//  PhotoHikes
//
//  Created by Markus on 26.07.24.
//

/// AppDependency follows the composition root design pattern. It's a structured way to share dependencies between scenes.
///
/// See this post for further explanation: https://simonbs.dev/posts/introducing-the-composition-root-pattern-in-a-swift-codebase/
actor AppDependency {
    
    private var _locationService: (any LocationServiceProtocol)!
    
    var locationService: any LocationServiceProtocol { _locationService }
    
    // MARK: - Set Up
    
    func setUp() async {
        _locationService = await LocationService()
    }
}
