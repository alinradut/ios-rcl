//
//  RCLTableViewController.h
//  RCL
//
//  Created by Clawoo on 3/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
//  Based on
//  PullRefreshTableViewController.h - Plancast
//  Originally created by Leah Culver on 7/2/10.
//  Copyright (c) 2010 Leah Culver
//  https://github.com/leah/PullToRefresh

#import <UIKit/UIKit.h>


@interface RCLTableViewController : UITableViewController {
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
