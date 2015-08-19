//
//  MenuViewController.m
//  Swat App
//
//  Created by Steve Jaoudi on 7/19/15.
//  Copyright (c) 2015 Steve Jaoudi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MenuViewController.h"
#import "AppDelegate.h"

#import "FirstViewController.h"

@interface MenuViewController () {
    
}

@end



@implementation MenuViewController

@synthesize loadedTitlesAndMenus, menus, titles;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"MenuViewController Loaded");
    
    CGFloat dummyViewHeight = 40;
    UIView *dummyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, dummyViewHeight)];
    self.tableView.tableHeaderView = dummyView;
    self.tableView.contentInset = UIEdgeInsetsMake(-dummyViewHeight, 0, 0, 0);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    FirstViewController *firstView = [[FirstViewController alloc] init];
    self.navigationItem.titleView = [firstView createNavbarTitle:@"Menus" :NO];
    
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    loadedTitlesAndMenus = appDelegate.menu;
    
    titles = [loadedTitlesAndMenus objectForKey:@"titles"];
    menus = [loadedTitlesAndMenus objectForKey:@"menus"];
    
}

- (NSDictionary *)menuViewLoad :(NSString *)dashString{

    NSString *menuBlock = [self getMenuInfo:dashString];
    //NSLog(@"%@", menuBlock);
    
    NSMutableArray *regexFinds = [self findMultipleRegex:@"((strong>Breakfast<|strong>Continental Breakfast<|strong>Brunch<|strong>Lunch<|strong>Dinner<)(.|\n)*?\\/div)" :menuBlock];
    
    NSMutableArray *mealTitles = [[NSMutableArray alloc] init];
    NSMutableArray *mealMenus = [[NSMutableArray alloc] init];
    
    for (int i=0; i<regexFinds.count; i++) {
        NSString *regexFind = regexFinds[i];
        NSString *mealTitle = [self findRegex:@"strong>(.+)<\\/strong>" :regexFind];
        [mealTitles addObject:mealTitle];
        
        NSString *mealMenu = [self findRegex:@"dining-menu\">((.|\n)*?)<\\/div" :regexFind];
        mealMenu = [mealMenu stringByReplacingOccurrencesOfString:@"<br />" withString:@""];
        mealMenu = [mealMenu stringByReplacingOccurrencesOfString:@"<br>" withString:@""];
        [mealMenus addObject:mealMenu];
    }
    
    //NSArray *titlesAndMenus = [[NSArray alloc] initWithObjects:mealTitles, mealMenus, nil];
    NSDictionary *titlesAndMenus = [[NSDictionary alloc] initWithObjectsAndKeys:mealTitles, @"titles", mealMenus, @"menus", nil];
    return titlesAndMenus;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 60)];
    /* Create custom view to display section header... */
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 6, tableView.frame.size.width, 30)];
    [label setFont:[UIFont fontWithName:@"Avenir" size:21]];
    label.textColor = [UIColor colorWithRed:185/255.0 green:22/255.0 blue:60/255.0 alpha:1.0];
    NSString *string = [titles objectAtIndex:section];
    
    [label setText:string];
    [view addSubview:label];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [titles count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = [menus objectAtIndex:indexPath.section];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.textColor = [UIColor colorWithRed:(51/255.f) green:(51/255.f) blue:(51/255.f) alpha:1.0f];
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize menuSize = [[menus objectAtIndex:indexPath.section] sizeWithFont:[UIFont fontWithName:@"Avenir" size:15]
                   constrainedToSize:CGSizeMake(self.view.bounds.size.width + 20, MAXFLOAT)  // - 40 For cell padding
                       lineBreakMode:NSLineBreakByWordWrapping];
    
    //NSLog(@"%f", menuSize.height);
    return menuSize.height;
    //return 130;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CGSize menuSize = [[menus objectAtIndex:indexPath.section] sizeWithFont:[UIFont fontWithName:@"Avenir" size:15]
                                                      constrainedToSize:CGSizeMake(self.view.bounds.size.width + 20, MAXFLOAT)  // - 40 For cell padding
                                                          lineBreakMode:NSLineBreakByWordWrapping];
    
    //NSLog(@"%f", menuSize.height);
    //return menuSize.height;
}


- (NSString *)getMenuInfo :(NSString *)content {
    
    NSString *menuInfoRegexString = @"id=\"dining\">((.|\n)*)id=\"entertainment";
    NSString *menuInfo = [self findRegex:menuInfoRegexString :content];
    
    return menuInfo;
}

- (NSString *)findRegex :(NSString *)regexString :(NSString *)content{
    NSError *error = NULL;
    NSRegularExpression *regex =
    [NSRegularExpression regularExpressionWithPattern:regexString
                                              options:0
                                                error:&error];
    
    NSTextCheckingResult *textCheckingResult = [regex firstMatchInString:content options:0 range:NSMakeRange(0, content.length)];
    
    NSRange matchRange = [textCheckingResult rangeAtIndex:1];
    
    NSString *result = [content substringWithRange:matchRange];
    
    return result;
}

- (NSMutableArray *)findMultipleRegex :(NSString *)regexString :(NSString *)content{
    NSError *error = NULL;
    
    NSRange searchedRange = NSMakeRange(0, [content length]);
    
    NSRegularExpression *regex =
    [NSRegularExpression regularExpressionWithPattern:regexString
                                              options:0
                                                error:&error];
    
    NSArray *matches = [regex matchesInString:content options:0 range: searchedRange];
    
    NSMutableArray *regexFinds = [[NSMutableArray alloc] init];
    
    for (NSTextCheckingResult* match in matches) {
        NSRange find = [match rangeAtIndex:1];
        [regexFinds addObject:[content substringWithRange:find]];
    }
    return regexFinds;
}


@end
