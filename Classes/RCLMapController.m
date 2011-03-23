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

@synthesize latitudeKey = latitudeKey_;
@synthesize longitudeKey = longitudeKey_;
@synthesize nameKey = nameKey_;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
		self.latitudeKey = @"latitude";
		self.longitudeKey = @"longitude";
		self.nameKey = @"name";
    }
    return self;
}

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

- (void)viewDidLoad {
    [super viewDidLoad];
    if (mapView_ == nil) {
        
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
