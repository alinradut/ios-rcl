    //
//  RCLMapController.m
//  RCL
//
//  Created by clw on 2/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RCLMapController.h"

@implementation RCLMapController
@synthesize mapView = mapView_;
@synthesize pins = pins_;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

- (void)viewDidLoad {
    [super viewDidLoad];
    if (mapView_ == nil) {
        //mapView_ = [[MKMapView alloc] initWithFrame:self.view];
        mapView_.delegate = self;
    }
    self.pins = [NSMutableArray array];
    
}

#pragma mark -
#pragma mark Memory management
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    self.mapView = nil;
    self.pins = nil;
}

- (void)dealloc {
    [super dealloc];
}


@end
