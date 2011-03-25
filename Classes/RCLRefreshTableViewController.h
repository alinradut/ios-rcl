//
//  RCLRefreshTableViewController.h
//  RCL
//
//  Created by Clawoo on 3/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RCLTableViewController.h"

/*!
 The RCLRefreshTableViewController adds pull to refresh functionality
 to the RCLTableViewController. It is basically Leah Culver's PTR TVC
 modified to fit the RCL coding style and fixed in a couple of places.
 
 Based on PullRefreshTableViewController.h - Plancast
 Originally created by Leah Culver on 7/2/10.
 Copyright (c) 2010 Leah Culver
 https://github.com/leah/PullToRefresh
 */
@interface RCLRefreshTableViewController : RCLTableViewController {
    UIView *refreshHeaderView_;
    UILabel *refreshLabel_;
    UILabel *lastRefreshLabel_;
    UIImageView *refreshArrow_;
    UIActivityIndicatorView *refreshSpinner_;
    
    BOOL isDragging_;
    BOOL isLoading_;
    
    NSString *textPull_;
    NSString *textRelease_;
    NSString *textLoading_;
    
    NSDate *lastRefreshDate_;
}

@property (nonatomic, copy) NSString *textPull;
@property (nonatomic, copy) NSString *textRelease;
@property (nonatomic, copy) NSString *textLoading;

- (void)startLoading;
- (void)stopLoading;

@end
