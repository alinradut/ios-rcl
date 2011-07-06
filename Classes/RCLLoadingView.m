//
//  RCLLoadingView.m
//  RCL
//
//  Created by Clawoo on 5/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RCLLoadingView.h"
#import <QuartzCore/QuartzCore.h>

@implementation RCLLoadingView

static RCLLoadingView *loadingView;

@synthesize label = label_;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:[[UIApplication sharedApplication] keyWindow].frame];
    if (self) {
        backgroundView_ = [[UIView alloc] initWithFrame:CGRectMake(90, 170, 140, 140)];
        [backgroundView_ setBackgroundColor:[UIColor colorWithWhite:.1 alpha:.7]];
        [[backgroundView_ layer] setCornerRadius:10];
        
        activityIndicator_ = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        activityIndicator_.frame = CGRectMake(50, 50, 40, 40);
        [activityIndicator_ startAnimating];
        [backgroundView_ addSubview:activityIndicator_];
        [activityIndicator_ release];
        
        label_ = [[UILabel alloc] initWithFrame:CGRectMake(10, 110, 120, 20)];
        [label_ setBackgroundColor:[UIColor clearColor]];
        [label_ setText:@"Loading..."];
        [label_ setTextAlignment:UITextAlignmentCenter];
        [label_ setTextColor:[UIColor whiteColor]];
        [label_ setFont:[UIFont boldSystemFontOfSize:16]];
        [label_ setAdjustsFontSizeToFitWidth:YES];
        [backgroundView_ addSubview:label_];
        [label_ release];
        
        [self addSubview:backgroundView_];
        [backgroundView_ release];
        self.transform = CGAffineTransformMakeScale(0.01, 0.01);
        [[[UIApplication sharedApplication] keyWindow] addSubview:self];
    }
    return self;
}


+ (void)showWithLabel:(NSString *)label {
    if (!loadingView) {
        loadingView = [[RCLLoadingView alloc] init];
    }
    [[[UIApplication sharedApplication] keyWindow] bringSubviewToFront:loadingView];
    loadingView.label.text = label;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationOptionCurveEaseIn];
    [UIView setAnimationDuration:.2];
    loadingView.transform = CGAffineTransformMakeScale(1, 1);
    loadingView.alpha = 1;
    [UIView commitAnimations];
}

+ (void)hide { 
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationOptionCurveEaseIn];
    [UIView setAnimationDuration:.2];
    loadingView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    loadingView.alpha = 0;
    [UIView commitAnimations];
}

- (void)dealloc {
    [super dealloc];
}

@end
