//
//  FirstViewController.m
//  Swat App
//
//  Created by Steve Jaoudi on 6/14/15.
//  Copyright (c) 2015 Steve Jaoudi. All rights reserved.
//
#import "AppDelegate.h"

#import "FirstViewController.h"

#import "HoursViewController.h"
#import "HoursTableViewController.h"

#import "TransportationViewController.h"
#import "MenuViewController.h"
#import "EmergencyViewController.h"

@interface FirstViewController () {
    NSDictionary *menuItem;
    NSArray *menuTitles;
    NSArray *menuImages;
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
    menuImages = @[@"Clock-50.png", @"Restaurant-50.png", @"Train-50.png", @"High-Importance-50.png"];
    
    menuTitles = [[menuItem allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.scrollEnabled = NO;
    
    self.navigationItem.titleView = [self createNavbarTitle:@"Swat Info" :YES];
    
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UITabBar appearance] setTintColor:[UIColor redColor]];
    
    //AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    //SEL compareByDeliveryTimeSelector = sel_registerName("refreshWasPressed:");
    
    UIBarButtonItem *button = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshWasPressed:)];
    self.navigationItem.rightBarButtonItem = button;
}

- (void)refreshWasPressed {
    NSLog(@"refresh pressed");
}

- (void)viewDidAppear:(BOOL)animated {
    //[self.navigationController setNavigationBarHidden:NO animated:NO];
    [self.tableView reloadData];
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
    NSArray *sectionTitles = [menuItem objectForKey:sectionTitle];
    NSString *sectionText = [sectionTitles objectAtIndex:indexPath.row];
    cell.textLabel.text = sectionText;
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cell.textLabel.font = [UIFont fontWithName:@"Avenir" size:20];
    cell.textLabel.textColor = [UIColor colorWithRed:(51/255.f) green:(51/255.f) blue:(51/255.f) alpha:1.0f];
    //NSMutableString *imagePath = [[NSMutableString alloc] initWithString:@"/icons/"];
    //[imagePath appendString:[menuImages objectAtIndex:indexPath.row]];
    NSString *imagePath = [menuImages objectAtIndex:indexPath.row];
    
    NSLog(@"%@", imagePath);
    cell.imageView.image = [UIImage imageNamed:imagePath];
    
    //NSLog(@"%ld", indexPath.section);
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //CGSize mySize = [tableView contentSize];
    //NSLog(@"My view's frame is: %@", NSStringFromCGRect(tableView.frame));
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenHeight = screenRect.size.height - 64 - 49;
    CGFloat screenWidth = screenRect.size.height - 30 - 49;
    //CGFloat height = self.view.frame.size.height;
    //NSLog(@"%f", screenHeight);
    if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
        return screenWidth/4;
    }
    return screenHeight/4;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //UIViewController *viewController = nil;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    //HoursViewController *hoursView = [storyboard  instantiateViewControllerWithIdentifier:@"Hours"];
    HoursTableViewController *hoursTableView = [storyboard instantiateViewControllerWithIdentifier:@"HoursTable"];
    
    
    
    TransporationViewController *transportationView = [storyboard  instantiateViewControllerWithIdentifier:@"Transportation"];
    MenuViewController *menuView = [storyboard instantiateViewControllerWithIdentifier:@"Menu"];
    EmergencyViewController *emergencyView = [storyboard instantiateViewControllerWithIdentifier:@"Emergency"];
    

    switch (indexPath.row) {
        case 0:
            //[self.navigationController pushViewController:hoursView animated:YES];
            [self.navigationController pushViewController:hoursTableView animated:YES];
            break;
        case 1:
            [self.navigationController pushViewController:menuView animated:YES];
            break;
        case 2:
            [self.navigationController pushViewController:transportationView animated:YES];
            break;
        case 3:
            [self.navigationController pushViewController:emergencyView animated:YES];
            break;
        default:
            [self.navigationController pushViewController:emergencyView animated:YES];
            break;
    }       
    
    // Deselect
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UIView *)createNavbarTitle :(NSString *)title :(BOOL)mainPage {
    
    NSInteger offset = 0;
    if (!mainPage) {
        offset = 12;
    }

    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0,0,200,50)];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,0,200,50)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = title;
    titleLabel.font = [UIFont fontWithName:@"Avenir" size:22];
    titleLabel.textColor=[UIColor whiteColor];
    [titleView addSubview:titleLabel];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];

    return titleView;
}


@end
