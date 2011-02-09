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
- (void)downloader:(RCLAsyncDownloader *) didUpdateProgress:(float)progress;
@end


@interface RCLAsyncDownloader : NSObject {
    NSOperationQueue *queue_;
    BOOL terminate_;
}

@property (nonatomic, retain) NSOperationQueue *queue;
@property (nonatomic) BOOL terminate;

+ (RCLAsyncDownloader *)instance;
- (void)downloadURL:(NSURL *)url withDelegate:(id<RCLAsyncDownloaderDelegate>)delegate;
- (void)terminateInstance;
@end