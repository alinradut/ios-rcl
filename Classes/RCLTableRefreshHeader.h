//
//  RCLTableRefreshHeader.h
//  RCL
//
//  Created by Clawoo on 10/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kRCLRefreshHeaderHeight 52.0f

typedef enum {
    RCLTableRefreshStateNormal,
    RCLTableRefreshStateDragging,
    RCLTableRefreshStateLoading
} RCLTableRefreshState;

@interface RCLTableRefreshHeader : UIView {
    UILabel                 *refreshLabel_;
    UILabel                 *lastRefreshLabel_;
    UIImageView             *refreshArrow_;
    UIActivityIndicatorView *refreshSpinner_;

    RCLTableRefreshState    state_;
}

- (void)setLightStyle:(BOOL)lightStyle;
- (void)setState:(RCLTableRefreshState)state;
- (void)setLastRefreshDate:(NSDate *)lastRefreshDate;

@end
