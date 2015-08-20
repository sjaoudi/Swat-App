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

//@interface MapViewController ()
//@property (nonatomic, strong) NSMutableArray *shapes;
//@end

@implementation MapViewController

@synthesize searchDisplayController;
@synthesize mapView;
@synthesize csvDict;
@synthesize navbar;
@synthesize shapes;

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"map loaded");
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [self loadMap];
    
    
    //RMMapboxSource *addedTileSource = [[RMMapboxSource alloc] initWithMapID:@"sjaoudi.7422ff37"];
    //[self.mapView addTileSource:addedTileSource];
    
    self.mapView.delegate = self;
    self.mapView.zoom = 16;
    
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(39.9055000,-75.3538000);
    self.mapView.centerCoordinate = center;
    self.mapView.maxZoom = 18;
    self.mapView.minZoom = 15.3;
    
    // make map expand to fill screen when rotated
    self.mapView.autoresizingMask = UIViewAutoresizingFlexibleHeight |
    UIViewAutoresizingFlexibleWidth;
    
    [self.view addSubview:self.mapView];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0., 20., self.view.bounds.size.width, 44.)];
    searchBar.delegate = self;
    searchBar.tintColor = [UIColor whiteColor];
    [searchBar setBackgroundImage:[UIImage new]];
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setTintColor:[UIColor blackColor]];
    searchBar.layer.borderWidth = 1;
    //searchBar.layer.borderColor = [[UIColor colorWithRed:205/255.0 green:42/255.0 blue:80/255.0 alpha:1.0] CGColor];
    searchBar.layer.borderColor = (__bridge CGColorRef)([UIColor clearColor]);
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setDefaultTextAttributes:@{
                                                                                                 NSFontAttributeName: [UIFont fontWithName:@"Avenir" size:18],
                                                                                                 }];
    
    for (UIView *subview in searchBar.subviews) {
        if ([subview isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
            [subview removeFromSuperview];
            break;
        }
    }
    
    searchBar.tintColor = [UIColor colorWithRed:205/255.0 green:42/255.0 blue:80/255.0 alpha:1.0];
    
    self.navbar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 64)];

    self.navbar.barTintColor = [UIColor colorWithRed:195/255.0 green:32/255.0 blue:70/255.0 alpha:1.0];
    
    [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:                    [UIFont fontWithName:@"Avenir" size:20.0], NSFontAttributeName,
                                                        [UIColor whiteColor],UITextAttributeTextColor,
                                                                                                nil]
                                                                                        forState:UIControlStateNormal];

    //[navbar setTranslucent:NO];

    [self.view addSubview:self.navbar];
    [self.view addSubview:searchBar];

    searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
    
    searchDisplayController.delegate = self;
    searchDisplayController.searchResultsDataSource = self;
    searchDisplayController.searchResultsDelegate = self;
    
    csvDict = [self parseCSV];
    originalData = [csvDict objectForKey:@"places"];
    
    
    
    //convert `boat.geojson` to an NSDIctionary
    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"boat" ofType:@"geojson"];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[[NSData alloc]
                                                                  initWithContentsOfFile:jsonPath]
                                                         options:0
                                                           error:nil];
    
    NSArray *features = json[@"features"];
    
    // create an empty array
    NSMutableArray *theshapes = [[NSMutableArray alloc] init];
    self.shapes = theshapes;
    
    // set the current shape
    for (NSUInteger i = 0; i < [features count]; i++) {
        
        // add an empty array to the shapes array to hold the coordinates
        [self.shapes addObject:[[NSMutableArray alloc] init]];
        
        // get the current shape out of the feature array
        NSDictionary *currentNode = (NSDictionary *)features[i];
        
        NSArray *coordinates = currentNode[@"geometry"][@"coordinates"][0];
        
        // loop over the coordinates in the coordinate array
        for (NSArray *coordinate in coordinates) {
            
            // convert the coordinates to location coordinates
            CLLocation *loc = [[CLLocation alloc]
                               initWithLatitude:[[coordinate lastObject] doubleValue]
                               longitude:[[coordinate firstObject] doubleValue]];
            
            // add the location object (with both coordinates) to the array
            [[self.shapes lastObject] addObject:loc];
        }
    }
    
    NSLog(@"Shapes: %@", self.shapes);

//    RMAnnotation *annotation = [[RMAnnotation alloc] initWithMapView:self.mapView
//                                                          coordinate:self.mapView.centerCoordinate
//                                                            andTitle:@"My Path"];
//    
//    // add the shapes to the mapView
//    [self.mapView addAnnotation:annotation];
//    //[annotation setBoundingBoxFromLocations:[self.shapes objectAtIndex:0]];
    
    NSArray *locations = [NSArray arrayWithObjects:
                          [[CLLocation alloc] initWithLatitude:39.906885 longitude:-75.353064],
                          [[CLLocation alloc] initWithLatitude:39.906901 longitude:-75.352533],
                          [[CLLocation alloc] initWithLatitude:39.906609 longitude:-75.352812],
                          [[CLLocation alloc] initWithLatitude:39.906885 longitude:-75.353064],
                          nil];
    
    RMAnnotation *annotation = [[RMAnnotation alloc] initWithMapView:mapView
                                                          coordinate:((CLLocation *)[self.shapes[0] objectAtIndex:0]).coordinate
                                                            andTitle:@"Home"];
    
    annotation.userInfo = self.shapes[0];
    
    [annotation setBoundingBoxFromLocations:self.shapes[0]];
    
    [mapView addAnnotation:annotation];
}

- (RMMapLayer *)mapView:(RMMapView *)mapView layerForAnnotation:(RMAnnotation *)annotation
{
    if (annotation.isUserLocationAnnotation)
        return nil;
    
    RMShape *shape = [[RMShape alloc] initWithView:self.mapView];
    
    // set line color and width
    shape.lineColor = [UIColor colorWithRed:0.224 green:0.671 blue:0.780 alpha:1.000];
    shape.lineWidth = 0.5;
    
    for (CLLocation *location in (NSArray *)annotation.userInfo)
        [shape addLineToCoordinate:location.coordinate];
    
    return shape;
    
}

- (void)loadMap {
    [[RMConfiguration sharedInstance] setAccessToken:@"pk.eyJ1Ijoic2phb3VkaSIsImEiOiIzMWNjNjdjMTRmOTQ2MjUwYzA0OTdjYmM2MTIzZTRhYyJ9.VHYjLmLq9AeTgjQE_X16lg"];
    //RMMapboxSource *tileSource = [[RMMapboxSource alloc] initWithMapID:@"sjaoudi.ef0b6517"];
    
    RMMapboxSource *tileSource = [[RMMapboxSource alloc] initWithMapID:@"sjaoudi.n7eh1di1"];
    self.mapView = [[RMMapView alloc] initWithFrame:self.view.bounds
                                      andTilesource:tileSource];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    CGRect frame = self.navbar.frame;
    if (UIInterfaceOrientationIsPortrait(fromInterfaceOrientation)) {
        frame.size.width = self.view.bounds.size.width;
    } else {
        frame.size.width = self.view.bounds.size.width;
    }
    self.navbar.frame = frame;
}

- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    NSString *place = [searchData objectAtIndex:indexPath.row];
    NSLog(@"%@", place);
    [self.searchDisplayController setActive:NO];
    
    CLLocationCoordinate2D coord = [[[csvDict objectForKey:@"locations"] objectForKey:place] coordinate];
    [self.mapView setCenterCoordinate:coord animated:YES];
    [self.mapView setZoom:17];
    NSLog(@"%@, %f %f", place, coord.latitude, coord.longitude);
}

- (NSDictionary *)parseCSV {
    NSString *pathName = [[NSBundle mainBundle] pathForResource:@"all-buildings"
                                                         ofType:@"csv"];
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *csvString;
    if ([fm fileExistsAtPath:pathName]) {
        csvString = [NSString stringWithContentsOfFile:pathName encoding:NSUTF8StringEncoding error:nil];
    }
    
    NSMutableDictionary *locationsDict = [[NSMutableDictionary alloc] init];
    NSMutableArray *placesArray = [[NSMutableArray alloc] init];
    
    NSArray *csvStringArray = [csvString componentsSeparatedByString:@"\n"];
    for (int i=0; i<csvStringArray.count; i++) {
        if (!i) {
            // skips header
            continue;
        }
        NSString *csvStringArrayElt = csvStringArray[i];
        if ([csvStringArrayElt length]) {
            NSArray *csvStringParsed = [csvStringArrayElt componentsSeparatedByString:@","];
            CLLocationDegrees lat = [csvStringParsed[1] doubleValue];
            CLLocationDegrees lon = [csvStringParsed[2] doubleValue];
            CLLocation *location = [[CLLocation alloc] initWithLatitude:lat longitude:lon];
            [locationsDict setValue:location forKey:csvStringParsed[0]];
            [placesArray addObject:csvStringParsed[0]];
        }
    }
    
    return @{@"locations": locationsDict, @"places": placesArray};
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
    //NSLog(@"%@", searchString);
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
    
    cell.textLabel.textColor = [UIColor colorWithRed:(51/255.f) green:(51/255.f) blue:(51/255.f) alpha:1.0f];
    [cell.textLabel setFont:[UIFont fontWithName:@"Avenir" size:18]];
    
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGSize titleSize = [[searchData objectAtIndex:indexPath.row] sizeWithFont:[UIFont fontWithName:@"Avenir" size:18]
                              constrainedToSize:CGSizeMake(self.view.bounds.size.width - 40, MAXFLOAT)  // - 40 For cell padding
                                  lineBreakMode:NSLineBreakByWordWrapping];
    
    CGFloat titleHeight = titleSize.height + 20;
    return titleHeight;
}

//- (RMMapLayer *)mapView:(RMMapView *)mapView layerForAnnotation:(RMAnnotation *)annotation
//{
//    if (annotation.isUserLocationAnnotation)
//        return nil;
//
//    // add Maki icon and color the marker
//    RMMarker *marker = [[RMMarker alloc] initWithMapboxMarkerImage:@"rocket" tintColor:
//                        [UIColor colorWithRed:0.224 green:0.671 blue:0.780 alpha:1.000]];
//    
//    marker.canShowCallout = YES;
//    
//    return marker;
//}

@end