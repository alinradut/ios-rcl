//
//  RCLAsynchronousDownloaderTest.m
//  RCL
//
//  Created by clw on 2/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RCLAsyncDownloaderTest.h"
#import "RCLAsyncDownloader.h"

@implementation RCLAsyncDownloaderTest

- (void)testDownload {
    
    [[RCLAsyncDownloader instance] downloadURL:[NSURL URLWithString:@"http://www.example.com/"] 
                                  withDelegate:self];
    executing_ = YES;
    while (executing_) {
        [NSThread sleepForTimeInterval:.2];
    }
}

- (void)testSingleton {
    STAssertNotNil([RCLAsyncDownloader instance], @"Instance cannot be null");
    STAssertEqualObjects([RCLAsyncDownloader instance],[RCLAsyncDownloader instance],@"Instances are different");
}


#pragma mark RCLAsyncDownloaderDelegate
#pragma mark -
- (void)downloaderDidDownloadData:(NSData *)data forUrl:(NSURL *)url {
    STAssertNotNil(data, @"Data was nil");
    STAssertTrue([data length], @"Data length was 0");
    STAssertNotNil(url, @"URL object was nil");
    executing_ = NO;
}

- (void)downloaderDidFailWithError:(NSError *)error forUrl:(NSURL *)url {
    STAssertNotNil(url, @"URL object was nil");
    STAssertTrue(0, @"Download failed");
    executing_ = NO;
}

@end
