//
//  FirstViewController.h
//  Swat App
//
//  Created by Steve Jaoudi on 6/14/15.
//  Copyright (c) 2015 Steve Jaoudi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HoursViewController.h"
#import "TransportationViewController.h"

@interface FirstViewController: UITableViewController

- (UIView *)createNavbarTitle :(NSString *)title :(BOOL)mainPage;

@end
