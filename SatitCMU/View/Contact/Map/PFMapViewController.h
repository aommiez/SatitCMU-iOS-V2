//
//  PEMapViewController.h
//  SatitCMU
//
//  Created by MRG on 3/10/2557 BE.
//  Copyright (c) 2557 Platwo fusion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFMapView.h"
#import "CMMapLauncher.h"

@protocol PFMapViewControllerDelegate <NSObject>

- (void)PFMapViewControllerBack;

@end

@interface PFMapViewController : UIViewController <CLLocationManagerDelegate>

@property (retain, nonatomic) IBOutlet PFMapView *mapView;
@property (retain, nonatomic) CLLocationManager *locationManager;
@property (retain, nonatomic) CLLocation *currentLocation;
@property (assign, nonatomic) id<PFMapViewControllerDelegate> delegate;

@property (strong, nonatomic) NSString *locationname;
@property (strong, nonatomic) NSString *lat;
@property (strong, nonatomic) NSString *lng;

@end
