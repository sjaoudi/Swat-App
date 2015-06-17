//
//  FirstViewController.h
//  Swat App
//
//  Created by Steve Jaoudi on 6/14/15.
//  Copyright (c) 2015 Steve Jaoudi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>

-(IBAction)clickTheButton:(id)sender;

@property NSMutableArray *allEntries;

@end

NSMutableArray *_allEntries;