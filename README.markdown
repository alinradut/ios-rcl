# ios-rcl

The iOS Reusable Component Library is a collection of classes aimed to make development for iOS an easier task. 

The library tries to solve a number of issues that constantly arise during development.

The libary is still under heavy development but is expected to have a rapid progress.

There are a number of goals that will be pursued in developing this library:
* write clean, understandable code that minimizes need for customizations, but make customizing a breeze 
* document all source code using Doxygen style comments
* cover the code as much as possible using unit testing

## RCLAsyncImageView

An asynchronous image view that allows the loading of remote images in background.
The images can be cached to disk using the *RCLCache* class.

This class depends on the *RCLAsyncDownloader* class to download the image data.

## RCLAsyncImageButton

A button class that can load its state-dependent images from remote URLs. This class is similar in dependencies with the RCLAsyncImageView class.

## RCLGallery

A gallery class that allows the user to browse through a list of images.

## RCLImageViewer

A full screen image viewer similar to the default image library viewer from iOS.

## RCLTableViewController

An enhanced table view controller that eases the use of often requested enhancements: 
* pull to refresh
* text filtering
* pagination
