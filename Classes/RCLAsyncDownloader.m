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
    id delegate_;
    NSURL *url_;
    NSMutableData *downloadedData_;
    NSURLConnection *connection_;
    long long totalDownloadSize_;
}

@property (nonatomic, assign) id delegate;
@property (nonatomic, retain) NSURL *url;
@end

@implementation RCLDownloadOperation
@synthesize url = url_;
@synthesize delegate = delegate_;

- (void)start {
    downloadedData_ = [[NSMutableData alloc] init];
    NSURLRequest *request = [[[NSURLRequest alloc] initWithURL:url_] autorelease];
    connection_ = [[NSURLConnection alloc] initWithRequest:request 
                                                  delegate:self 
                                          startImmediately:YES];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    totalDownloadSize_ = [response expectedContentLength];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [downloadedData_ appendData:data];
    
    if (totalDownloadSize_ != NSURLResponseUnknownLength 
        && totalDownloadSize_ != 0
        && [delegate_ respondsToSelector:@selector(downloader:didUpdateProgress:)]) {
        
        float progress = [downloadedData_ length]/totalDownloadSize_;
        [delegate_ performSelector:@selector(downloader:didUpdateProgress:)
                        withObject:self
                        withObject:[NSNumber numberWithFloat:progress]];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [downloadedData_ release];
    downloadedData_ = nil;
    
    [connection_ release];
    connection_ = nil;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [downloadedData_ release];
    downloadedData_ = nil;
    
    [connection_ release];
    connection_ = nil;
}

- (void)cancelForUrl:(NSURL *)url {
    if (![self isCancelled]
        && ![self isFinished]
        && [url isEqual:url]) {
        [self cancel];
    }
}

- (void)cancel {
    if (connection_ != nil) {
        [connection_ cancel];
        [connection_ release];
    }
    if (downloadedData_ != nil) {
        [downloadedData_ release];
        downloadedData_ = nil;
    }
}

- (void)dealloc {
    if (connection_ != nil) {
        [connection_ release];
    }
    
    if (downloadedData_ != nil) {
        [downloadedData_ release];
    }
    [super dealloc];
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
    [op release];
}

- (void)cancelDownloadForURL:(NSURL *)url {
    [[queue_ operations] makeObjectsPerformSelector:@selector(cancelForUrl:) 
                                         withObject:url];
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
