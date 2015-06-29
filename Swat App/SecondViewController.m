//
//  SecondViewController.m
//  Swat App
//
//  Created by Steve Jaoudi on 6/14/15.
//  Copyright (c) 2015 Steve Jaoudi. All rights reserved.
//

#import "SecondViewController.h"
#import "MWFeedParser.h"
#import "MWFeedParser.h"
#import "DetailTableViewController.h"
#import "NSString+HTML.h"


//@interface SecondViewController ()

//@end

@implementation SecondViewController

@synthesize itemsToDisplay;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // Setup
    self.title = @"Loading...";
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    parsedItems = [[NSMutableArray alloc] init];
    self.itemsToDisplay = [NSArray array];
    
    // Refresh button (?)
    
    NSURL *feedURL = [NSURL URLWithString:@"http://calendar.swarthmore.edu/calendar/RSSSyndicator.aspx?category=&location=&type=N&starting=5/1/2015&ending=5/15/2015&binary=Y&keywords=&ics=Y"];
    feedParser = [[MWFeedParser alloc] initWithFeedURL:feedURL];
    feedParser.delegate = self;
    feedParser.feedParseType = ParseTypeFull; // Parse all items
    feedParser.connectionType = ConnectionTypeAsynchronously;
    [feedParser parse];
    
    //self.tableView.contentInset = UIEdgeInsetsMake(44,0,0,0);
    
    //self.tableView.frame = CGRectMake(0,40,200,480);
    //[self.tableView reloadData];
    
}

-(void)updateTableWithParsedItems {
    self.itemsToDisplay = [parsedItems sortedArrayUsingDescriptors:
                           [NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES]]];
    self.tableView.userInteractionEnabled = YES;
    self.tableView.alpha = 1;
    [self.tableView reloadData];
}

- (void)feedParserDidStart:(MWFeedParser *)parser {
    NSLog(@"Started Parsing: %@", parser.url);
}

- (void)feedParser:(MWFeedParser *)parser didParseFeedInfo:(MWFeedInfo *)info {
    NSLog(@"Parsed Feed Info: “%@”", info.title);
    self.title = info.title;
    //self.title = @"Events Feed";
}

- (void)feedParser:(MWFeedParser *)parser didParseFeedItem:(MWFeedItem *)item {
    //NSLog(@"Parsed Feed Item: “%@”", item.title);
    if (item) [parsedItems addObject:item];
}

- (void)feedParserDidFinish:(MWFeedParser *)parser {
    NSLog(@"Finished Parsing%@", (parser.stopped ? @" (Stopped)" : @""));
    [self updateTableWithParsedItems];
}

- (void)feedParser:(MWFeedParser *)parser didFailWithError:(NSError *)error {
    NSLog(@"Finished Parsing With Error: %@", error);
    if (parsedItems.count == 0) {
        self.title = @"Failed"; // Show failed message in title
    } else {
        // Failed but some items parsed, so show and inform of error
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Parsing Incomplete"
                                                        message:@"There was an error during the parsing of this feed. Not all of the feed items could parsed."
                                                       delegate:nil
                                              cancelButtonTitle:@"Dismiss"
                                              otherButtonTitles:nil];
        [alert show];
    }
    [self updateTableWithParsedItems];
}

// Number of sections in table view
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// Number of rows in table view
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return itemsToDisplay.count;
}

// Appearance of table view cells
//- (UITableViewCell *)tableView:(UITableView *)tableView cellforRowAtIndexPath:(NSIndexPath *)indexPath {
//    static NSString *CellIdentifier = @"Cell";
//    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    NSLog(@"the cell is %@", cell);
//    
//    if (cell == nil) {
//        // Try other styles
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    }
//    
//    // Cell configuration
//    
//    MWFeedItem *item = [itemsToDisplay objectAtIndex:indexPath.row];
//    if (item) {
//        
//        // Process
//        //NSString *itemTitle = item.title ? [item.title stringByConvertingHTMLtoPlainText] : @"[No Title]";
//        //NSString *itemSummary = item.summary ? [item.summary stringByConvertingHTMLToPlainText] : @"[No Summary]";
//        cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
//        //cell.textLabel.text = itemTitle;
//        NSMutableString *subtitle = [NSMutableString string];
//        if (item.date) [subtitle appendFormat:@"%@: ", [formatter stringFromDate:item.date]];
//        //[subtitle appendString:itemSummary];
//        cell.detailTextLabel.text = subtitle;
//    }
//    return cell;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //NSLog(@"the cell is %@", cell);
    
    // This is added for a Search Bar - otherwise it will crash due to
    //'UITableView dataSource must return a cell from tableView:cellForRowAtIndexPath:'
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    // Configure the cell.
    MWFeedItem *item = [itemsToDisplay objectAtIndex:indexPath.row];
    
    
    
    if (item) {
        
        // Process
        
        //NSString *itemTitle = item.title ? [item.title stringByConvertingHTMLToPlainText] : @"[No Title]";
        NSString *itemTitle = item.title ? [self removeDateTitle:item.title] : @"[No Title]";
        
        NSString *itemSummary = item.summary ? [item.summary stringByConvertingHTMLToPlainText] : @"[No Summary]";
        
        cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
        cell.textLabel.text = itemTitle;
        //cell.textLabel.text = testString;
        NSMutableString *subtitle = [NSMutableString string];
        
        if (item.date) {
            
            [self determineDateRange:item.content];
            
            NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
            [timeFormatter setDateFormat:@"hh:mm a"];
            
            DetailTableViewController *c = [[DetailTableViewController alloc] init];
            NSString *allDay = [c findAllDay:item.date :item.content :timeFormatter];
            if (!allDay) {
                NSString *timeRange = [c determineTimeRange:timeFormatter :item.content :item.date];
                if (!timeRange) {
                    NSString *singleTime = [c determineTimeRange:timeFormatter :item.content :item.date];
                    [subtitle appendFormat:singleTime, [timeFormatter stringFromDate:item.date]];
                }
                else {
                    [subtitle appendFormat:timeRange, [timeFormatter stringFromDate:item.date]];
                }
            }
            else {
                [subtitle appendString:@"All Day"];
            }
        }
        [subtitle appendString:itemSummary];
        cell.detailTextLabel.text = subtitle;
    }
    return cell;
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    //Show detail
    DetailTableViewController *detail = [[DetailTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    detail.item = (MWFeedItem *)[itemsToDisplay objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:detail animated:YES];
    
    //NSLog(@"row pressed");
    
    // Deselect
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)removeDateTitle :(NSString *)title {
    NSError *error = NULL;
    NSString *titleDateRegexString = @"(.+) \\(";
    NSRegularExpression *titleDateRegex =
    [NSRegularExpression regularExpressionWithPattern:titleDateRegexString
                                              options:0
                                                error:&error];
    NSTextCheckingResult *textCheckingResult = [titleDateRegex firstMatchInString:title options:0 range:NSMakeRange(0, title.length)];
    NSRange matchRange = [textCheckingResult rangeAtIndex:1];
    NSString *datelessTitle = [title substringWithRange:matchRange];
    return datelessTitle;
    
}

- (NSMutableArray *)createDateRangeArray :(NSDate *)startDate :(NSDate *)endDate{
    
    NSMutableArray *dateRangeArray;
    
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier: NSCalendarIdentifierGregorian];
    NSDateComponents *days = [[NSDateComponents alloc] init];
    
    NSInteger dayCount = 0;
    while ( TRUE ) {
        [days setDay: ++dayCount];
        NSDate *date = [gregorianCalendar dateByAddingComponents: days toDate: startDate options: 0];
        if ( [date compare: endDate] == NSOrderedDescending )
            break;
        // Do something with date like add it to an array, etc.
        [dateRangeArray addObject:date];
    }
    return dateRangeArray;
}

- (void)determineDateRange :(NSString *)content {
    NSError *error = NULL;
    NSString *startDateRegexString = @"";
    NSRegularExpression *titleDateRegex =
    [NSRegularExpression regularExpressionWithPattern:startDateRegexString
                                              options:0
                                                error:&error];
    NSTextCheckingResult *textCheckingResult = [titleDateRegex firstMatchInString:content options:0 range:NSMakeRange(0, content.length)];
    NSRange matchRange = [textCheckingResult rangeAtIndex:1];
    NSString *startDate = [content substringWithRange:matchRange];
   
    NSLog(@"%@", startDate);
    
}

@end
