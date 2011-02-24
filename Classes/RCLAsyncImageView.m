//
//  RCLAsyncImageView.m
//  RCL
//
//  Created by clw on 2/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RCLAsyncImageView.h"
#import "RCLAsyncDownloader.h"

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
                                  withDelegate:self];
}

- (void)setUrl:(NSURL *)url {
    if (self.url != nil && downloadInProgress_) {
        [[RCLAsyncDownloader instance] cancelDownloadForURL:url_ 
                                                   delegate:self];
    }
    if (url_) {
        [url_ release];
    }
    url_ = url;
}

#pragma mark -
#pragma mark RCLAsyncDownloaderDelegate
- (void)downloaderDidDownloadData:(NSData *)data forUrl:(NSURL *)url {
    self.image = [UIImage imageWithData:data];
    downloadInProgress_ = NO;
}

- (void)downloaderDidFailWithError:(NSError *)error forUrl:(NSURL *)url {
    NSLog(@"%@", error);
}

- (void)dealloc {
    if (downloadInProgress_) {
        [[RCLAsyncDownloader instance] cancelDownloadForURL:url_ delegate:self];
    }
    self.url = nil;
    [super dealloc];
}

@end
