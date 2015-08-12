//
//  MenuViewController.h
//  Swat App
//
//  Created by Steve Jaoudi on 7/19/15.
//  Copyright (c) 2015 Steve Jaoudi. All rights reserved.
//

#ifndef Swat_App_MenuViewController_h
#define Swat_App_MenuViewController_h


#endif

#import <UIKit/UIKit.h>

@interface MenuViewController: UITableViewController {
    
    NSArray *titles;
    NSArray *menus;
    
}


@property (retain, nonatomic) NSDictionary *loadedTitlesAndMenus;
@property (retain, nonatomic) NSArray *titles;
@property (retain, nonatomic) NSArray *menus;

- (NSArray *)menuViewLoad :(NSString *)dashString;

@end