//
//  RCLCache.m
//  RCL
//
//  Created by clw on 2/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RCLCache.h"
#import "RCL.h"
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
                RCLError(@"An error has occured while creating the cache directory %@: %@", 
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

- (id)init {
    if (self = [super init]) {
        NSString *fileName = [RCL_CACHE_DIRECTORY stringByAppendingPathComponent:@"data.plist"];
        data_ = [[NSMutableArray alloc] initWithContentsOfFile:fileName];
    }
    return self;
}

- (void)storeData:(NSData *)object forKeyPath:(NSString *)keyPath {
    [self storeData:object forKeyPath:keyPath expires:[NSDate distantFuture]];
}

- (void)storeData:(NSData *)object forKeyPath:(NSString *)keyPath expires:(NSDate *)expirationDate {
    NSAssert(keyPath != nil, @"keyPath must not be nil");
    NSAssert([keyPath length] != 0, @"keyPath must not be empty");
    NSString *filePath = [RCL_CACHE_DIRECTORY stringByAppendingPathComponent:[keyPath md5]];
    [object writeToFile:filePath atomically:YES];
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          [keyPath md5],@"hash",expirationDate,@"expirationDate", nil];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"hash = %@",[keyPath md5]];
    NSArray *result = [data_ filteredArrayUsingPredicate:predicate];
    
    @synchronized (self) {
        if ([result count]) {
            NSInteger index = [data_ indexOfObject:[result objectAtIndex:0]];
            [data_ replaceObjectAtIndex:index withObject:dict];
        }
        else {
            [data_ addObject:dict];
        }
    }
    [self saveData];
}

- (BOOL)objectAvailableForKeyPath:(NSString *)keyPath {
    NSString *filePath = [RCL_CACHE_DIRECTORY stringByAppendingPathComponent:[keyPath md5]];
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        return NO;
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"hash = %@", [keyPath md5]];
    NSArray *result = [data_ filteredArrayUsingPredicate:predicate];
    if ([result count]) {
        NSDate *expirationDate = [[result objectAtIndex:0] objectForKey:@"expirationDate"];
        if (![expirationDate laterDate:[NSDate date]]) {
            return NO;
        }
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
            RCLWarning(@"Cannot remove item for keyPath %@: %@", keyPath, [error localizedDescription]);
            [error release];
        }
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"hash = %@", [keyPath md5]];
    NSArray *result = [data_ filteredArrayUsingPredicate:predicate];
    
    @synchronized (self) {
        if ([result count]) {
            NSInteger index = [data_ indexOfObject:[result objectAtIndex:0]];
            [data_ removeObjectAtIndex:index];
        }
    }
    [self saveData];
}

- (void)saveData {
    @synchronized (self) {
        [data_ writeToFile:[RCL_CACHE_DIRECTORY stringByAppendingPathComponent:@"data.plist"] 
                atomically:YES];
    }
}

@end