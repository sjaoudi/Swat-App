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
    
    // Date
    if (item.date) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterMediumStyle];
        self.dateString = [formatter stringFromDate:item.date];
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
                        NSLog(@"%@", item.summary);
                        break;
                }
                break;
            }
            case SectionDetail: {
                // Sumary
                //cell.textLabel.text = summaryString;
                cell.textLabel.text = item.summary;
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

@end

