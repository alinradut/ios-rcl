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
    NSMutableDictionary *expirationDates_;
}

//! shared instance
+ (RCLMemoryCache *)instance;

/*!
 Stores an object in the memory cache for an indefinite amount of time. 
 @param object NSData representation of an object
 @param keyPath The key path of the object to be retrieved
 */
- (void)storeData:(NSData *)object forKeyPath:(NSString *)keyPath;

/*!
 Stores an object in the memory cache for an amount of time. 
 @param object NSData representation of an object
 @param keyPath The key path of the object to be retrieved
 @param expirationDate Date when the object is set to expire. 
    Use [NSDate distantFuture] if you don't want the object to expire
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
 Removes all objects from memory cache
 */
- (void)removeAllObjects;

@end
