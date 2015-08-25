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

@synthesize emergencyResponseBox;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //NSLog(@"EmergencyViewController Loaded");
    
    FirstViewController *firstView = [[FirstViewController alloc] init];
    self.navigationItem.titleView = [firstView createNavbarTitle:@"Emergency Info" :NO];
    
    UIScrollView *tempScrollView=(UIScrollView *)self.view;
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    tempScrollView.contentSize=CGSizeMake(width,360);
    
    [self initLinkBox:@"http://www.swarthmore.edu/public-safety/emergency-response-guide"];
}

- (void)initLinkBox :(NSString *)link {
    NSURL* URL = [NSURL URLWithString:[link stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];
    NSMutableAttributedString * str = [[NSMutableAttributedString alloc] initWithString:@"EMERGENCY RESPONSE GUIDE"];
    [str addAttribute: NSLinkAttributeName value:URL range: NSMakeRange(0, str.length)];
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Avenir" size:18] range:NSMakeRange(0, str.length)];
    
    UITextView *box = emergencyResponseBox;
    box.attributedText = str;
    box.tintColor = [UIColor colorWithRed:(0/255.f) green:(122/255.f) blue:(255/255.f) alpha:1.0f];
}

@end