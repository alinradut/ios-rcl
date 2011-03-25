//
//  RCLRefreshTableViewController.m
//  RCL
//
//  Created by Clawoo on 3/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RCLRefreshTableViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface RCLTableViewController (Private)
- (void)addRefreshHeaderView;
@end

#define kRCLRefreshHeaderHeight 52.0f

@implementation RCLRefreshTableViewController
@synthesize textPull = textPull_;
@synthesize textLoading = textLoading_;
@synthesize textRelease = textRelease_;

- (void)viewDidLoad {
    
    self.textPull = @"Pull down to refresh...";
    self.textRelease = @"Release to refresh...";
    self.textLoading = @"Loading...";
    
    [self addRefreshHeaderView];
}

- (void)addRefreshHeaderView {
    refreshHeaderView_ = [[UIView alloc] initWithFrame:CGRectMake(0, 0 - kRCLRefreshHeaderHeight, 320, kRCLRefreshHeaderHeight)];
    refreshHeaderView_.backgroundColor = [UIColor clearColor];
    
    refreshLabel_ = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, kRCLRefreshHeaderHeight)];
    refreshLabel_.backgroundColor = [UIColor clearColor];
    refreshLabel_.font = [UIFont boldSystemFontOfSize:12.0];
    refreshLabel_.textAlignment = UITextAlignmentCenter;
    
    lastRefreshLabel_ = [[UILabel alloc] initWithFrame:CGRectMake(0, kRCLRefreshHeaderHeight - 20, 320, 20)];
    lastRefreshLabel_.backgroundColor = [UIColor clearColor];
    lastRefreshLabel_.font = [UIFont systemFontOfSize:12.0];
    lastRefreshLabel_.textAlignment = UITextAlignmentCenter;
    lastRefreshLabel_.text = @"Last refreshed: ";
    
    refreshArrow_ = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow.png"]];
    refreshArrow_.frame = CGRectMake((kRCLRefreshHeaderHeight - 27) / 2,
                                     (kRCLRefreshHeaderHeight - 44) / 2,
                                     27, 44);
    
    refreshSpinner_ = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    refreshSpinner_.frame = CGRectMake((kRCLRefreshHeaderHeight - 20) / 2, (kRCLRefreshHeaderHeight - 20) / 2, 20, 20);
    refreshSpinner_.hidesWhenStopped = YES;
    
    [refreshHeaderView_ addSubview:refreshLabel_];
    [refreshHeaderView_ addSubview:lastRefreshLabel_];
    [refreshHeaderView_ addSubview:refreshArrow_];
    [refreshHeaderView_ addSubview:refreshSpinner_];
    
    [self.tableView addSubview:refreshHeaderView_];
    
    [refreshHeaderView_ release];
    [refreshLabel_ release];
    [lastRefreshLabel_ release];
    [refreshArrow_ release];
    [refreshSpinner_ release];
}

#pragma mark -
#pragma Pull to refresh functionality

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (isLoading_) return;
    isDragging_ = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (isLoading_) {
        // Update the content inset, good for section headers
        if (scrollView.contentOffset.y > 0)
            self.tableView.contentInset = UIEdgeInsetsZero;
        else if (scrollView.contentOffset.y >= -kRCLRefreshHeaderHeight)
            self.tableView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (isDragging_ && scrollView.contentOffset.y < 0) {
        // Update the arrow direction and label
        [UIView beginAnimations:nil context:NULL];
        if (scrollView.contentOffset.y < -kRCLRefreshHeaderHeight) {
            // User is scrolling above the header
            refreshLabel_.text = self.textRelease;
            [refreshArrow_ layer].transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
        } else { // User is scrolling somewhere within the header
            refreshLabel_.text = self.textPull;
            [refreshArrow_ layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
        }
        [UIView commitAnimations];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (isLoading_) return;
    isDragging_ = NO;
    if (scrollView.contentOffset.y <= -kRCLRefreshHeaderHeight) {
        // Released above the header
        [self startLoading];
    }
}

- (void)startLoading {
    isLoading_ = YES;
    
    // Show the header
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    self.tableView.contentInset = UIEdgeInsetsMake(kRCLRefreshHeaderHeight, 0, 0, 0);
    refreshLabel_.text = self.textLoading;
    refreshArrow_.hidden = YES;
    [refreshSpinner_ startAnimating];
    [UIView commitAnimations];
}

- (void)stopLoading {
    isLoading_ = NO;
    
    // Hide the header
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDidStopSelector:@selector(stopLoadingComplete:finished:context:)];
    self.tableView.contentInset = UIEdgeInsetsZero;
    [refreshArrow_ layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
    [UIView commitAnimations];
}

- (void)stopLoadingComplete:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    // Reset the header
    refreshLabel_.text = self.textPull;
    refreshArrow_.hidden = NO;
    [refreshSpinner_ stopAnimating];
}

- (void)refresh {
    [self startLoading];
}

#pragma -
#pragma Memory management
- (void)viewDidUnload {
    // clean up work that has been done in the viewDidLoad method
    if (refreshHeaderView_) {
        [refreshHeaderView_ removeFromSuperview];
        refreshHeaderView_ = nil;
    }
    self.textPull = nil;
    self.textRelease = nil;
    self.textLoading = nil;
}

- (void)dealloc {
    self.textLoading = nil;
    self.textPull = nil;
    self.textRelease = nil;
    [super dealloc];
}
@end
