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

#define CGRectSetPos( r, x, y )     CGRectMake( x, y, r.size.width, r.size.height )
#define CGRectSetX( r, x )          CGRectMake( x, r.origin.y, r.size.width, r.size.height )
#define CGRectSetY( r, y )          CGRectMake( r.origin.x, y, r.size.width, r.size.height )
#define CGRectSetSize( r, w, h )    CGRectMake( r.origin.x, r.origin.y, w, h )
#define CGRectSetWidth( r, w )      CGRectMake( r.origin.x, r.origin.y, w, r.size.height )
#define CGRectSetHeight( r, h )     CGRectMake( r.origin.x, r.origin.y, r.size.width, h )

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)