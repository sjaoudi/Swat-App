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
@synthesize eventSectionsTest;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // Setup
    //self.title = @"Loading...";
    [self.navigationItem setTitle:@"Loading..."];
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    parsedItems = [[NSMutableArray alloc] init];
    self.itemsToDisplay = [NSArray array];
    
    allDates = [[NSMutableArray alloc] init];
    eventsDictionary = [[NSMutableDictionary alloc] init];
    eventSectionTitles = [[NSArray alloc] init];
    eventSectionTitlesStrings = [[NSArray alloc] init];
    dateRangeToParse = [[NSArray alloc] init];
    dateArrays = [[NSMutableArray alloc] init];
    
    eventSectionsTest = [[NSArray alloc] init];
    
    UINavigationBar *navbar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    navbar.translucent = NO;
    //[self.view addSubview:navbar];
    
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"M/dd/yyyy"];
    todayString = [dateFormat stringFromDate:today];
    NSDate *twoWeek = [[NSCalendar currentCalendar] dateByAddingUnit:NSCalendarUnitDay value:28 toDate:today options:0];
    twoWeekString = [dateFormat stringFromDate:twoWeek];
    
    NSString *feedURLNSString = @"http://calendar.swarthmore.edu/calendar/RSSSyndicator.aspx?category=&location=&type=N&starting=&ending=&binary=Y&keywords=&ics=Y";
    NSMutableString *feedURLString = [NSMutableString stringWithString:feedURLNSString];
    [feedURLString insertString:todayString atIndex:95];
    [feedURLString insertString:twoWeekString atIndex:112];
    
    NSURL *feedURL = [NSURL URLWithString:feedURLString];
    feedParser = [[MWFeedParser alloc] initWithFeedURL:feedURL];
    feedParser.delegate = self;
    feedParser.feedParseType = ParseTypeFull; // Parse all items
    feedParser.connectionType = ConnectionTypeAsynchronously;
    [feedParser parse];
    
    //NSLog(@"%@", eventsDictionary);
    
    dateRangeToParse = [self dateRangeFromStrings:todayString :twoWeekString];
    
    //create array of empty arrays, each corresponding to a date
    dateArrays = [self createEmptyDateArrays];
    

    [self.tableView reloadData];
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];

    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:205/255.0 green:42/255.0 blue:80/255.0 alpha:1.0]];
    [self.navigationController.navigationBar setTranslucent:YES];
    
}

-(void)updateTableWithParsedItems :(NSArray *)events{
    self.itemsToDisplay = [parsedItems sortedArrayUsingDescriptors:
                           [NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES]]];
    //self.itemsToDisplay = parsedItems;
    
    self.tableView.userInteractionEnabled = YES;
    self.tableView.alpha = 1;
    [self.tableView reloadData];
}

- (void)feedParserDidStart:(MWFeedParser *)parser {
    //NSLog(@"Started Parsing: %@", parser.url);
}

- (void)feedParser:(MWFeedParser *)parser didParseFeedInfo:(MWFeedInfo *)info {
    //NSLog(@"Parsed Feed Info: “%@”", info.title);
    //self.title = info.title;
    self.title = @"Events";
}

- (void)feedParser:(MWFeedParser *)parser didParseFeedItem:(MWFeedItem *)item {
    //NSLog(@"Parsed Feed Item: “%@”", item.title);
    if (item) {
        //NSLog(@"%@", parsedItems);
        //[parsedItems addObject:item];
        NSMutableArray *itemDatesArray = [self createDateRange:item.content];
        
        //NSString *dateString1 = @"06-July-15";
        //NSString *dateString2 = @"20-July-15";
        
        for (int i=0; i< itemDatesArray.count; i++) {
            BOOL isInRange = [self determineIfInRange:todayString :twoWeekString :itemDatesArray[i]];
            //item.date = itemDatesArray[i];
            if (isInRange) {
                
                for (int j=0; j< dateRangeToParse.count; j++) {
                    if ([dateRangeToParse[j] isEqualToDate:itemDatesArray[i]]) {
                        //append to corresponding date array
                        //item.date = itemDatesArray[i];
                        //NSLog(@"%@", item);
                        //item.date = dateRangeToParse[j];
                        
                        //somehow fix the date of each object
                        [dateArrays[j] addObject:item];
                    }
                }
            }
        }
    }
}

- (void)feedParserDidFinish:(MWFeedParser *)parser {
    //NSLog(@"Finished Parsing%@", (parser.stopped ? @" (Stopped)" : @""));
    
    // Populate eventsDictionary with events
    for (int i = 0; i < dateRangeToParse.count; i++) {
        NSArray *dateArray = dateArrays[i];
        //NSLog(@"%d", dateArray.count);
        if (dateArray.count) {
            //NSLog(@"%lu", dateArray.count);
            [eventsDictionary setObject:dateArrays[i] forKey:dateRangeToParse[i]];
            //[self updateTableWithParsedItems:dateArrays[i]];
        }
    }
    
    NSMutableArray *emptyDates = [NSMutableArray array];
    
    [dateArrays removeObject: @""];
    for (int i = 0; i <dateArrays.count; i++) {
        NSArray *dateArray = dateArrays[i];
        if (!dateArray.count) {
            [emptyDates addObject:dateArrays[i]];
        }
    }
    
    [dateArrays removeObjectsInArray:emptyDates];
    
    //eventSectionTitles = [[eventsDictionary allKeys] sortedArrayUsingSelector:@selector(compare:)];
    eventSectionTitles = [eventsDictionary allKeys];
    NSSortDescriptor *descriptor=[[NSSortDescriptor alloc] initWithKey:@"self" ascending:YES];
    NSArray *descriptors=[NSArray arrayWithObject: descriptor];
    NSArray *reverseOrder=[eventSectionTitles sortedArrayUsingDescriptors:descriptors];
    eventSectionTitles = reverseOrder;
    
    eventSectionTitlesStrings = [self createStringDateRange:eventSectionTitles];
    
    //NSLog(@"%@", eventsDictionary);
    [self.tableView reloadData];
    //[self updateTableWithParsedItems:parsedItems];
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

    //[self updateTableWithParsedItems];
}

// Number of sections in table view
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //return 10;
    return eventSectionTitles.count;
}

// Number of rows in table view
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //NSLog(@"%d", section);
    
    NSString *sectionTitle = [eventSectionTitles objectAtIndex:section];

    NSArray *sectionEvents = [eventsDictionary objectForKey:sectionTitle];
    //return itemsToDisplay.count;
    //NSLog(@"%l", sectionEvents.count);
    return [sectionEvents count];
    //return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MWFeedItem *item = [[dateArrays objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    CGSize titleSize = [item.title sizeWithFont:[UIFont fontWithName:@"Avenir" size:16]
                   constrainedToSize:CGSizeMake(self.view.bounds.size.width - 40, MAXFLOAT)  // - 40 For cell padding
                       lineBreakMode:NSLineBreakByWordWrapping];

    CGFloat titleHeight = titleSize.height + 20; // Subtitle of cell is 20px high
    if (titleHeight > 75) {
        return titleHeight;
    }
    else {
        return 75;
    }
}

//- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
//
//    return [self createStringDateRange:dateRangeToParse];
//}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    
//    return [[self createStringDateRange:dateRangeToParse] objectAtIndex:section];
//    //return @"hi";
//}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    
//    UILabel *headerLabel = [[UILabel alloc] init];
//    headerLabel.frame = CGRectMake(8, 8, 320, 20);
//    [headerLabel setFont:[UIFont fontWithName:@"Avenir" size:18]];
//    [headerLabel setBackgroundColor:[UIColor colorWithRed:(239/255.f) green:(239/255.f) blue:(241/255.f) alpha:1.0f]];
//    headerLabel.text = [self tableView:tableView titleForHeaderInSection:section];
//    
//    UIView *headerView = [[UIView alloc] init];
//    [headerView addSubview:headerLabel];
//    
//    return headerView;
//}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 18)];
    /* Create custom view to display section header... */
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 3, tableView.frame.size.width, 18)];
    [label setFont:[UIFont fontWithName:@"Avenir" size:15]];
    NSArray *dateRange = [self createStringDateRange:eventSectionTitles];
    NSString *string = [dateRange objectAtIndex:section];
    /* Section header is in 0th index... */
    
    [label setText:string];
    [view addSubview:label];
    [view setBackgroundColor:[UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1.0]]; //your background color...
    return view;
}

-(NSMutableArray *)createStringDateRange :(NSArray *)dateRange {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMMM d"];
    
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    
    NSMutableArray *dateRangeToParseStrings = [[NSMutableArray alloc] init];
    for (int i = 0; i< dateRange.count; i++) {
        NSString *dateString = [dateFormatter stringFromDate:dateRange[i]];
        [dateRangeToParseStrings addObject:dateString];
    }
    
    return dateRangeToParseStrings;
}

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
    //MWFeedItem *item = [dateArrays objectAtIndex:indexPath.row];
    //NSLog(@"%u", [[dateArrays objectAtIndex:indexPath.section] count]);
    //NSLog(@"%ld, %ld", indexPath.section, indexPath.row);
    MWFeedItem *item = [[dateArrays objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    if (item) {
        
        // Process
        
        NSString *itemTitle = item.title ? [self removeDateTitle:item.title] : @"[No Title]";
        NSString *itemSummary = item.summary ? [item.summary stringByConvertingHTMLToPlainText] : @"[No Summary]";
        
        //cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        cell.textLabel.text = itemTitle;
        
        NSMutableString *subtitle = [NSMutableString string];
        
        if (item.date) {
            
            NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
            [timeFormatter setDateFormat:@"h:mm a"];
            
            DetailTableViewController *c = [[DetailTableViewController alloc] init];
            NSString *allDay = [c findAllDay:item.date :item.content :timeFormatter];
            if (!allDay) {
                NSString *timeRange = [c determineTimeRange:timeFormatter :item.content :item.date];
                
                if (!timeRange) {
                    //NSString *singleTime = [c determineTimeRange:timeFormatter :item.content :item.date];
                    [subtitle appendFormat:timeRange, [timeFormatter stringFromDate:item.date]];
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
        NSArray *dateRange = [self createStringDateRange:eventSectionTitles];
        NSString *string = [dateRange objectAtIndex:indexPath.section];
//        NSLog(@"%@", string);
//        eventDate = string;
        
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //Show detail
    DetailTableViewController *detail = [[DetailTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    
    detail.item = (MWFeedItem *)[[dateArrays objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
   
    [self.navigationController pushViewController:detail animated:YES];
    
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
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy"];
    
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    
    
    NSDate *date1 = [dateFormatter dateFromString:dateString1];
    NSDate *date2 = [dateFormatter dateFromString:dateString2];
    
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
    
    //if (!textCheckingResultEnd) return NULL;
    NSString *endDate;
    if (textCheckingResultEnd) {
        NSRange matchRangeEnd = [textCheckingResultEnd rangeAtIndex:1];
        endDate = [content substringWithRange:matchRangeEnd];
    }
    else {
        endDate = startDate;
    }
    
    
    //NSRange matchRangeEnd = [textCheckingResultEnd rangeAtIndex:1];
    //NSString *endDate = [content substringWithRange:matchRangeEnd];
    
    [startEndDates addObject:endDate];
    
    //NSLog(@"%@", startEndDates);
    return startEndDates;
}

- (NSMutableArray *)createDateRange :(NSString *)content {
    NSMutableArray *dates = [self determineDateRange:content];
    //NSLog(@"%@", dates);
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/d/yyyy"];
    
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    NSDate *date1 = [dateFormatter dateFromString:dates[0]];
    NSDate *date2 = [dateFormatter dateFromString:dates[1]];
    
    //NSLog(@"%@, %@", date1, date2);
    
    NSMutableArray *datesArray = [self createDateRangeArray:date1 :date2];
    
    return datesArray;

}

- (BOOL)determineIfInRange :(NSString *)dateString1 :(NSString *)dateString2 :(NSDate *)date {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    //[dateFormatter setDateFormat:@"dd-MMMM-yy"];
    [dateFormatter setDateFormat:@"MM/dd/yyyy"];
    
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

- (NSMutableArray *)createEmptyDateArrays {
    NSMutableArray *emptyDateArray = [[NSMutableArray alloc] init];
    for (int i=0; i<dateRangeToParse.count; i++) {
        NSMutableArray *dateArray = [[NSMutableArray alloc] init];
        
        [emptyDateArray addObject:dateArray];
    }
    //NSLog(@"%ul", emptyDateArray.count);
    return emptyDateArray;
}

@end

