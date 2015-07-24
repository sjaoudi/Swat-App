//
//  MapViewController.m
//  Swat App
//
//  Created by Steve Jaoudi on 7/20/15.
//  Copyright (c) 2015 Steve Jaoudi. All rights reserved.
//

#import <MapboxGL/MapboxGL.h>
#import <CoreLocation/CoreLocation.h>

#import "MapViewController.h"

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURL *styleURL = [NSURL URLWithString:@"asset://styles/light-v7.json"];
    MGLMapView *mapView = [[MGLMapView alloc] initWithFrame:self.view.bounds
                                                   styleURL:styleURL];
//    MGLMapboxMetricsEnabled = NO;
    
    mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    // set the map's center coordinate and zoom level
    [mapView setCenterCoordinate:CLLocationCoordinate2DMake(40.7326808, -73.9843407)
                       zoomLevel:12
                        animated:NO];
    
    NSLog(@"ok");
    
    [self.view addSubview:mapView];
}

@end