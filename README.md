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

### Questions
- why is it mentioned that "it should work for at least a two hour walk"?
  - battery life
  - api rating limit
  - performance on scrolling with many images
  - other reasons?


## Flickr - Nice To have
- inject the Flickr api key instead of hardcoding it
- handle Flickr api errors in a better way
- load different photo sizes from Flickr
- reduce Flickr coordinate precision to improve the user's privacy?
 
 
## Location Services
- For location services, there are several ways and options to track the device's location. I decided to use standard location updates in the foreground only. Region monitoring is not an option as it serves a different purpose, and significant location tracking reports only distances of 500 meters or more (see [documentation](https://developer.apple.com/documentation/corelocation/cllocationmanager/1423531-startmonitoringsignificantlocati)), which does not meet the requirement to load an image every 100 meters.
- Initially, I attempted to implement background tracking, as I would expect it as a user. There are some APIs available for this, such as `CLBackgroundActivitySession` and `CLServiceSession`. However, after interpreting the given requirements, I concluded that the user will keep the app in the foreground only, which simplifies the implementation. Consequently, I reverted to requesting location service permission for "when in use" only.
- Some settings should be managed better in the future, such as handling cases where the user grants reduced accuracy instead of full access.
- The `pausesLocationUpdatesAutomatically` property should be considered in the future to improve battery usage.
- It would be interesting to utilize the concurrent iOS 17 API `CLLocationUpdate.liveUpdates`, but I didn't fully understand from the documentation how to set the requirements, such as the distance filter, correctly.
