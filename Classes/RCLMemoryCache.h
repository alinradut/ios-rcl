//
//  RCLMemoryCache.h
//  RCL
//
//  Created by clw on 2/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 Singleton class that stores objects in memory.
 */
@interface RCLMemoryCache : NSObject {
    //! collection of objects stored in memory
    NSMutableDictionary *memoryCache_;
}

//! shared instance
+ (RCLMemoryCache *)instance;

/*!
 Returns an object stored in the cache or nil if no object was found.
 @param object NSData representation of an object
 @param keyPath The key path of the object to be retrieved
 */
- (void)storeData:(NSData *)object forKeyPath:(NSString *)keyPath;

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
 Removes all objects from memory cache
 */
- (void)removeAllObjects;

@end
