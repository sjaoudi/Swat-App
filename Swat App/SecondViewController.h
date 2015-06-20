//
//  SecondViewController.h
//  Swat App
//
//  Created by Steve Jaoudi on 6/14/15.
//  Copyright (c) 2015 Steve Jaoudi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SecondViewController : UIViewController <NSXMLParserDelegate>

@property(nonatomic, strong) NSString *currentElement;
@property(nonatomic, strong) NSString *currentTitle;

@end