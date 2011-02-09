//
//  RCLCache.m
//  RCL
//
//  Created by clw on 2/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RCLCache.h"
#import "RCLString.h"

@implementation RCLCache

+ (RCLCache *)instance {
    static RCLCache *sharedInstance;
    if (!sharedInstance) {
        sharedInstance = [[RCLCache alloc] init];
    }
    return sharedInstance;
}

- (void)storeData:(NSData *)object forKeyPath:(NSString *)keyPath {
    NSAssert(keyPath != nil, @"keyPath must not be nil");
    NSAssert([keyPath length] != 0, @"keyPath must not be empty");
    NSString *filePath = [RCL_CACHE_DIRECTORY stringByAppendingPathComponent:[keyPath md5]];
    [object writeToFile:filePath atomically:YES];
}

- (BOOL)objectAvailableForKeyPath:(NSString *)keyPath {
    NSString *filePath = [RCL_CACHE_DIRECTORY stringByAppendingPathComponent:[keyPath md5]];
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        return NO;
    }
    return YES;
}

- (NSData *)objectForKeyPath:(NSString *)keyPath {
    NSAssert(keyPath != nil, @"keyPath must not be nil");
    NSAssert([keyPath length] != 0, @"keyPath must not be empty");
    
    NSString *filePath = [RCL_CACHE_DIRECTORY stringByAppendingPathComponent:[keyPath md5]];
    if ([self objectAvailableForKeyPath:keyPath]) {
        return [NSData dataWithContentsOfFile:filePath];
    }
    return nil;
}

@end