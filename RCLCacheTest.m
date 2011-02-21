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

@end
