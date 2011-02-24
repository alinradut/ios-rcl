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
        BOOL isDirectory = NO;
        if (![[NSFileManager defaultManager] fileExistsAtPath:RCL_CACHE_DIRECTORY 
                                                 isDirectory:&isDirectory]) {
            NSError *error = nil;
            [[NSFileManager defaultManager] createDirectoryAtPath:RCL_CACHE_DIRECTORY 
                                      withIntermediateDirectories:YES 
                                                       attributes:nil 
                                                            error:&error];
            if (error != nil) {
                NSLog(@"An error has occured while creating the cache directory %@: %@", 
                      RCL_CACHE_DIRECTORY, [error localizedDescription]);
                [error release];
            }
        }  
        else if (!isDirectory) {
            NSAssert(NO,@"Cannot create cache directory because a file already exists at path");
        }
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

- (void)removeObjectForKeyPath:(NSString *)keyPath {
    NSAssert(keyPath != nil, @"keyPath must not be nil");
    NSAssert([keyPath length] != 0, @"keyPath must not be empty");
    
    NSString *filePath = [RCL_CACHE_DIRECTORY stringByAppendingPathComponent:[keyPath md5]];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSError *error = nil;
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
        if (error != nil) {
            NSLog(@"Cannot remove item for keyPath %@: %@", keyPath, [error localizedDescription]);
            [error release];
        }
    }
}

@end