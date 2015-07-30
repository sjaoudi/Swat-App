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

@interface MenuViewController: UIViewController {
    
    IBOutlet UILabel *breakfastBox;
    IBOutlet UILabel *lunchBox;
    IBOutlet UILabel *dinnerBox;
    
    IBOutlet UILabel *breakfastLabel;
    IBOutlet UILabel *lunchLabel;
    IBOutlet UILabel *dinnerLabel;
    
}

@property (retain, nonatomic) IBOutlet UILabel *breakfastBox;
@property (retain, nonatomic) IBOutlet UILabel *lunchBox;
@property (retain, nonatomic) IBOutlet UILabel *dinnerBox;

@property (retain, nonatomic) IBOutlet UILabel *breakfastLabel;
@property (retain, nonatomic) IBOutlet UILabel *lunchLabel;
@property (retain, nonatomic) IBOutlet UILabel *dinnerLabel;

@property (retain, nonatomic) NSArray *loadedTitlesAndMenus;

- (NSArray *)menuViewLoad :(NSString *)dashString;


@end