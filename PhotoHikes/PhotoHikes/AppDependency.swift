//
//  AppDependency.swift
//  PhotoHikes
//
//  Created by Markus on 26.07.24.
//

import NetworkService

/// AppDependency follows the composition root design pattern. It's a structured way to share dependencies between scenes.
///
/// See this post for further explanation: https://simonbs.dev/posts/introducing-the-composition-root-pattern-in-a-swift-codebase/
actor AppDependency {
    
    var flickrService: any FlickrServiceProtocol { _flickrService }
    var locationService: any LocationServiceProtocol { _locationService }
    
    private var _flickrService: (any FlickrServiceProtocol)!
    private var _locationService: (any LocationServiceProtocol)!
    private var _networkService: NetworkService!
    
    // MARK: - Set Up
    
    func setUp() async {
        let networkService = NetworkService(urlSession: .shared)
        _networkService = networkService
        
        _flickrService = FlickrService(networkService: networkService)
        _locationService = await LocationService()
    }
}
