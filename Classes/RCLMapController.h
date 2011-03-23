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
	NSMutableArray *dataSource_;
	
	NSString *latitudeKey_;
	NSString *longitudeKey_;
	NSString *nameKey_;
}

@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) NSMutableArray *pins;
@property (nonatomic, retain) NSMutableArray *dataSource;
@property (nonatomic, retain) NSString *latitudeKey;
@property (nonatomic, retain) NSString *longitudeKey;
@property (nonatomic, retain) NSString *nameKey;

@end
