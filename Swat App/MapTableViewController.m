//
//  MapTableViewController.m
//  Swat App
//
//  Created by Steve Jaoudi on 8/14/15.
//  Copyright (c) 2015 Steve Jaoudi. All rights reserved.
//

#import "MapTableViewController.h"
#import "MapViewController.h"

@implementation MapTableViewController

//@synthesize originalData, searchData;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //originalData = @[@"c", @"ab", @"aa"];
    
    MapViewController *mapView = [[MapViewController alloc] init];
    
    NSDictionary *csvDict = [mapView parseCSV];
    NSLog(@"%@", csvDict);
    
    originalData = [csvDict objectForKey:@"places"];
    
    
    
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

@end