//
//  RCLAsyncImageView.m
//  RCL
//
//  Created by clw on 2/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RCLAsyncImageView.h"
#import "RCLAsyncDownloader.h"
#import "RCL.h"
#import "RCLMemoryCache.h"

@implementation RCLAsyncImageView
@synthesize url = url_;
@synthesize downloadInProgress = downloadInProgress_;

- (id)initWithURL:(NSString *)urlString 
   temporaryImage:(UIImage *)temporaryImage {
    
    if (self = [self initWithURL:urlString temporaryImage:temporaryImage startImmediately:YES]) {
    }
    return self;
}

- (id)initWithURL:(NSString *)urlString 
   temporaryImage:(UIImage *)temporaryImage 
 startImmediately:(BOOL)start {
    
    if (self = [super initWithImage:temporaryImage]) {
        self.url = [NSURL URLWithString:urlString];
        if (start) {
            [self startDownload];
        }
    }
    return self;
}

- (void)startDownload {
    [[RCLAsyncDownloader instance] downloadURL:url_ 
                                  withDelegate:self
                                      useCache:YES
                                 customHeaders:nil];
}

- (void)cancelDownload {
    [[RCLAsyncDownloader instance] cancelDownloadsForDelegate:self];
}

- (void)setUrl:(NSURL *)url {
    if (url == url_) {
        return;
    }
    if (self.url != nil && downloadInProgress_) {
        [[RCLAsyncDownloader instance] cancelDownloadForURL:url_ 
                                                   delegate:self];
    }
    [url_ release];
    url_ = [url retain];
    if ([[url_ absoluteString] length]) {
        if ([[RCLMemoryCache instance] objectAvailableForKeyPath:[url_ absoluteString]]) {
            self.image = [UIImage imageWithData:[[RCLMemoryCache instance] objectForKeyPath:[url_ absoluteString]]];
        }
    }
}

#pragma mark -
#pragma mark RCLAsyncDownloaderDelegate
- (void)downloaderDidDownloadData:(NSData *)data forUrl:(NSURL *)url {
    self.contentMode = UIViewContentModeScaleAspectFill;
    self.clipsToBounds = YES;
    self.image = [UIImage imageWithData:data];
    downloadInProgress_ = NO;
    [[RCLMemoryCache instance] storeData:data forKeyPath:[url absoluteString] expires:[NSDate dateWithTimeIntervalSinceNow:60 * 5]];
}

- (void)downloaderDidFailWithError:(NSError *)error forUrl:(NSURL *)url {

}

- (void)dealloc {
    [[RCLAsyncDownloader instance] cancelDownloadsForDelegate:self];
    self.url = nil;
    [super dealloc];
}

@end
