//
//  RCLAsyncDownloader.m
//  RCL
//
//  Created by clw on 2/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RCLAsyncDownloader.h"

@interface RCLDownloadOperation : NSOperation
{
    id<RCLAsyncDownloaderDelegate> delegate_;
    NSURL *url_;
    NSData *downloadedData_;
}

@property (nonatomic, assign) id<RCLAsyncDownloaderDelegate> delegate;
@property (nonatomic, retain) NSURL *url;
@end

@implementation RCLDownloadOperation
@synthesize url = url_;

- (void)start {
    downloadedData_ = [[NSMutableData alloc] init];
    NSURLRequest *request = [[[NSURLRequest alloc] initWithURL:url_] autorelease];
    NSURLConnection *conn  = [[NSURLConnection alloc] initWithRequest:request 
                                                             delegate:self 
                                                     startImmediately:YES];
}

@end


@implementation RCLAsyncDownloader
@synthesize queue = queue_;
@synthesize terminate = terminate_;

+ (RCLAsyncDownloader *)instance {
    static RCLAsyncDownloader *sharedInstance;
    if (!sharedInstance) {
        sharedInstance = [[RCLAsyncDownloader alloc] init];
        sharedInstance.queue = [[NSOperationQueue alloc] init];
        sharedInstance.queue.maxConcurrentOperationCount = RCL_MAX_CONCURRENT_DOWNLOADS;
    }
    else if (sharedInstance.terminate) {
        [sharedInstance release];
        sharedInstance = nil;
    }

    return sharedInstance;
}

#pragma mark -
#pragma mark Download
- (void)downloadURL:(NSURL *)url withDelegate:(id<RCLAsyncDownloaderDelegate>)delegate {
    RCLDownloadOperation *op = [[RCLDownloadOperation alloc] init];
    op.delegate = delegate;
    op.url = url;
    [queue_ addOperation:op];
}


#pragma mark -
#pragma Memory management
- (void)terminateInstance {
    terminate_ = YES;
    [RCLAsyncDownloader instance];
}

- (void)dealloc {
    self.queue = nil;
    [super dealloc];
}

@end
