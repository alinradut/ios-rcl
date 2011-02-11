//
//  RCLAsyncDownloader.h
//  RCL
//
//  Created by clw on 2/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define RCL_MAX_CONCURRENT_DOWNLOADS    10

@class RCLAsyncDownloader;

@protocol RCLAsyncDownloaderDelegate
- (void)downloader:(RCLAsyncDownloader *) didDownloadData:(NSData *)data;

@optional
- (void)downloader:(RCLAsyncDownloader *) didUpdateProgress:(NSNumber *)progress;
- (void)downloader:(RCLAsyncDownloader *) didFailWithError:(NSError *)error;
@end


@interface RCLAsyncDownloader : NSObject {
    NSOperationQueue *queue_;
    BOOL terminate_;
}

//! NSOperationQueue that will allow us to throttle the number of concurrent requests
@property (nonatomic, retain) NSOperationQueue *queue;
@property (nonatomic) BOOL terminate;

/*!
 Singleton shared instance
 */
+ (RCLAsyncDownloader *)instance;

/*!
 Downloads an NSData object from the URL and passes it to the specified delegate.
 */
- (void)downloadURL:(NSURL *)url withDelegate:(id<RCLAsyncDownloaderDelegate>)delegate;

/*!
 Cancel download for specified URL
 */
- (void)cancelDownloadForURL:(NSURL *)url;

/*!
 terminateInstance will kill the current singleton instance. 
 This method should be called in situations of low memory warnings.
 The singleton instance will be re-created when the next call to 
 [RCLAsyncDownloader instance] will be made.
 */
- (void)terminateInstance;
@end