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
@synthesize indicator = indicator_;

- (id)init {
    if ((self = [super init])) {
        
        self.webView = [[[UIWebView alloc] init] autorelease];
        webView_.delegate = self;
        webView_.scalesPageToFit = YES;

        self.indicator = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite] autorelease];
        
        indicator_.hidesWhenStopped = YES;    
        
        NSArray *buttons = [NSArray arrayWithObjects:[UIImage imageNamed:@"RCLResources.bundle/prev.png"], [UIImage imageNamed:@"RCLResources.bundle/next.png"], nil];
        
        self.segmentedControl = [[UISegmentedControl alloc] initWithItems:buttons];
        self.segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
        self.segmentedControl.momentary = YES;
        
        [self.segmentedControl addTarget:self action:@selector(navButtonTapped:) forControlEvents:UIControlEventValueChanged];

    }
    return self;
}

#pragma mark - View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    webView_.frame = CGRectMake(0, 
                                0, 
                                self.view.frame.size.width, 
                                self.view.frame.size.height);
    [self.view addSubview:webView_];
    
    CGRect frame = self.navigationController.navigationBar.frame;
    indicator_.frame = CGRectMake(frame.size.width - 100, frame.size.height/2 - 10, 20, 20);
    [self.navigationController.navigationBar addSubview:indicator_];
    
    UIBarButtonItem *prevNextButton = [[[UIBarButtonItem alloc] initWithCustomView:segmentedControl_] autorelease];
    self.navigationItem.rightBarButtonItem = prevNextButton;
}

- (void)viewWillAppear:(BOOL)animated {
    
}

- (void)loadUrl:(NSURL *)url {
    [webView_ loadRequest:[NSURLRequest requestWithURL:url]];
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [segmentedControl_ setEnabled:webView_.canGoBack forSegmentAtIndex:0];
    [segmentedControl_ setEnabled:webView_.canGoForward forSegmentAtIndex:1];
    [indicator_ startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [segmentedControl_ setEnabled:webView_.canGoBack forSegmentAtIndex:0];
    [segmentedControl_ setEnabled:webView_.canGoForward forSegmentAtIndex:1];
    [indicator_ stopAnimating];
}

#pragma mark - Navigation actions
- (void)navButtonTapped:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == 0) {
        [webView_ goBack];
    }
    else {
        [webView_ goForward];
    }
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
    self.indicator = nil;
    [super dealloc];
}

@end
