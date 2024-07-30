# PhotoHikes

This is an example app as a show case as Senior iOS Engineer.

## Setup

### Local Machine
Requires Xcode 15.4 without any additional tooling.

### iOS Device Requirements
The iOS devices requires Location Services and GPS capabilities to install the app. 


## TODOs

### Steps
- [x] setup project
- [x] add initial screen with start/stop button
- location services
  - [x] implement CoreLocation
  - [x] enable power-saving features
- [ ] implement dependency injection
- [x] add network service swift package
- [x] add flickr service
- [x] show images from flickr
- [x] improve flickr photo selection
- [x] fix view crashing on real device

### Questions
- why is it mentioned that "it should work for at least a two hour walk"?
  - battery life
  - api rating limit
  - performance on scrolling with many images
  - other reasons?


## Flickr
- Using the Flickr API is not self-explanatory, but with the [documentation](https://www.flickr.com/services/api/flickr.photos.search.html), it is possible to figure out how to use it.
- For improvement, the Flickr API key should be injected, e.g., via CI environment secrets, instead of being hardcoded.
- I read about an API rate limit, but according to the [documentation](https://www.flickr.com/services/developer/api/), it allows up to 3600 requests per hour.
- Photos can be downloaded in different sizes, but I used the default size.
- To protect user privacy, it might be beneficial to reduce the coordinate precision sent to the API. However, this would be a trade-off and must be tested thoroughly to ensure it still finds photos related to the hiking trail.
- I chose the parameter `tags=outdoor,nature,landscape` as an example to filter matching photos. Other values should be evaluated.
- I tried using the `geo_context` parameter for outdoor photos, but most photos did not have this value set, and the results often returned empty lists of photos.
- The result format is not valid JSON, even if one send `format=json`. I've implemented a workaround the remove the prefix and suffix and added unit tests, though there might be other formats to evaluate. The [documentation](https://www.flickr.com/services/api/misc.overview.html) is not clear about this point.


## Location Services
- For location services, there are several ways and options to track the device's location. I decided to use standard location updates in the foreground only. Region monitoring is not an option as it serves a different purpose, and significant location tracking reports only distances of 500 meters or more (see [documentation](https://developer.apple.com/documentation/corelocation/cllocationmanager/1423531-startmonitoringsignificantlocati)), which does not meet the requirement to load an image every 100 meters.
- Initially, I attempted to implement background tracking, as I would expect it as a user. There are some APIs available for this, such as `CLBackgroundActivitySession` and `CLServiceSession`. However, after interpreting the given requirements, I concluded that the user will keep the app in the foreground only, which simplifies the implementation. Consequently, I reverted to requesting location service permission for "when in use" only.
- Some settings should be managed better in the future, such as handling cases where the user grants reduced accuracy instead of full access.
- The `activityType` is set to fitness as it matches hiking and the device's sensors can support the tracking.
- The `desiredAccuracy` is set to `kCLLocationAccuracyNearestTenMeters` as it saves battery and should be precise enough to record the hiking track with photos.
- The `pausesLocationUpdatesAutomatically` property should be considered in the future to improve battery usage.
- It would be interesting to utilize the concurrent iOS 17 API `CLLocationUpdate.liveUpdates`, but I didn't fully understand from the documentation how to set the requirements, such as the distance filter, correctly.
  
## Other
- I've added `@MainActor` to the view and view model explicitly, because it crashed on my real device. I have no experience with the new iOS 17 Observation API and didn't find more specifications in the [Apple migration guide](https://developer.apple.com/documentation/swiftui/migrating-from-the-observable-object-protocol-to-the-observable-macro). Maybe there is a better approach without enforcing logic via main actor.
