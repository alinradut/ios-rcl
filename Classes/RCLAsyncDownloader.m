//
//  RCLAsyncDownloader.m
//  RCL
//
//  Created by clw on 2/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RCLAsyncDownloader.h"

#if RCL_ASYNC_DOWNLOADER_ENABLE_CACHE
#import "RCLCache.h"
#endif

@interface RCLDownloadOperation : NSOperation
{
    id delegate_;
    NSURL *url_;
    NSDictionary *customHeaders_;
    NSMutableData *downloadedData_;
    NSURLConnection *connection_;
    long long totalDownloadSize_;
    BOOL executing_;
    BOOL finished_;
    BOOL cacheResult_;
}

@property (nonatomic, assign) id delegate;
@property (nonatomic, retain) NSURL *url;
@property (nonatomic, retain) NSDictionary *customHeaders;
@property (nonatomic, assign) BOOL cacheResult;
@end

@implementation RCLDownloadOperation
@synthesize url = url_;
@synthesize customHeaders = customHeaders_;
@synthesize delegate = delegate_;
@synthesize cacheResult = cacheResult_;

- (void)start {
    if (![NSThread isMainThread]) {
        [self performSelectorOnMainThread:@selector(start) 
                               withObject:nil 
                            waitUntilDone:NO];
        return;
    }
    [self willChangeValueForKey:@"isExecuting"];
    executing_ = YES;
    [self didChangeValueForKey:@"isExecuting"];
    downloadedData_ = [[NSMutableData alloc] init];
    NSURLRequest *request = [[[NSURLRequest alloc] initWithURL:url_] autorelease];
    connection_ = [[NSURLConnection alloc] initWithRequest:request 
                                                  delegate:self];
    /*
    do {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    } while (executing_);*/
    
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%p: %@", self, url_];
}

- (BOOL)isExecuting {
    return executing_;
}

- (BOOL)isConcurrent {
    return YES;
}

- (BOOL)isFinished {
    return finished_;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    totalDownloadSize_ = [response expectedContentLength];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [downloadedData_ appendData:data];
    
    if (totalDownloadSize_ != NSURLResponseUnknownLength 
        && totalDownloadSize_ != 0
        && [delegate_ respondsToSelector:@selector(downloaderDidUpdateProgress:forUrl:)]) {
        
        float progress = [downloadedData_ length]/totalDownloadSize_;
        [delegate_ performSelector:@selector(downloaderDidUpdateProgress:forUrl:)
                        withObject:[NSNumber numberWithFloat:progress]
                        withObject:url_];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    if (![NSThread isMainThread]) {
        NSLog(@"!!!!!!!!!!!!!!!! jumping to main thread");
        [self performSelectorOnMainThread:@selector(connectionDidFinishLoading:) withObject:connection waitUntilDone:NO];
        return;
    }
    
#if RCL_ASYNC_DOWNLOADER_ENABLE_CACHE
    if (self.cacheResult) {
        [[RCLCache instance] storeData:downloadedData_ forKeyPath:[self.url absoluteString]];
    }
#endif
    
    if ([delegate_ respondsToSelector:@selector(downloaderDidDownloadData:forUrl:)]) {
        [delegate_ performSelector:@selector(downloaderDidDownloadData:forUrl:) 
                        withObject:downloadedData_ 
                        withObject:url_];
    }
    [downloadedData_ release];
    downloadedData_ = nil;
    
    [connection_ release];
    connection_ = nil;
    
    [self willChangeValueForKey:@"isExecuting"];
    [self willChangeValueForKey:@"isFinished"];
    executing_ = NO;
    finished_ = YES;
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    RCLWarning(@"Connection failed with error: %@", error);
    if ([delegate_ respondsToSelector:@selector(downloaderDidFailWithError:forUrl:)]) {
        [delegate_ performSelector:@selector(downloaderDidFailWithError:forUrl:) 
                        withObject:error 
                        withObject:url_];
    }
    [downloadedData_ release];
    downloadedData_ = nil;
    
    [connection_ release];
    connection_ = nil;
    
    [self willChangeValueForKey:@"isExecuting"];
    [self willChangeValueForKey:@"isFinished"];
    executing_ = NO;
    finished_ = YES;
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];
}

- (void)cancelDownload:(NSDictionary *)obj {
    if (![self isCancelled]
        && ![self isFinished]
        && [url_ isEqual:[obj objectForKey:@"url"]]
        && [delegate_ isEqual:[obj objectForKey:@"delegate"]]) {
        [self cancel];
    }
}

- (void)cancelDownloadForDelegate:(id)delegate {
    if (![self isCancelled]
        && ![self isFinished]
        && [delegate_ isEqual:delegate]) {
        [self cancel];
    }
}

- (void)cancel {
    if (connection_ != nil) {
        [connection_ cancel];
        [connection_ release];
        connection_ = nil;
    }
    if (downloadedData_ != nil) {
        [downloadedData_ release];
        downloadedData_ = nil;
    }
    [self willChangeValueForKey:@"isExecuting"];
    [self willChangeValueForKey:@"isFinished"];
    executing_ = NO;
    finished_ = YES;
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];

}

- (void)dealloc {
    if (connection_ != nil) {
        [connection_ release];
    }
    
    if (downloadedData_ != nil) {
        [downloadedData_ release];
    }
    self.url = nil;
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
        [sharedInstance.queue addObserver:sharedInstance forKeyPath:@"operations" options:NSKeyValueObservingOptionNew context:nil];
    }
    else if (sharedInstance.terminate) {
        [sharedInstance release];
        sharedInstance = nil;
    }
    
    return sharedInstance;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    //NSLog(@"active operations: %@", [change valueForKey:@"new"]);
    [UIApplication sharedApplication].networkActivityIndicatorVisible = [self.queue operationCount] > 0;
}

#pragma mark -
#pragma mark Download
- (void)downloadURL:(NSURL *)url withDelegate:(id)delegate {
    [self downloadURL:url withDelegate:delegate useCache:NO customHeaders:nil];
}

- (void)downloadURL:(NSURL *)url withDelegate:(id)delegate useCache:(BOOL)useCache customHeaders:(NSDictionary *)customHeaders {
#if RCL_ASYNC_DOWNLOADER_ENABLE_CACHE
    if (useCache) {
        if ([[RCLCache instance] objectAvailableForKeyPath:[url absoluteString]]) {
            
            if ([delegate respondsToSelector:@selector(downloaderDidDownloadData:forUrl:)]) {
                [delegate performSelector:@selector(downloaderDidDownloadData:forUrl:) 
                               withObject:[[RCLCache instance] objectForKeyPath:[url absoluteString]]
                               withObject:url];
            }
            return;
        }
        
    }
#endif
    
    RCLDownloadOperation *op = [[RCLDownloadOperation alloc] init];
    op.delegate = delegate;
    op.url = url;
    op.cacheResult = useCache;
    op.customHeaders = customHeaders;
    [queue_ addOperation:op];
    [op release];
}

- (void)cancelDownloadForURL:(NSURL *)url delegate:(id)delegate {
    [delegate retain];
    NSDictionary *obj = [NSDictionary dictionaryWithObjectsAndKeys:url,@"url",delegate,@"delegate", nil];
    [[queue_ operations] makeObjectsPerformSelector:@selector(cancelDownload:) 
                                         withObject:obj];
    [delegate release];
}

- (void)cancelDownloadsForDelegate:(id)delegate {
    [delegate retain];
    [[queue_ operations] makeObjectsPerformSelector:@selector(cancelDownloadForDelegate:) 
                                         withObject:delegate];
    [delegate release];
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
