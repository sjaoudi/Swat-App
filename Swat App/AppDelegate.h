//
//  AppDelegate.h
//  Swat App
//
//  Created by Steve Jaoudi on 6/14/15.
//  Copyright (c) 2015 Steve Jaoudi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    
    UIWindow *window;
    UINavigationController *navigationController;
    NSArray *hoursInfo;
}

@property (strong, nonatomic) IBOutlet UIWindow *window;
@property (strong, nonatomic) IBOutlet UINavigationController *navigationController;
@property (nonatomic, copy) NSArray *hours;
@property (nonatomic, copy) NSDictionary *menu;
@property (nonatomic, copy) NSArray *transportation;




@end

