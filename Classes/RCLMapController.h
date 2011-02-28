//
//  RCLMapController.h
//  RCL
//
//  Created by clw on 2/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface RCLMapController : UIViewController <MKMapViewDelegate> {
    MKMapView *mapView_;
    NSMutableArray *pins_;
}

@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) NSMutableArray *pins;

@end
