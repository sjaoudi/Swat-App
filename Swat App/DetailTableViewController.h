//
//  DetailTableViewController.h
//  Swat App
//
//  Created by Steve Jaoudi on 6/22/15.
//  Copyright (c) 2015 Steve Jaoudi. All rights reserved.
//

#ifndef Swat_App_DetailTableViewController_h
#define Swat_App_DetailTableViewController_h


#endif

#import <UIKit/UIKit.h>
#import "MWFeedItem.h"

@interface DetailTableViewController : UITableViewController {
    MWFeedItem *item;
    NSString *dateString, *summaryString;
}

@property (nonatomic, strong) MWFeedItem *item;
@property (nonatomic, strong) NSString *dateString, *summaryString;

@end