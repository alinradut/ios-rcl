//
//  RCLAsyncDownloader.h
//  RCL
//
//  Created by clw on 2/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RCL.h"

#define RCL_MAX_CONCURRENT_DOWNLOADS    10
#define RCL_ASYNC_DOWNLOADER_ENABLE_CACHE   1

@interface RCLAsyncDownloader : NSObject {
@private
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
 Downloads an NSData object from the URL and passes it to the specified delegate.
 If useCache is YES and the object has already be downloaded, the cached version will be returned.
 */
- (void)downloadURL:(NSURL *)url withDelegate:(id<RCLAsyncDownloaderDelegate>)delegate useCache:(BOOL)useCache customHeaders:(NSDictionary *)customHeaders;

/*!
 Cancel download for specified URL
 */
- (void)cancelDownloadForURL:(NSURL *)url delegate:(id)delegate;

/*!
 Cancel downloads for specified delegate
 */
- (void)cancelDownloadsForDelegate:(id)delegate;

/*!
 Kill the current singleton instance. 
 This method should be called in situations of low memory warnings.
 The singleton instance will be re-created when the next call to 
 [RCLAsyncDownloader instance] will be made.
 */
- (void)terminateInstance;
@end