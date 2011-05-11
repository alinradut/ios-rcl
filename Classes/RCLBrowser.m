//
//  RCLBrowser.m
//  RCL
//
//  Created by Clawoo on 5/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RCLBrowser.h"


@implementation RCLBrowser

@synthesize webView = webView_;
@synthesize segmentedControl = segmentedControl_;

#pragma mark - View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView = [[[UIWebView alloc] initWithFrame:CGRectMake(0, 
                                                                0, 
                                                                self.view.frame.size.width, 
                                                                self.view.frame.size.height)] autorelease];
    webView_.delegate = self;
    self.segmentedControl = [[UISegmentedControl alloc] init];
}
- (void)loadUrl:(NSURL *)url {
    [webView_ loadRequest:[NSURLRequest requestWithURL:url]];
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
}

#pragma mark -
#pragma mark Memory management
- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)dealloc {
    self.webView = nil;
    self.segmentedControl = nil;
    [super dealloc];
}

@end
