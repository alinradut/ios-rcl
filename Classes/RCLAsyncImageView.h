//
//  RCLAsyncImageView.h
//  RCL
//
//  Created by clw on 2/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RCL.h"

#define RCL_ASYNC_IMAGE_VIEW_USE_CACHE  1

@interface RCLAsyncImageView : UIImageView <RCLAsyncDownloaderDelegate> {
@private
    NSURL *url_;
    BOOL downloadInProgress_;
}

@property (nonatomic, retain) NSURL *url;
@property (nonatomic) BOOL downloadInProgress;

/*!
 Initialize an instance using a temporary image and an URL string.
 The image download process is immediately started.
 @param urlString URL to remote image
 @param temporaryImage UIImage to be displayed while the remote image is loaded.
 */
- (id)initWithURL:(NSString *)urlString temporaryImage:(UIImage *)temporaryImage;

/*!
 Initialize an instance using a temporary image and an URL string.
 @param urlString URL to remote image
 @param temporaryImage UIImage to be displayed while the remote image is loaded.
 @param startImmediately If YES the download process is started immediately.
 */
- (id)initWithURL:(NSString *)urlString temporaryImage:(UIImage *)temporaryImage startImmediately:(BOOL)start;

/*!
 Start downloading the remote image
 */
- (void)startDownload;
- (void)cancelDownload;

@end
