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
    
    NSArray *itemsToDisplay;
    NSDateFormatter *formatter;
    
}

@property (nonatomic, strong) NSArray *itemsToDisplay;
//@property(nonatomic, strong) IBOutlet UITableView *tableView;
- (NSString *)removeDateTitle :(NSString *)title;

@end