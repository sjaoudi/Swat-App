//
//  EmergencyViewController.m
//  Swat App
//
//  Created by Steve Jaoudi on 8/2/15.
//  Copyright (c) 2015 Steve Jaoudi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EmergencyViewController.h"

#import "FirstViewController.h"

@interface EmergencyViewController () {
    
}

@end

@implementation EmergencyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"EmergencyViewController Loaded");
    
    FirstViewController *firstView = [[FirstViewController alloc] init];
    self.navigationItem.titleView = [firstView createNavbarTitle:@"Emergency Info"];
    
    UIScrollView *tempScrollView=(UIScrollView *)self.view;
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    //CGFloat height = [UIScreen mainScreen].bounds.size.height;
    
    tempScrollView.contentSize=CGSizeMake(width,450);
    
    
}

@end