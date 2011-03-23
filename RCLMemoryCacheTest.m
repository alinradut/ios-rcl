//
//  RCLMemoryCacheTest.m
//  RCL
//
//  Created by Clawoo on 3/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RCLMemoryCacheTest.h"
#import "RCLMemoryCache.h"

@implementation RCLMemoryCacheTest

- (void)testStorageAndRetrieval {
    NSString *storedString = @"Hello world!";
    NSString *keyPath = @"&Hd2h378734&$%Y*(&98";
    
    [[RCLMemoryCache instance] storeData:[storedString dataUsingEncoding:NSUTF8StringEncoding] 
                              forKeyPath:keyPath];
    
    STAssertTrue([[RCLMemoryCache instance] objectAvailableForKeyPath:keyPath], @"Stored object cannot be found in cache");
    
    NSData *retrievedObject = [[RCLMemoryCache instance] objectForKeyPath:keyPath];
    STAssertNotNil(retrievedObject, @"Retrieved object is nil");
    
    NSString *retrievedString = [[NSString alloc] initWithData:retrievedObject 
                                                      encoding:NSUTF8StringEncoding];
    STAssertEqualStrings(storedString, retrievedString, @"Stored string is different than the retrieved string");
    [retrievedString release];
}

- (void)testStorageAndRemoval {
    NSString *storedString = @"Hello world!";
    NSString *keyPath = @"&Hd2h378734&$%Y*(&98";
    
    [[RCLMemoryCache instance] storeData:[storedString dataUsingEncoding:NSUTF8StringEncoding] 
                              forKeyPath:keyPath];
    
    STAssertTrue([[RCLMemoryCache instance] objectAvailableForKeyPath:keyPath], @"Stored object cannot be found in cache");
    
    [[RCLMemoryCache instance] removeObjectForKeyPath:keyPath];
    STAssertFalse([[RCLMemoryCache instance] objectAvailableForKeyPath:keyPath], @"Stored object was not removed from cache");
}

- (void)testExpiredCache {
    NSString *storedString = @"Hello world!";
    NSString *keyPath = @"&Hd2h378734&$%Y*(&98";
    
    [[RCLMemoryCache instance] storeData:[storedString dataUsingEncoding:NSUTF8StringEncoding] 
                              forKeyPath:keyPath
                                 expires:[NSDate dateWithTimeIntervalSinceNow:-1]];
    
    STAssertFalse([[RCLMemoryCache instance] objectAvailableForKeyPath:keyPath], @"Stored object is still available in cache");
    
    [[RCLMemoryCache instance] storeData:[storedString dataUsingEncoding:NSUTF8StringEncoding] 
                              forKeyPath:keyPath
                                 expires:[NSDate dateWithTimeIntervalSinceNow:1]];
    STAssertTrue([[RCLMemoryCache instance] objectAvailableForKeyPath:keyPath], @"Stored object is not available in cache although not expired yet");
    [NSThread sleepForTimeInterval:1];
    // the object should have expired by now
    STAssertFalse([[RCLMemoryCache instance] objectAvailableForKeyPath:keyPath], @"Stored object is still available in cache after expiration date");
}

@end
