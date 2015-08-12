//
//  HoursTableViewController.h
//  Swat App
//
//  Created by Steve Jaoudi on 8/11/15.
//  Copyright (c) 2015 Steve Jaoudi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HoursTableViewController : UITableViewController {
    NSArray *loadedHoursInfo;
}

@property (nonatomic, copy) NSArray *loadedHoursInfo;

@property (nonatomic, copy) NSDictionary *hoursDict;
@property (nonatomic, copy) NSArray *hoursDictSections;

- (NSArray *)HoursViewLoad :(NSString *)dashString;

@end
