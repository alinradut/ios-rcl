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
    NSMutableArray *data_;
}

//! Shared instance, the preferred way of using the cache manager
+ (RCLCache *)instance;

/*!
 Stores an object in the disk cache
 @param keyPath The key path of the object to be retrieved
 */
- (void)storeData:(NSData *)object forKeyPath:(NSString *)keyPath;

/*!
 Stores an object in the disk cache with a given expiration date
 @param keyPath The key path of the object to be retrieved
 */
- (void)storeData:(NSData *)object forKeyPath:(NSString *)keyPath expires:(NSDate *)expirationDate;

/*!
 Checks if an object was stored in the cache for the given keyPath
 @param keyPath The key path of the object
 */
- (BOOL)objectAvailableForKeyPath:(NSString *)keyPath;

/*!
 Returns an object stored in the cache or nil if no object was found.
 @param keyPath The key path of the object to be retrieved
 */
- (NSData *)objectForKeyPath:(NSString *)keyPath;

/*!
 Removes an object from the memory cache.
 @param keyPath Key path of object to remove
 */
- (void)removeObjectForKeyPath:(NSString *)keyPath;

/*!
 Purge the cached files that expired
 */
- (void)purgeExpiredData;

@end
