//
//  DetailTableViewController.m
//  Swat App
//
//  Created by Steve Jaoudi on 6/22/15.
//  Copyright (c) 2015 Steve Jaoudi. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DetailTableViewController.h"
#import "NSString+HTML.h"

typedef enum { SectionHeader, SectionDetail } Sections;
typedef enum { SectionHeaderTitle, SectionHeaderDate, SectionHeaderURL, SectionHeaderAuthor } HeaderRows;
typedef enum { SectionDetailSummary } DetailRows;

@implementation DetailTableViewController

@synthesize item, dateString, summaryString;

- (id)initWithStyle:(UITableViewStyle)style {
    if ((self = [super initWithStyle:style])) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Regex for checking
    NSError *error = NULL;
    NSString *allDayRegexString = @"&nbsp;<b>All Day</b>";
    NSRegularExpression *allDayRegex =
    [NSRegularExpression regularExpressionWithPattern:allDayRegexString
                                              options:0
                                                error:&error];
    NSString *endTimeRegexString = @"<b>End Time:<\\/b>&nbsp;<\\/td><td>(.+)<\\/td><\\/tr><\\/table><br \\/>";
    NSRegularExpression *endTimeRegex =
    [NSRegularExpression regularExpressionWithPattern:endTimeRegexString
                                              options:0
                                                error:&error];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //[formatter setDateStyle:NSDateFormatterMediumStyle];
    //[formatter setTimeStyle:NSDateFormatterMediumStyle];
    [formatter setDateFormat:@"MMMM d, yyyy, hh:mm a"];
    
    // Date
    if (item.date) {
        //NSLog(@"%@", item.content);
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"MMMM dd, yyyy"];
        
        NSString *allDayString = [self findAllDay:item.date :allDayRegex :format];
        //NSLog(@"all day");
        self.dateString = allDayString;
        if (!allDayString) {
            NSTextCheckingResult *textCheckingResult = [endTimeRegex firstMatchInString:item.content options:0 range:NSMakeRange(0, item.content.length)];
            
            NSRange matchRange = [textCheckingResult rangeAtIndex:1];
            NSString *endTime = [item.content substringWithRange:matchRange];

            NSString *withEndTime =[formatter stringFromDate:item.date];

            withEndTime = [withEndTime stringByAppendingString:@" - "];
            withEndTime = [withEndTime stringByAppendingString:endTime];
            self.dateString = withEndTime;
        }
    }
    else {
        //self.dateString = [formatter stringFromDate:item.date];
        self.summaryString = @"[No Date]";
    }
    
    // Summary
    if (item.summary) {
        self.summaryString = [item.summary stringByConvertingHTMLToPlainText];
        
        
    }
    else {
        self.summaryString = @"[No Summary]";
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0: return 4;
        default: return 1;
    }
}

// Change appearance of table view cells

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Get cell
    static NSString *CellIdentifier = @"CellA";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    // Display
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    if (item) {
        
        // Item Info
        NSString *itemTitle = item.title ? [item.title stringByConvertingHTMLToPlainText] : @"[No Title]";
        
        // Display
        switch (indexPath.section) {
            case SectionHeader: {
                // Header
                switch (indexPath.row) {
                    case SectionHeaderTitle:
                        cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
                        cell.textLabel.text = itemTitle;
                        break;
                    case SectionHeaderDate:
                        cell.textLabel.text = dateString ? dateString: @"[No Date]";
                        break;
                    case SectionHeaderURL:
                        cell.textLabel.text = item.link ? item.link : @"[No Link]";
                        cell.textLabel.textColor = [UIColor blueColor];
                        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
                        break;
                    case SectionHeaderAuthor:
                        cell.textLabel.text = item.author ? item.author : @"[No Author]";
                        
                        //NSLog(@"%@", item.summary);
                        break;
                }
                break;
            }
            case SectionDetail: {
                // Summary
                
                NSString *fixedSummary;
                NSString *CDATA = @"!<[CDATA[";
                //NSLog(@"Summary:%@", item.summary);
                // Removes CDATA Info from summary.
                
                //if ([item.summary hasPrefix:CDATA]) { // Expression not working
                if (item.summary) {
                    //NSLog(@"has the prefix");
                    fixedSummary = [item.summary substringWithRange:NSMakeRange([CDATA length], [item.summary length]-[CDATA length]-3)];
                }
                
                //cell.textLabel.text = summaryString;
                //cell.textLabel.text = item.summary;
                cell.textLabel.text = fixedSummary;
                cell.textLabel.numberOfLines = 0; // Multiline
                break;
            }
        }
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == SectionHeader) {
        
        // Regular
        return 34;
    }
    else {
        // Get height of summary
        NSString *summary = @"[No Summary]";
        //if (summaryString summary = summaryString;
        summary = item.summary;
        CGSize s = [summary sizeWithFont:[UIFont systemFontOfSize:15]
                       constrainedToSize:CGSizeMake(self.view.bounds.size.width - 40, MAXFLOAT)  // - 40 For cell padding
                           lineBreakMode:UILineBreakModeWordWrap];
        return s.height + 16; // Add padding
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Open URL
    if (indexPath.section == SectionHeader && indexPath.row == SectionHeaderURL) {
        if (item.link ) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:item.link]];
        }
    }
    // Deselect
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSString *) findAllDay:(NSDate *)givenDate :(NSRegularExpression *)regex :(NSDateFormatter *)format {
    
    NSDate *eventDate = item.date;
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateStyle:NSDateFormatterMediumStyle];
//    [formatter setTimeStyle:NSDateFormatterMediumStyle];
    
//    NSCalendar *gregorianCal = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
//    NSDateComponents *dateComps = [gregorianCal components: (NSCalendarUnitHour | NSCalendarUnitMinute)
//                                                  fromDate: eventDate];
    
    NSUInteger numberOfMatches = [regex numberOfMatchesInString:item.content
                                                        options:0
                                                          range:NSMakeRange(0, [item.content length])];
    
    //NSDate *date = [format dateFromString:eventDate];
    NSString *finalDateString = [format stringFromDate:eventDate];
    
    if (numberOfMatches > 0) {
        
        //NSLog(@"%@", finalDateString);
        NSString *allDayString = [finalDateString stringByAppendingString:@", All Day"];
        return allDayString;
    }
    return NULL;
}

@end

