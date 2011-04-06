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
@synthesize dataSource = dataSource_;

@synthesize latitudeKey = latitudeKey_;
@synthesize longitudeKey = longitudeKey_;
@synthesize nameKey = nameKey_;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
		self.latitudeKey = @"latitude";
		self.longitudeKey = @"longitude";
		self.nameKey = @"name";
        self.pins = [NSMutableArray array];
        self.dataSource = [NSMutableArray array];
        mapView_.delegate = self;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark -
#pragma mark Memory management
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)dealloc {
    self.mapView = nil;
    self.pins = nil;
    self.dataSource = nil;
    [super dealloc];
}


@end
