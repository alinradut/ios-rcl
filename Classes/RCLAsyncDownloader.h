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
#define RCL_ASNC_DOWNLOADER_USE_CACHE   1

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