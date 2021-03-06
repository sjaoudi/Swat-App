//
//  HoursTableViewController.m
//  Swat App
//
//  Created by Steve Jaoudi on 8/11/15.
//  Copyright (c) 2015 Steve Jaoudi. All rights reserved.
//

#import "HoursTableViewController.h"
#import "FirstViewController.h"
#import "AppDelegate.h"

@implementation HoursTableViewController

@synthesize loadedHoursInfo, hoursDict, hoursDictSections;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGFloat dummyViewHeight = 40;
    UIView *dummyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, dummyViewHeight)];
    self.tableView.tableHeaderView = dummyView;
    self.tableView.contentInset = UIEdgeInsetsMake(-dummyViewHeight, 0, 0, 0);
    
    loadedHoursInfo = [NSArray array];
    
    //NSLog(@"HoursTableViewController Loaded");
    
    FirstViewController *firstView = [[FirstViewController alloc] init];
    self.navigationItem.titleView = [firstView createNavbarTitle:@"Hours" :NO];
    
    
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    loadedHoursInfo = appDelegate.hours;
    NSArray *places = @[@"Sharples", @"Essie Mae's", @"Kohlberg", @"Science Center", @"Paces Cafe", @"McCabe", @"Underhill", @"Cornell", @"Matchbox", @"Lamb-Miller Field House", @"Mullan Tennis Center", @"Help Desk Walk-In Hours", @"Media Center", @"Women's Resource Center", @"Post Office", @"Bookstore", @"Credit Union", @"Athletic Facilities"];
    
    NSDictionary *hoursSectionDict = [[NSDictionary alloc] initWithObjects:loadedHoursInfo forKeys:places];
    
    NSArray *foodDict = @[@[@"Sharples: ", [hoursSectionDict valueForKey:@"Sharples"]],
                          @[@"Essie Mae's: ", [hoursSectionDict valueForKey:@"Essie Mae's"]],
                          @[@"Kohlberg: ", [hoursSectionDict valueForKey:@"Kohlberg"]],
                          @[@"Science Center: ", [hoursSectionDict valueForKey:@"Science Center"]],
                          @[@"Paces Cafe: ", [hoursSectionDict valueForKey:@"Paces Cafe"]]
                          ];
    
    NSArray *libDict = @[@[@"McCabe: ", [hoursSectionDict valueForKey:@"McCabe"]],
                         @[@"Underhill: ", [hoursSectionDict valueForKey:@"Underhill"]],
                         @[@"Cornell: ", [hoursSectionDict valueForKey:@"Cornell"]]
                         ];
    
    NSArray *athleticDict = @[@[@"Matchbox: ", [hoursSectionDict valueForKey:@"Matchbox"]],
                              @[@"Lamb-Miller Field House: ", [hoursSectionDict valueForKey:@"Lamb-Miller Field House"]],
                              @[@"Mullan Tennis Center: ", [hoursSectionDict valueForKey:@"Mullan Tennis Center"]]
                              ];
    
    NSArray *itsDict = @[@[@"Help Desk: ", [hoursSectionDict valueForKey:@"Help Desk Walk-In Hours"]],
                         @[@"Media Center: ", [hoursSectionDict valueForKey:@"Media Center"]],
                         ];
    
    NSArray *moreDict = @[@[@"Women's Resource Center: ", [hoursSectionDict valueForKey:@"Women's Resource Center"]],
                          @[@"Post Office: ", [hoursSectionDict valueForKey:@"Post Office"]],
                          @[@"Bookstore: ", [hoursSectionDict valueForKey:@"Bookstore"]],
                          @[@"Credit Union: ", [hoursSectionDict valueForKey:@"Credit Union"]],
                          ];
    
    hoursDict = [[NSDictionary alloc] initWithObjectsAndKeys:foodDict, @"0",
                                                             libDict, @"1",
                                                             athleticDict, @"2",
                                                             itsDict, @"3",
                                                             moreDict, @"4",
                                                             nil];

    hoursDictSections = @[@"Food and Coffee", @"Libraries", @"Athletic Facilities", @"ITS", @"More Services"];
    
}

- (NSArray *)HoursViewLoad :(NSString *)dashString{
    
    NSArray *places = @[@"Sharples", @"Essie Mae's", @"Kohlberg", @"Science Center", @"Paces Cafe", @"McCabe", @"Underhill", @"Cornell", @"Matchbox", @"Lamb-Miller Field House", @"Mullan Tennis Center", @"Help Desk Walk-In Hours", @"Media Center", @"Women's Resource Center", @"Post Office", @"Bookstore", @"Credit Union", @"Athletic Facilities"];
    
    NSString *hoursInfo = [self getHoursInfo:dashString];
    NSArray *hoursInfoArray = [self getHours:hoursInfo :places];
    
    return hoursInfoArray;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 60)];
    /* Create custom view to display section header... */
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 6, tableView.frame.size.width, 30)];
    [label setFont:[UIFont fontWithName:@"Avenir" size:21]];
    label.textColor = [UIColor colorWithRed:185/255.0 green:22/255.0 blue:60/255.0 alpha:1.0];
    NSString *string = [hoursDictSections objectAtIndex:section];
    
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
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Hard-coding this is actually simpler
    switch (section) {
        case 0:
            return 5;
            break;
        case 1:
            return 3;
            break;
        case 2:
            return 3;
            break;
        case 3:
            return 2;
            break;
        case 4:
            return 4;
            break;
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    
    NSString *sectionString = [NSString stringWithFormat: @"%ld", (long)indexPath.section];
    
    NSString *cellText = [[hoursDict objectForKey:sectionString] objectAtIndex:indexPath.row][0];
    
    cell.textLabel.text = cellText;
    //NSLog(@"%@", cellText);

    
    NSString *hours = [[hoursDict objectForKey:sectionString] objectAtIndex:indexPath.row][1];
    hours = [hours stringByReplacingOccurrencesOfString:@"," withString:@"\n"];
    hours = [hours stringByReplacingOccurrencesOfString:@"midnight" withString:@"12:00am"];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //if ([cellText isEqualToString:@"Women's Resource Center:"]) {
    //    cell.detailTextLabel.textAlignment = NSTextAlignmentLeft;
    //    cell.detailTextLabel.font = [UIFont fontWithName:@"Avenir" size:18];
    //
    //}
    cell.detailTextLabel.text = hours;
    cell.detailTextLabel.numberOfLines = 0;
    
    cell.textLabel.textColor = [UIColor colorWithRed:(51/255.f) green:(51/255.f) blue:(51/255.f) alpha:1.0f];
    cell.detailTextLabel.textColor = [UIColor colorWithRed:(51/255.f) green:(51/255.f) blue:(51/255.f) alpha:1.0f];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *sectionString = [NSString stringWithFormat: @"%ld", (long)indexPath.section];
    NSString *time = [[hoursDict objectForKey:sectionString] objectAtIndex:indexPath.row][1];
    
    NSUInteger commas = [[time componentsSeparatedByString:@","] count] - 1;
    
    return (commas+1)*25;
}



- (NSString *)getHoursInfo :(NSString *)content {
    
    NSString *hoursInfoRegexString = @">Hours<\\/h2>((.|\n)*)transportation_mod";
    NSString *hoursInfo = [self findRegex:hoursInfoRegexString :content];
    
    return hoursInfo;
}

- (NSArray *)getHours :(NSString *)hoursInfo :(NSArray *)places{
    
    NSMutableArray *hoursArray = [[NSMutableArray alloc] init];
    //NSMutableArray *linksArray = [[NSMutableArray alloc] init];
    
    for (int i=0; i<places.count; i++) {
        
        NSMutableString *placeRegexMutableString = [[NSMutableString alloc] init];
        if ([places[i] isEqualToString:@"Paces Cafe"]) {
            ////NSLog(@"PACES");
            //[placeRegexMutableString appendString:@"<strong>:\\W?<\\/strong>(.+)<"];
            [placeRegexMutableString appendString:@"<strong>:\\W?<\\/strong>(?:<ul>)?(?:<li>)?(.*?)<"];
            [placeRegexMutableString insertString:places[i] atIndex:8];
            
            NSString *placeRegexString = [NSString stringWithString:placeRegexMutableString];
            NSString *placeHours = [self findRegex:placeRegexString :hoursInfo];
            [hoursArray addObject:placeHours];
            
        }
        else {
            [placeRegexMutableString appendString:@"<li><strong>:(.+)<\\/a><\\/li>"];
            [placeRegexMutableString insertString:places[i] atIndex:12];
            NSString *placeRegexString = [NSString stringWithString:placeRegexMutableString];
            NSString *placeToParse = [self findRegex:placeRegexString :hoursInfo];
            
            NSString *hoursRegexString = @"<\\/strong>\\s?(.+)\\s?<a";
            NSString *placeHours = [self findRegex:hoursRegexString :placeToParse];
            //NSString *placeHours = @"12:30pm-12:30pm"; // for testing width
            [hoursArray addObject:placeHours];
            
        }
        
        

    }

    return hoursArray;
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

@end
