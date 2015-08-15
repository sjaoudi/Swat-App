//
//  MapViewController.m
//  Swat App
//
//  Created by Steve Jaoudi on 7/20/15.
//  Copyright (c) 2015 Steve Jaoudi. All rights reserved.
//

#import "MapViewController.h"

#import "MapTableViewController.h"

//#import <MapboxGL/MapboxGL.h>
//#import <CoreLocation/CoreLocation.h>
#import "Mapbox.h"

@interface MapViewController ()
@property (nonatomic, strong) NSMutableArray *shapes;
@end

@implementation MapViewController

@synthesize searchDisplayController;

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"map loaded");
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    [[RMConfiguration sharedInstance] setAccessToken:@"pk.eyJ1Ijoic2phb3VkaSIsImEiOiIzMWNjNjdjMTRmOTQ2MjUwYzA0OTdjYmM2MTIzZTRhYyJ9.VHYjLmLq9AeTgjQE_X16lg"];
    RMMapboxSource *tileSource = [[RMMapboxSource alloc] initWithMapID:@"sjaoudi.n0fh2c9n"];
    RMMapView *mapView = [[RMMapView alloc] initWithFrame:self.view.bounds
                                            andTilesource:tileSource];
    
    RMMapboxSource *addedTileSource = [[RMMapboxSource alloc] initWithMapID:@"sjaoudi.7422ff37"];
    [mapView addTileSource:addedTileSource];
    mapView.delegate = self;
    mapView.zoom = 16;
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(39.9055000,-75.3538000);
    mapView.centerCoordinate = center;
    //mapView.latitudeLongitudeBoundingBox
    
    [self.view addSubview:mapView];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    //MapTableViewController *mapTable = [[MapTableViewController alloc] init];
    
    searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0., 0., 320., 44.)];
    searchBar.delegate = self;

    searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
    
    searchDisplayController.delegate = self;
    searchDisplayController.searchResultsDataSource = self;
    
    [self.view addSubview:searchBar];
    
    NSDictionary *csvDict = [self parseCSV];
    
    //NSArray *locationsArray = [csvDict objectForKey:@"locations"];
    
    originalData = [csvDict objectForKey:@"places"];

    
}

- (NSDictionary *)parseCSV {
    NSString *pathName = [[NSBundle mainBundle] pathForResource:@"added-buildings"
                                                         ofType:@"csv"];
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *csvString;
    if ([fm fileExistsAtPath:pathName]) {
        csvString = [NSString stringWithContentsOfFile:pathName encoding:NSUTF8StringEncoding error:nil];
    }
    
    NSMutableArray *locationsArray = [[NSMutableArray alloc] init];
    NSMutableArray *placesArray = [[NSMutableArray alloc] init];
    
    NSArray *csvStringArray = [csvString componentsSeparatedByString:@"\n"];
    for (int i=0; i<csvStringArray.count; i++) {
        if (!i) {
            // skips header
            continue;
        }
        NSString *csvStringArrayElt = csvStringArray[i];
        NSArray *csvStringParsed = [csvStringArrayElt componentsSeparatedByString:@","];
        [locationsArray addObject:csvStringParsed];
        [placesArray addObject:csvStringParsed[0]];
        
    }
    
    //NSLog(@"%@", locationsArray);
    
    //return @{locationsArray: @"locations", placesArray: @"places"};
    return @{@"locations": locationsArray, @"places": placesArray};
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [searchData count];
        
    } else {
        return [originalData count];
    }
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    NSLog(@"%@", searchString);
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:
                                    @"SELF contains[cd] %@", searchString];
    
    [searchData removeAllObjects];
    searchData = [[NSMutableArray alloc] initWithArray:[originalData filteredArrayUsingPredicate:resultPredicate]];
    
    return YES;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    static NSString *cellIdentifier = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    NSString *currentValue;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        currentValue = [searchData objectAtIndex:indexPath.row];
    } else {
        currentValue = [originalData objectAtIndex:indexPath.row];
    }
    
    [[cell textLabel]setText:currentValue];
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 71;
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