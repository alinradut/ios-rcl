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

// error levels:
// 0 - Info, Warning, Error - most verbose
// 1 - Warning, Error
// 2 - Error
#define RCLLogVerbosityLevel 0

#define RCLLog( ... ) NSLog(@"%s:%d: " xx, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

#if RCLLogVerbosityLevel > -1
    #if RCLLogVerbosityLevel < 1
    #define RCLInfo(xx, ... ) NSLog(@"[INFO] %s:%d: " xx, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
    #endif

    #if RCLLogVerbosityLevel <= 1
    #define RCLWarning(xx, ... ) NSLog(@"[WARN] %s:%d: " xx, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
    #endif

    #if RCLLogVerbosityLevel <= 2
    #define RCLError(xx, ... ) NSLog(@"[ERROR] %s:%d: " xx, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
    #endif
#endif