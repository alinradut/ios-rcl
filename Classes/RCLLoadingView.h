//
//  RCLLoadingView.h
//  RCL
//
//  Created by Clawoo on 5/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RCLLoadingView : UIView {
    UIActivityIndicatorView *activityIndicator_;
    UILabel *label_;
    UIView *backgroundView_;
}

@property (nonatomic, retain) UILabel *label;

+ (void)showWithLabel:(NSString *)label;
+ (void)hide;

@end
