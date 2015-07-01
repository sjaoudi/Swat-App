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
    
    allDates = [[NSMutableArray alloc] init];
    eventsDictionary = [[NSMutableDictionary alloc] init];
    dateRangeToParse = [[NSArray alloc] init];
    
    // Refresh button (?)
    
    NSURL *feedURL = [NSURL URLWithString:@"http://calendar.swarthmore.edu/calendar/RSSSyndicator.aspx?category=&location=&type=N&starting=5/1/2015&ending=5/15/2015&binary=Y&keywords=&ics=Y"];
    feedParser = [[MWFeedParser alloc] initWithFeedURL:feedURL];
    feedParser.delegate = self;
    feedParser.feedParseType = ParseTypeFull; // Parse all items
    feedParser.connectionType = ConnectionTypeAsynchronously;
    [feedParser parse];
    
    
    NSString *dateString1 = @"01-May-15";
    NSString *dateString2 = @"15-May-15";
    
    dateRangeToParse = [self dateRangeFromStrings:dateString1 :dateString2];
    
    
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
    if (item) {
        [parsedItems addObject:item];
        NSMutableArray *itemDatesArray = [self createDateRange:item.content];
        
        //NSMutableArray *dateRangeToParse = [[NSMutableArray alloc] init];
        
        NSString *dateString1 = @"01-May-15";
        NSString *dateString2 = @"15-May-15";
        
        //dateRangeToParse = [self createDateRangeArray:date1 :date2];
        //NSLog(@"%@, %@", itemDatesArray, dateRangeToParse);
        
        //NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
        //NSLog(@"%@", dateRangeToParse);
        
        for (int i=0; i< itemDatesArray.count; i++) {
            BOOL isInRange = [self determineIfInRange:dateString1 :dateString2 :itemDatesArray[i]];
            if (isInRange) {
                //NSLog(@"%@", item.date);
                //[eventsDictionary setObject:item forKey:itemDatesArray[i]];
                //for (int j=0; j< dateRangeToParse.count; j++) {
                    //if [dateRangeToParse[j]
                    
            }
            
            
        }
        
        //NSLog(@"%@", eventsDictionary);
        //exit(0);
        
        
//        for (int i=0; i < datesArray.count; i++) {
//            //NSLog(@"%@", date1);
//            if (!(([datesArray[i] compare:date1] == NSOrderedAscending) ||
//                  ([datesArray[i] compare:date2] == NSOrderedDescending))) {
//                [allDates addObject:datesArray[i]];
//            }
//            else if ([datesArray[i] compare:date2] == NSOrderedSame) {
//                NSLog(@"worked");
//                [allDates addObject:datesArray[i]];
//            }
//        }
    }
    
    //NSLog(@"%@", allDates);
    
    
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView :(NSString *)content{
    //return 1;
    return dateRangeToParse.count;
}

// Number of rows in table view
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //NSString *sectionTitle = [dateRangeToParse objectAtIndex:section];
    //NSArray *dictKeys = [eventsDictionary objectForKey:sectionTitle];
    return itemsToDisplay.count;
    //return [dictKeys count];
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    //return [dateRangeToParse objectAtIndex:section];
//}

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
    
    // This is added for a Search Bar - otherwise it will crash due to
    //'UITableView dataSource must return a cell from tableView:cellForRowAtIndexPath:'
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    // Configure the cell.
    MWFeedItem *item = [itemsToDisplay objectAtIndex:indexPath.row];
    
//    NSMutableArray *dates = [self determineDateRange:item.content];
//
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"MM/d/yyyy"];
//    
//    [dateFormatter setLocale:[NSLocale currentLocale]];
//    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
//    NSDate *date1 = [dateFormatter dateFromString:dates[0]];
//    NSDate *date2 = [dateFormatter dateFromString:dates[1]];
//    
//    NSMutableArray *datesArray = [self createDateRangeArray:date1 :date2];
    //NSMutableArray *datesArray = [self createDateRange:item.content];

    //NSLog(@"%@", allDates);
    //NSLog(@"%@", eventsDictionary);
    //exit(0);
    
    
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
    
    
    //NSLog(@"%@", dates);
   
    //[self determineDateRange:detail.item.content];
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
    
    //NSLog(@"%@, %@", startDate, endDate);
    NSMutableArray *dateRangeArray = [[NSMutableArray alloc] init];
    
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier: NSCalendarIdentifierGregorian];
    NSDateComponents *days = [[NSDateComponents alloc] init];
    
    NSInteger dayCount = 0;
    while ( TRUE ) {
        NSDate *date = [gregorianCalendar dateByAddingComponents: days toDate: startDate options: 0];
        [days setDay: ++dayCount];
        if ( [date compare: endDate] == NSOrderedDescending )
            break;
        // Add date to the array
        [dateRangeArray addObject:date];
    }
    
    
    return dateRangeArray;
}

- (NSMutableArray *)dateRangeFromStrings :(NSString *)dateString1 :(NSString *)dateString2 {
    
    //NSMutableArray *dates = [self determineDateRange:content];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MMMM/yy"];
    
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    
    
    NSDate *date1 = [dateFormatter dateFromString:dateString1];
    NSDate *date2 = [dateFormatter dateFromString:dateString2];
    //NSLog(@"%@, %@", dates[0], dates[1]);
    //NSLog(@"%@, %@", date1, date2);
    
    NSMutableArray *datesArray = [self createDateRangeArray:date1 :date2];
    //NSLog(@"%@", datesArray);
    return datesArray;
    
}

- (NSMutableArray *)determineDateRange :(NSString *)content {
    
    NSMutableArray *startEndDates = [[NSMutableArray alloc] init];
    
    NSError *error = NULL;
    NSString *startDateRegexString = @"Start Date:<\\/b>&nbsp;<\\/td><td style=\"padding-bottom:1px;\">(\\d+\\/\\d+\\/\\d+)<\\/td><td>";
    NSRegularExpression *startDateRegex =
    [NSRegularExpression regularExpressionWithPattern:startDateRegexString
                                              options:0
                                                error:&error];
    NSTextCheckingResult *textCheckingResultStart = [startDateRegex firstMatchInString:content options:0 range:NSMakeRange(0, content.length)];
    if (!textCheckingResultStart) return NULL;
    NSRange matchRangeStart = [textCheckingResultStart rangeAtIndex:1];
    NSString *startDate = [content substringWithRange:matchRangeStart];
    [startEndDates addObject:startDate];
    
    NSString *endDateRegexString = @"End Date:<\\/b>&nbsp;<\\/td><td>(\\d+\\/\\d+\\/\\d+)<\\/td><td>";
    NSRegularExpression *endDateRegex =
    [NSRegularExpression regularExpressionWithPattern:endDateRegexString
                                              options:0
                                                error:&error];
    NSTextCheckingResult *textCheckingResultEnd = [endDateRegex firstMatchInString:content options:0 range:NSMakeRange(0, content.length)];
    if (!textCheckingResultEnd) return NULL;
    NSRange matchRangeEnd = [textCheckingResultEnd rangeAtIndex:1];
    NSString *endDate = [content substringWithRange:matchRangeEnd];
    
    [startEndDates addObject:endDate];
    return startEndDates;
}

- (NSMutableArray *)createDateRange :(NSString *)content {
    NSMutableArray *dates = [self determineDateRange:content];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/d/yyyy"];
    
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    NSDate *date1 = [dateFormatter dateFromString:dates[0]];
    NSDate *date2 = [dateFormatter dateFromString:dates[1]];
    
    NSMutableArray *datesArray = [self createDateRangeArray:date1 :date2];
    return datesArray;

}

- (BOOL)determineIfInRange :(NSString *)dateString1 :(NSString *)dateString2 :(NSDate *)date {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [dateFormatter setDateFormat:@"dd-MMMM-yy"];
    
    NSDate *date1 = [dateFormatter dateFromString:dateString1];
    NSDate *date2 = [dateFormatter dateFromString:dateString2];
    
    if (!(([date compare:date1] == NSOrderedAscending) || ([date compare:date2] == NSOrderedDescending))) {
        return YES;
    }
    else if ([date compare:date2] == NSOrderedSame) {
        return YES;
    }
    else {
        return NO;
    }
}



@end


