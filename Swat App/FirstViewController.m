//
//  FirstViewController.m
//  Swat App
//
//  Created by Steve Jaoudi on 6/14/15.
//  Copyright (c) 2015 Steve Jaoudi. All rights reserved.
//

#import "FirstViewController.h"

#import "HoursViewController.h"
#import "TransportationViewController.h"

@interface FirstViewController () {
    NSDictionary *menuItem;
    NSArray *menuTitles;
}

@end

@implementation FirstViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    menuItem = @{@"Menu" : @[@"Hours", @"Menus", @"Transportation", @"Emergency Info"]};
    
    menuTitles = [[menuItem allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.scrollEnabled = NO;
    
    //[self.navigationController setNavigationBarHidden:YES animated:YES];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    NSString *sectionTitle = [menuTitles objectAtIndex:indexPath.section];
    NSArray *sectionAnimals = [menuItem objectForKey:sectionTitle];
    NSString *animal = [sectionAnimals objectAtIndex:indexPath.row];
    cell.textLabel.text = animal;
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    //NSLog(@"%ld", indexPath.section);
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //CGSize mySize = [tableView contentSize];
    //NSLog(@"My view's frame is: %@", NSStringFromCGRect(tableView.frame));
    //CGFloat height = self.view.frame.size.height/4;
    return 112;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UIViewController *viewController = nil;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    HoursViewController *hoursView = [storyboard  instantiateViewControllerWithIdentifier:@"Hours"];
    TransporationViewController *transportationView = [storyboard  instantiateViewControllerWithIdentifier:@"Transportation"];

    switch (indexPath.row) {
        case 0:
            [self.navigationController pushViewController:hoursView animated:YES];
            break;
        case 1:
            viewController = [storyboard instantiateViewControllerWithIdentifier:@"Menu"];
            break;
        case 2:
            [self.navigationController pushViewController:transportationView animated:YES];
            break;
        case 3:
            viewController = [storyboard instantiateViewControllerWithIdentifier:@"Emergency Info"];
            break;
        default:
            viewController = [storyboard instantiateViewControllerWithIdentifier:@"Hours"];
            break;
    }       
    
    // Deselect
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
