//
//  SecondViewController.h
//  Swat App
//
//  Created by Steve Jaoudi on 6/14/15.
//  Copyright (c) 2015 Steve Jaoudi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MWFeedParser.h>
#import "DetailTableViewController.h"

@interface SecondViewController : UITableViewController <MWFeedParserDelegate> {
    MWFeedParser *feedParser;
    NSMutableArray *parsedItems;
    
    NSMutableArray *allDates;
    NSMutableDictionary *eventsDictionary;
    NSArray *eventSectionTitles;
    NSArray *eventSectionTitlesStrings;
    NSArray *dateRangeToParse;
    NSMutableArray *dateArrays;
    
    NSArray *itemsToDisplay;
    NSDateFormatter *formatter;
    
    NSString  *todayString;
    NSString *twoWeekString;
    
    NSString *eventDate;
    
    NSArray *eventSectionsTest;
}

@property (nonatomic, strong) NSArray *itemsToDisplay;
@property (nonatomic, retain) NSArray *eventSectionsTest;
//@property(nonatomic, strong) IBOutlet UITableView *tableView;
- (NSString *)removeDateTitle :(NSString *)title;
//- (NSArray *)getDateStringArray;

@end
