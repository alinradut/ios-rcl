//
//  RCLMemoryCache.m
//  RCL
//
//  Created by clw on 2/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RCLMemoryCache.h"


@implementation RCLMemoryCache

+ (RCLMemoryCache *)instance {
    static RCLMemoryCache *sharedInstance;
    if (!sharedInstance) {
        sharedInstance = [[RCLMemoryCache alloc] init];
    }
}

- (id)init {
    if (self = [super init]) {
        memoryCache_ = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)storeData:(NSData *)object forKeyPath:(NSString *)keyPath {
    NSAssert(object != nil, @"object cannot be nil");
    NSAssert([keyPath length], @"keyPath cannot be nil or empty");
    [memoryCache_ setObject:object forKey:[keyPath md5]];
}

- (BOOL)objectAvailableForKeyPath:(NSString *)keyPath {
    NSAssert([keyPath length], @"keyPath cannot be nil or empty");
    return [memoryCache_ objectForKey:[keyPath md5]] != nil?YES:NO;
}

- (NSData *)objectForKeyPath:(NSString *)keyPath {
    NSAssert([keyPath length], @"keyPath cannot be nil or empty");
    return [memoryCache_ objectForKey:[keyPath md5]];
}

- (void)removeObjectForKeyPath:(NSString *)keyPath {
    NSAssert([keyPath length], @"keyPath cannot be nil or empty");
    [memoryCache_ removeObjectForKey:[keyPath md5]];
}

- (void)removeAllObjects {
    [memoryCache_ removeAllObjects];
}

- (void)dealloc {
    [memoryCache_ release];
}

@end
