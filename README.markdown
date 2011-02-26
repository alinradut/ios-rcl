# ios-rcl

The iOS Reusable Component Library is a collection of classes aimed to make development for iOS an easier task. 

The library tries to solve a number of issues that constantly arise during development.

The libary is still under heavy development but is expected to have a rapid progress.

There are a number of goals that will be pursued in developing this library:

* write clean, understandable code that minimizes need for customizations, but make customizing a breeze 
* document all source code using Doxygen style comments
* cover the code as much as possible using unit testing

## Components
### RCLAsyncImageView

An asynchronous image view that allows the loading of remote images in background.
The images can be cached to disk using the *RCLCache* class.

This class depends on the *RCLAsyncDownloader* class to download the image data.

### RCLAsyncImageButton

A button class that can load its state-dependent images from remote URLs. This class is similar in dependencies with the RCLAsyncImageView class.

### RCLGallery

A gallery class that allows the user to browse through a list of images.

### RCLImageViewer

A full screen image viewer similar to the default image library viewer from iOS.

### RCLTableViewController

An enhanced table view controller that eases the use of often requested enhancements: 

* pull to refresh
* text filtering
* pagination

### RCLMapController

The RCLMapController allows the display of thousands of POIs at a time without slowing down 
the app noticeably or ramping up the memory consumption to mem warning levels by clustering the pins together.

## Backbone classes

The reusable components depend on a number of backbone classes to do their job properly.

### RCLAsyncDownloader
An asynchronous downloader singleton class that allows a configurable number of 
simultaneous requests to execute in parallel. The requests are executed from an 
NSOperationQueue with a configurable number of simultaneous connections.

This class can be useful in throttling the number of requests that are started 
at a given time. Although the remote data is being fetched asynchronously starting a too 
greater number of requests will bog down your application.

RCLAsyncImageView and RCLAsyncImageButton rely on this class.

### RCLCache
A disk cache singleton class that allows storing NSData objects to disk. At the moment 
there is no way of managing the lifetime of a cached objects but that is a feature that
is going to be implemented. RCLAsyncImageView/Button can use this cache to load
images from disk rather than downloading them all together again.

### RCLMemoryCache
A memory cache singleton class that allows storing objects to memory. RCLAsyncImageView/Button
can use this memory cache to quickly access objects that are already loaded in memory. This
can be very useful in implementing fast, lazy-loading table views that need to be 
high-performance.

Objects stored in the memory cache don't get jettisoned unless manually requested. It is
recommended that on applicationDidReceiveMemoryWarning the memory cache's removeAllObjects 
method be called to free up existing objects.
