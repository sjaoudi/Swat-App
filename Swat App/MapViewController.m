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

@interface MapViewController ()
@property (nonatomic, strong) NSMutableArray *shapes;
@end

@implementation MapViewController

@synthesize hideAttribution;

- (void)viewDidLoad {

    [super viewDidLoad];
    hideAttribution = YES;
    
    NSLog(@"map loaded");
    
    [[RMConfiguration sharedInstance] setAccessToken:@"pk.eyJ1Ijoic2phb3VkaSIsImEiOiIzMWNjNjdjMTRmOTQ2MjUwYzA0OTdjYmM2MTIzZTRhYyJ9.VHYjLmLq9AeTgjQE_X16lg"];
    
    //RMMapboxSource *tileSource = [[RMMapboxSource alloc] initWithMapID:@"sjaoudi.n0d2kjg4"];
    RMMapboxSource *tileSource = [[RMMapboxSource alloc] initWithMapID:@"sjaoudi.ef0b6517"];
    
    RMMapView *mapView = [[RMMapView alloc] initWithFrame:self.view.bounds
                                            andTilesource:tileSource];
    
    mapView.delegate = self;
    
    mapView.zoom = 16;
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(39.9055000,-75.3538000);
    mapView.centerCoordinate = center;
    
    self.navigationItem.rightBarButtonItem = [[RMUserTrackingBarButtonItem alloc] initWithMapView:mapView];
    mapView.userTrackingMode = RMUserTrackingModeFollow;
    
    [self.view addSubview:mapView];
    //[self.navigationController setNavigationBarHidden:YES animated:NO];
    
    // convert `boat.geojson` to an NSDIctionary
    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"tags" ofType:@"geojson"];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[[NSData alloc]
                                                                  initWithContentsOfFile:jsonPath]
                                                         options:0
                                                           error:nil];
    
    NSArray *features = json[@"features"];
    
    
    // set the current shape
    for (NSUInteger i = 0; i < [features count]; i++) {
        NSDictionary *currentNode = (NSDictionary *)features[i];
        NSArray *coordinates = currentNode[@"geometry"][@"coordinates"];
        
        CLLocationDegrees latitude = [[coordinates lastObject] doubleValue];
        CLLocationDegrees longitude = [[coordinates firstObject] doubleValue];
        CLLocationCoordinate2D loc2d = CLLocationCoordinate2DMake(latitude, longitude);
        
        RMPointAnnotation *annotation = [[RMPointAnnotation alloc] initWithMapView:mapView
                                                              coordinate:loc2d
                                                                          andTitle:currentNode[@"properties"][@"title"]];
        
        [mapView addAnnotation:annotation];
    }
}

- (RMMapLayer *)mapView:(RMMapView *)mapView layerForAnnotation:(RMAnnotation *)annotation
{
    if (annotation.isUserLocationAnnotation)
        return nil;
    
    // add Maki icon and color the marker
    RMMarker *marker = [[RMMarker alloc] initWithMapboxMarkerImage:@"rocket" tintColor:
                        [UIColor colorWithRed:0.224 green:0.671 blue:0.780 alpha:1.000]];
    
    marker.canShowCallout = YES;
    
    return marker;
}

@end