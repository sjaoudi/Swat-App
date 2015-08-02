//
//  DetailTableViewController.m
//  Swat App
//
//  Created by Steve Jaoudi on 6/22/15.
//  Copyright (c) 2015 Steve Jaoudi. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SecondViewController.h"
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
//    NSError *error = NULL;
//    NSString *allDayRegexString = @"&nbsp;<b>All Day</b>";
//    NSRegularExpression *allDayRegex =
//    [NSRegularExpression regularExpressionWithPattern:allDayRegexString
//                                              options:0
//                                                error:&error];
//    NSString *endTimeRegexString = @"<b>End Time:<\\/b>&nbsp;<\\/td><td>(.+)<\\/td><\\/tr><\\/table><br \\/>";
//    NSRegularExpression *endTimeRegex =
//    [NSRegularExpression regularExpressionWithPattern:endTimeRegexString
//                                              options:0
//                                                error:&error];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMMM d, yyyy"];
    
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    [timeFormatter setDateFormat:@"hh:mm a"];
    
    
    // Date
    if (item.date) {
        //NSLog(@"%@", item.date);
        //NSDateFormatter *format = [[NSDateFormatter alloc] init];
        //[format setDateFormat:@"MMMM dd, yyyy"];
        
        NSString *allDayString = [self findAllDay:item.date :item.content :dateFormatter];
        //NSLog(@"all day");
        self.dateString = allDayString;
        if (!allDayString) {
            NSString *endTime = [self determineTimeRange :timeFormatter :item.content :item.date];
            NSString *eventDate = [dateFormatter stringFromDate:item.date];
            
            eventDate = [eventDate stringByAppendingString:@", "];
            self.dateString = [eventDate stringByAppendingString:endTime];
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
        //case 0: return 4;
        case 0: return 3;
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
    cell.textLabel.textColor = [UIColor colorWithRed:(51/255.f) green:(51/255.f) blue:(51/255.f) alpha:1.0f];
    [cell.textLabel setFont:[UIFont fontWithName:@"Avenir" size:18]];
    //cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.numberOfLines = 0;
    
    if (item) {
        
        // Item Info
        //NSString *itemTitle = item.title ? [item.title stringByConvertingHTMLToPlainText] : @"[No Title]";
        SecondViewController *secondView = [[SecondViewController alloc] init];
        NSString *itemTitle = item.title ? [secondView removeDateTitle:item.title] : @"[No Title]";
        
        // Display
        switch (indexPath.section) {
            case SectionHeader: {
                // Header
                switch (indexPath.row) {
                    case SectionHeaderTitle:
                        //cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
                        //cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
                        cell.textLabel.text = itemTitle;
                        break;
                    case SectionHeaderDate:
                        cell.textLabel.font = [cell.textLabel.font fontWithSize:14];
                        cell.textLabel.text = dateString ? dateString: @"[No Date]";
                        break;
                    case SectionHeaderURL:
                        cell.textLabel.font = [cell.textLabel.font fontWithSize:14];
                        cell.textLabel.text = item.link ? item.link : @"[No Link]";
                        cell.textLabel.textColor = [UIColor blueColor];
                        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
                        break;
                    //case SectionHeaderAuthor:
                        //cell.textLabel.text = item.author ? item.author : @"[No Author]";
                        
                        //NSLog(@"%@", item.summary);
                        //break;
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
                cell.textLabel.font = [cell.textLabel.font fontWithSize:14];
                cell.textLabel.text = fixedSummary;
                NSLog(@"%@", fixedSummary);
                cell.textLabel.numberOfLines = 0; // Multiline
                break;
            }
        }
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == SectionHeader) {
        if (!indexPath.row) {
            return 60;
        }
        
        // Regular
        return 34;
    }
    else {
        // Get height of summary
        NSString *summary = @"[No Summary]";
        //if (summaryString summary = summaryString;
        summary = item.summary;
        CGSize s = [summary sizeWithFont:[UIFont fontWithName:@"Avenir" size:14]
                       constrainedToSize:CGSizeMake(self.view.bounds.size.width - 40, MAXFLOAT)  // - 40 For cell padding
                           lineBreakMode:NSLineBreakByWordWrapping];
        
        //CGSize s = [summary sizeWithAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"Avenir" size:18]}];
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

- (NSString *) findAllDay:(NSDate *)givenDate :(NSString *)content :(NSDateFormatter *)format {
    NSError *error = NULL;
    NSString *allDayRegexString = @"&nbsp;<b>All Day</b>";
    NSRegularExpression *allDayRegex =
    [NSRegularExpression regularExpressionWithPattern:allDayRegexString
                                              options:0
                                                error:&error];
    
    NSDate *eventDate = givenDate;
    
    NSUInteger numberOfMatches = [allDayRegex numberOfMatchesInString:content
                                                        options:0
                                                          range:NSMakeRange(0, [content length])];
    
    NSString *finalDateString = [format stringFromDate:eventDate];
    
    if (numberOfMatches > 0) {
        NSString *allDayString = [finalDateString stringByAppendingString:@", All Day"];
        return allDayString;
    }
    return NULL;
}

- (NSString *) determineTimeRange:(NSDateFormatter *)timeFormatter :(NSString *)content :(NSDate *)date{
    NSError *error = NULL;
    NSString *endTimeRegexString = @"<b>End Time:<\\/b>&nbsp;<\\/td><td>(.+)<\\/td><\\/tr><\\/table><br \\/>";
    NSRegularExpression *endTimeRegex =
    [NSRegularExpression regularExpressionWithPattern:endTimeRegexString
                                              options:0
                                                error:&error];
    
    NSTextCheckingResult *textCheckingResult = [endTimeRegex firstMatchInString:content options:0 range:NSMakeRange(0, content.length)];
    if (!textCheckingResult) {
        NSString *withoutEndTime =[timeFormatter stringFromDate:date];
        return withoutEndTime;

    }
    NSRange matchRange = [textCheckingResult rangeAtIndex:1];
    NSString *endTime = [content substringWithRange:matchRange];
    
    NSString *withEndTime =[timeFormatter stringFromDate:date];
    
    
    withEndTime = [withEndTime stringByAppendingString:@" - "];
    withEndTime = [withEndTime stringByAppendingString:endTime];
    
    return withEndTime;
}

@end

