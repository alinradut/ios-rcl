//
//  RCLAsynchronousDownloaderTest.h
//  RCL
//
//  Created by clw on 2/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GTMSenTestCase.h"
#import "RCL.h"

@interface RCLAsyncDownloaderTest : GTMTestCase <RCLAsyncDownloaderDelegate> {
    BOOL executing_;
}

@end
