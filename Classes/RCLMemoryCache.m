//
//  RCLMemoryCache.m
//  RCL
//
//  Created by clw on 2/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RCLMemoryCache.h"
#import "RCLString.h"

@implementation RCLMemoryCache

+ (RCLMemoryCache *)instance {
    static RCLMemoryCache *sharedInstance;
    if (!sharedInstance) {
        sharedInstance = [[RCLMemoryCache alloc] init];
    }
    return sharedInstance;
}

- (id)init {
    if ((self = [super init])) {
        memoryCache_ = [[NSMutableDictionary alloc] init];
        expirationDates_ = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)storeData:(NSData *)object forKeyPath:(NSString *)keyPath {
    [self storeData:object forKeyPath:keyPath expires:[NSDate distantFuture]];
}

- (void)storeData:(NSData *)object forKeyPath:(NSString *)keyPath expires:(NSDate *)expirationDate {
    NSAssert(object != nil, @"object cannot be nil");
    NSAssert([keyPath length], @"keyPath cannot be nil or empty");
    
    [memoryCache_ setObject:object forKey:[keyPath md5]];
    
    NSNumber *expirationTime = [NSNumber numberWithDouble:[expirationDate timeIntervalSinceReferenceDate]];
    [expirationDates_ setObject:expirationTime forKey:[keyPath md5]];
}

- (BOOL)objectAvailableForKeyPath:(NSString *)keyPath {
    return [self objectForKeyPath:keyPath]!=nil?YES:NO;
}

- (NSData *)objectForKeyPath:(NSString *)keyPath {
    NSAssert([keyPath length], @"keyPath cannot be nil or empty");
    NSNumber *timestamp = 
    [expirationDates_ objectForKey:[keyPath md5]];
    NSNumber *currentTimestamp = [NSNumber numberWithDouble:[NSDate timeIntervalSinceReferenceDate]];
    if ([timestamp compare:currentTimestamp] == NSOrderedAscending) {
        [memoryCache_ removeObjectForKey:[keyPath md5]];
        return nil;
    }
    return [memoryCache_ objectForKey:[keyPath md5]];
}

- (void)removeObjectForKeyPath:(NSString *)keyPath {
    NSAssert([keyPath length], @"keyPath cannot be nil or empty");
    [memoryCache_ removeObjectForKey:[keyPath md5]];
}

- (void)removeAllObjects {
    [expirationDates_ removeAllObjects];
    [memoryCache_ removeAllObjects];
}

- (void)dealloc {
    [expirationDates_ release];
    [memoryCache_ release];
    [super dealloc];
}

@end
