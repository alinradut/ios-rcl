//
//  RCLBrowser.h
//  RCL
//
//  Created by Clawoo on 5/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RCLBrowser : UIViewController <UIWebViewDelegate> {
    UIWebView *webView_;
    UISegmentedControl *segmentedControl_;
    UIActivityIndicatorView *indicator_;
}

@property (nonatomic, retain) UIWebView *webView;
@property (nonatomic, retain) UISegmentedControl *segmentedControl;
@property (nonatomic, retain) UIActivityIndicatorView *indicator;

- (void)loadUrl:(NSURL *)url;

@end
