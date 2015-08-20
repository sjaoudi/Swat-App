//
//  MapViewController.h
//  Swat App
//
//  Created by Steve Jaoudi on 7/20/15.
//  Copyright (c) 2015 Steve Jaoudi. All rights reserved.
//

#ifndef Swat_App_MapViewController_h
#define Swat_App_MapViewController_h


#endif

#import "Mapbox.h"
#import <UIKit/UIKit.h>
//#import <MapboxGL/MapboxGL.h>
#import <CoreLocation/CoreLocation.h>


@interface MapViewController : UIViewController <RMMapViewDelegate, UISearchControllerDelegate, UISearchBarDelegate, UISearchDisplayDelegate, UITableViewDelegate, UITableViewDataSource>  {
//@interface MapViewController : UIViewController <> {
    
    NSMutableArray *originalData;
    NSMutableArray *searchData;
    
    
    UISearchBar *searchBar;
    UISearchDisplayController *searchDisplayController;
    
    RMMapView *mapView;
    NSDictionary *csvDict;
    
    UINavigationBar *navbar;
    

}

@property (nonatomic) UISearchDisplayController *searchDisplayController;
@property (nonatomic) UITableView *tableView;
@property (nonatomic) RMMapView *mapView;
@property (nonatomic) NSDictionary *csvDict;
@property (nonatomic) UINavigationBar *navbar;


- (NSDictionary *)parseCSV;
- (void)loadMap;

@end