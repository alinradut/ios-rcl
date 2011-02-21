/*
 *  RCL.h
 *  RCL
 *
 *  Created by clw on 2/14/11.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */


@protocol RCLAsyncDownloaderDelegate
- (void)downloaderDidDownloadData:(NSData *)data forUrl:(NSURL *)url;

@optional
- (void)downloaderDidUpdateProgress:(NSNumber *)progress forUrl:(NSURL *)url;
- (void)downloaderDidFailWithError:(NSError *)error forUrl:(NSURL *)url;
@end
