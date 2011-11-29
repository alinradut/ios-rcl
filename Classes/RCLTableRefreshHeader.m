//
//  RCLTableRefreshHeader.m
//  RCL
//
//  Created by Clawoo on 10/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RCLTableRefreshHeader.h"

@implementation RCLTableRefreshHeader

- (id)init
{
    self = [self initWithFrame:CGRectMake(0, 0 - kRCLRefreshHeaderHeight, 320, kRCLRefreshHeaderHeight)];
    if (self) {
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        refreshLabel_ = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 320, 20)];
        refreshLabel_.backgroundColor = [UIColor clearColor];
        refreshLabel_.font = [UIFont boldSystemFontOfSize:12.0];
        refreshLabel_.textAlignment = UITextAlignmentCenter;
        
        lastRefreshLabel_ = [[UILabel alloc] initWithFrame:CGRectMake(0, kRCLRefreshHeaderHeight - 23, 320, 20)];
        lastRefreshLabel_.backgroundColor = [UIColor clearColor];
        lastRefreshLabel_.font = [UIFont systemFontOfSize:12.0];
        lastRefreshLabel_.textAlignment = UITextAlignmentCenter;
        
        refreshArrow_ = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"RCLResources.bundle/arrow.png"]];
        refreshArrow_.frame = CGRectMake((kRCLRefreshHeaderHeight - 27) / 2,
                                         (kRCLRefreshHeaderHeight - 44) / 2,
                                         27, 44);
        
        refreshSpinner_ = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        refreshSpinner_.frame = CGRectMake((kRCLRefreshHeaderHeight - 20) / 2, (kRCLRefreshHeaderHeight - 20) / 2, 20, 20);
        refreshSpinner_.hidesWhenStopped = YES;
        
        [self addSubview:refreshLabel_];
        [self addSubview:lastRefreshLabel_];
        [self addSubview:refreshArrow_];
        [self addSubview:refreshSpinner_];
    }
    return self;
}

- (void)setLightStyle:(BOOL)lightStyle {
    if (lightStyle) {
        refreshLabel_.textColor = [UIColor lightTextColor];
        lastRefreshLabel_.textColor = [UIColor lightTextColor];
        refreshArrow_.image = [UIImage imageNamed:@"RCLResources.bundle/arrow-light.png"];
        refreshSpinner_.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    }
    else {
        
        refreshLabel_.textColor = [UIColor darkTextColor];
        lastRefreshLabel_.textColor = [UIColor darkTextColor];
        refreshArrow_.image = [UIImage imageNamed:@"RCLResources.bundle/arrow.png"];
        refreshSpinner_.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    }
}

- (void)setState:(RCLTableRefreshState)state {
    state_ = state;
    // Update the arrow direction and label
    [UIView beginAnimations:nil context:NULL];
    switch (state) {
        case RCLTableRefreshStateNormal:
            refreshLabel_.text = @"Pull down to refresh...";
            refreshArrow_.hidden = NO;
            refreshArrow_.transform = CGAffineTransformMakeRotation(M_PI * 2);
            [refreshSpinner_ stopAnimating];
            break;
        case RCLTableRefreshStateDragging:
            refreshLabel_.text = @"Release to refresh...";
            refreshArrow_.transform = CGAffineTransformMakeRotation(M_PI);
            break;
        case RCLTableRefreshStateLoading:
            [UIView setAnimationDuration:0.3];
            refreshLabel_.text = @"Loading...";
            refreshArrow_.hidden = YES;
            [refreshSpinner_ startAnimating];
            break;
            
        default:
            break;
    }
    [UIView commitAnimations];
}

- (void)setLastRefreshDate:(NSDate *)lastRefreshDate {
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
    
    lastRefreshLabel_.text = [NSString stringWithFormat:@"Last updated: %@",[dateFormatter stringFromDate:lastRefreshDate]];
}

- (void)dealloc
{
    [super dealloc];
}

@end
