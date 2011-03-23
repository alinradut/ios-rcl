//
//  RCLCacheTest.m
//  RCL
//
//  Created by clw on 2/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RCLCacheTest.h"
#import "RCLCache.h"

@implementation RCLCacheTest

- (void)testSingleton {
    STAssertNotNil([RCLCache instance],@"instance cannot be nil");
}

- (void)testStorageAndRetrieval {
    NSString *storedString = @"Hello world!";
    NSString *keyPath = @"&Hd2h378734&$%Y*(&98";
    
    [[RCLCache instance] storeData:[storedString dataUsingEncoding:NSUTF8StringEncoding] 
                        forKeyPath:keyPath];
    
    STAssertTrue([[RCLCache instance] objectAvailableForKeyPath:keyPath], @"Stored object cannot be found in cache");

    NSData *retrievedObject = [[RCLCache instance] objectForKeyPath:keyPath];
    STAssertNotNil(retrievedObject, @"Retrieved object is nil");
    
    NSString *retrievedString = [[NSString alloc] initWithData:retrievedObject 
                                                      encoding:NSUTF8StringEncoding];
    STAssertEqualStrings(storedString, retrievedString, @"Stored string is different than the retrieved string");
    [retrievedString release];
}

- (void)testStorageAndRemoval {
    NSString *storedString = @"Hello world!";
    NSString *keyPath = @"&Hd2h378734&$%Y*(&98";
    
    [[RCLCache instance] storeData:[storedString dataUsingEncoding:NSUTF8StringEncoding] 
                        forKeyPath:keyPath];
    
    STAssertTrue([[RCLCache instance] objectAvailableForKeyPath:keyPath], @"Stored object cannot be found in cache");

    [[RCLCache instance] removeObjectForKeyPath:keyPath];
    STAssertFalse([[RCLCache instance] objectAvailableForKeyPath:keyPath], @"Stored object was not removed from cache");
}

- (void)testExpiredCache {
    NSString *storedString = @"Hello world!";
    NSString *keyPath = @"&Hd2h378734&$%Y*(&98";
    
    [[RCLCache instance] storeData:[storedString dataUsingEncoding:NSUTF8StringEncoding] 
                        forKeyPath:keyPath
                           expires:[NSDate dateWithTimeIntervalSinceNow:-1]];
    
    STAssertFalse([[RCLCache instance] objectAvailableForKeyPath:keyPath], @"Stored object is still available in cache");
}

@end
