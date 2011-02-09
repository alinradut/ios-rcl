//
//  RCLCache.h
//  RCL
//
//  Created by clw on 2/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define RCL_DOCUMENTS_DIRECTORY [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]
#define RCL_CACHE_DIRECTORY [RCL_DOCUMENTS_DIRECTORY stringByAppendingPathComponent:@"RCLCache"]
#define RCL_USE_CACHE   1

/*!
 RCLCache is a generic cache manager. 
 
 Normally you will call the cache manager as a singleton
 using the instance() method.
 */
@interface RCLCache : NSObject {
}

//! Shared instance, the preferred way of using the cache manager
+ (RCLCache *)instance;

- (void)storeData:(NSData *)object forKeyPath:(NSString *)keyPath;
- (BOOL)objectAvailableForKeyPath:(NSString *)keyPath;
- (NSData *)objectForKeyPath:(NSString *)keyPath;

@end
