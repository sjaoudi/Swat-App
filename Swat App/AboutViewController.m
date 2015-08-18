//
//  AboutViewController.m
//  Swat App
//
//  Created by Steve Jaoudi on 8/12/15.
//  Copyright (c) 2015 Steve Jaoudi. All rights reserved.
//

#import "AboutViewController.h"
#import "FirstViewController.h"

@implementation AboutViewController

@synthesize email, icons8;

- (void)viewDidLoad {
    //UINavigationBar *navbar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 64)];
    //navbar.barTintColor = [UIColor colorWithRed:195/255.0 green:32/255.0 blue:70/255.0 alpha:1.0];
    //navbar.translucent = YES;
    FirstViewController *firstView = [[FirstViewController alloc] init];
    
    self.navigationItem.titleView = [firstView createNavbarTitle:@"About This App" :YES];
    
    
    //[self.view addSubview:navbar];
    
    email.text = @"sjaoudi1@swarthmore.edu";
    email.textColor = [UIColor colorWithRed:(0/255.f) green:(122/255.f) blue:(255/255.f) alpha:1.0f];
    [self initLinkBox:@"Icons8" :@"http://www.icons8.com" :icons8 :14];
}

- (void)initLinkBox :(NSString *)text :(NSString *)link :(UITextView *)box :(NSInteger)fontSize{
    NSURL* URL = [NSURL URLWithString:[link stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];
    NSMutableAttributedString * str = [[NSMutableAttributedString alloc] initWithString:text];
    [str addAttribute: NSLinkAttributeName value:URL range: NSMakeRange(0, str.length)];
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Avenir" size:fontSize] range:NSMakeRange(0, str.length)];
    
    box.attributedText = str;
    box.tintColor = [UIColor colorWithRed:(0/255.f) green:(122/255.f) blue:(255/255.f) alpha:1.0f];
}



@end
