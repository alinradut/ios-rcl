//
//  RCLString.h
//  RCL
//
//  Created by clw on 2/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>

//! NSString category
/*! 
 A collection of useful methods that extend NSString functionality
 */
@interface NSString (RCLString)

//! Computes the MD5 hash of an NSString
- (NSString *)md5;

@end
