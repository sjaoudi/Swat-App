//
//  MapViewController.m
//  Swat App
//
//  Created by Steve Jaoudi on 7/20/15.
//  Copyright (c) 2015 Steve Jaoudi. All rights reserved.
//

#import "MapViewController.h"

//#import <MapboxGL/MapboxGL.h>
//#import <CoreLocation/CoreLocation.h>
#import "Mapbox.h"

@implementation MapViewController


- (void)viewDidLoad {
    //[super viewDidLoad];
    
    //MGLMapView *mapView = [[MGLMapView alloc] initWithFrame:self.view.bounds];
    
    //mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    // set the map's center coordinates and zoom level
    //[mapView setCenterCoordinate:CLLocationCoordinate2DMake(40.7326808, -73.9843407)
    //                   zoomLevel:12
    //                    animated:NO];
    
    //[self.view addSubview:mapView];
    [super viewDidLoad];
    
    NSLog(@"map loaded");
    
    [[RMConfiguration sharedInstance] setAccessToken:@"pk.eyJ1Ijoic2phb3VkaSIsImEiOiIzMWNjNjdjMTRmOTQ2MjUwYzA0OTdjYmM2MTIzZTRhYyJ9.VHYjLmLq9AeTgjQE_X16lg"];
    
    RMMapboxSource *tileSource = [[RMMapboxSource alloc] initWithMapID:@"sjaoudi.n0d2kjg4"];
    
    RMMapView *mapView = [[RMMapView alloc] initWithFrame:self.view.bounds
                                            andTilesource:tileSource];
    // set zoom
    mapView.zoom = 17;
    
    // set coordinates
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(39.9055000,-75.3538000);
    
    // center the map to the coordinates
    mapView.centerCoordinate = center;
    
    [self.view addSubview:mapView];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

@end