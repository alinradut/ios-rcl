//
//  RCLRefreshTableViewController.m
//  RCL
//
//  Created by Clawoo on 3/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RCLRefreshTableViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "RCLTableRefreshHeader.h"

@interface RCLRefreshTableViewController (Private)
- (void)addRefreshHeaderView;
@end

@implementation RCLRefreshTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addRefreshHeaderView];
    [refreshHeaderView_ setLastRefreshDate:[NSDate date]];
}

- (void)addRefreshHeaderView {
    refreshHeaderView_ = [[RCLTableRefreshHeader alloc] init];
    
    [self.tableView addSubview:refreshHeaderView_];
    
    [refreshHeaderView_ release];
}

#pragma mark -
#pragma Pull to refresh functionality

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (isReloading_) return;
    isDragging_ = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (isReloading_) {
        // Update the content inset, good for section headers
        if (scrollView.contentOffset.y > 0)
            self.tableView.contentInset = UIEdgeInsetsZero;
        else if (scrollView.contentOffset.y >= -kRCLRefreshHeaderHeight)
            self.tableView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (isDragging_ && scrollView.contentOffset.y < 0) {
        // User is scrolling above the header
        if (scrollView.contentOffset.y < -kRCLRefreshHeaderHeight) {
            [refreshHeaderView_ setState:RCLTableRefreshStateDragging];
        } 
        // User is scrolling somewhere within the header
        else { 
            [refreshHeaderView_ setState:RCLTableRefreshStateNormal];
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (isReloading_) return;
    isDragging_ = NO;
    if (scrollView.contentOffset.y <= -kRCLRefreshHeaderHeight) {
        // Released above the header
        [self startReloadingResults];
    }
}

- (void)startReloadingResults {
    isReloading_ = YES;
    
    // Show the header
    [refreshHeaderView_ setState:RCLTableRefreshStateLoading];
}

- (void)didEndReloadingResults {
    isReloading_ = NO;
    
    // Hide the header
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDidStopSelector:@selector(stopLoadingComplete:finished:context:)];
    self.tableView.contentInset = UIEdgeInsetsZero;
    [UIView commitAnimations];
    [refreshHeaderView_ setLastRefreshDate:[NSDate date]];
}

- (void)stopLoadingComplete:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    // Reset the header
    [refreshHeaderView_ setState:RCLTableRefreshStateNormal];
}

- (void)refresh {
    [self startReloadingResults];
}

#pragma -
#pragma Memory management
- (void)viewDidUnload {
    [super viewDidUnload];
    // clean up work that has been done in the viewDidLoad method
    if (refreshHeaderView_) {
        [refreshHeaderView_ removeFromSuperview];
        refreshHeaderView_ = nil;
    }
}

- (void)dealloc {
    [super dealloc];
}
@end
