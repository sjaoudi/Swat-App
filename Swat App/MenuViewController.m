//
//  MenuViewController.m
//  Swat App
//
//  Created by Steve Jaoudi on 7/19/15.
//  Copyright (c) 2015 Steve Jaoudi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MenuViewController.h"

@interface MenuViewController () {
    
}

@end



@implementation MenuViewController

@synthesize breakfastBox;
@synthesize lunchBox;
@synthesize dinnerBox;

@synthesize breakfastLabel;
@synthesize lunchLabel;
@synthesize dinnerLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"MenuViewController Loaded");
    
    NSURL *dashURL = [NSURL URLWithString:@"http://web.archive.org/web/20121004221810/https://secure.swarthmore.edu/dash/"];
    //NSURL *dashURL = [NSURL URLWithString:@"https://secure.swarthmore.edu/dash/"];
    
    NSData *dashData = [NSData dataWithContentsOfURL:dashURL];
    NSString *dashString = [[NSString alloc] initWithData:dashData encoding:NSUTF8StringEncoding];
    NSString *menuBlock = [self getMenuInfo:dashString];
    
    NSMutableArray *textBoxes = [[NSMutableArray alloc] initWithObjects:breakfastBox, lunchBox, dinnerBox, nil];
    NSMutableArray *labelBoxes = [[NSMutableArray alloc] initWithObjects:breakfastLabel, lunchLabel, dinnerLabel, nil];
    
    
    NSMutableArray *regexFinds = [self findMultipleRegex:@"((strong>Breakfast|strong>Continental Breakfast|strong>Brunch|strong>Lunch|strong>Dinner)(.|\n)*?\\/div)" :menuBlock];
    NSMutableArray *mealTitles = [[NSMutableArray alloc] init];
    NSMutableArray *mealMenus = [[NSMutableArray alloc] init];
    
    for (int i=0; i<regexFinds.count; i++) {
        NSString *regexFind = regexFinds[i];
        NSString *mealTitle = [self findRegex:@"strong>(.+)<\\/strong>" :regexFind];
        [mealTitles addObject:mealTitle];
        
        NSString *mealMenu = [self findRegex:@"dining-menu\">((.|\n)*?)<\\/div" :regexFind];
        mealMenu = [mealMenu stringByReplacingOccurrencesOfString:@"<br />" withString:@""];
        mealMenu = [mealMenu stringByReplacingOccurrencesOfString:@"<br>" withString:@""];
        [mealMenus addObject:mealMenu];
    }
    
    NSLog(@"%@", mealTitles);
    NSLog(@"%@", mealMenus);
    
    [self initTextBoxes:textBoxes :mealMenus];
    [self initTextBoxes:labelBoxes :mealTitles];
    
    UIScrollView *tempScrollView=(UIScrollView *)self.view;
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    //CGFloat height = [UIScreen mainScreen].bounds.size.height;
    
    tempScrollView.contentSize=CGSizeMake(width,500);
    
}

- (NSString *)getMenuInfo :(NSString *)content {
    
    NSString *menuInfoRegexString = @"id=\"dining\">((.|\n)*)id=\"entertainment";
    NSString *menuInfo = [self findRegex:menuInfoRegexString :content];
    
    return menuInfo;
}

- (void)initTextBoxes :(NSArray *)textBoxes :(NSArray *)mealMenus{
    
    for (int i=0; i < textBoxes.count; i++) {
        UILabel *textBox = [[UILabel alloc] init];
        textBox = textBoxes[i];
        
        //textBox.numberOfLines = 0;
        textBox.text = [mealMenus objectAtIndex:i];
        //textBox.text = @"hi \n hi";
        textBox.numberOfLines = 0;
        
        CGSize labelSize = [textBox.text sizeWithAttributes:@{NSFontAttributeName:textBox.font}];
        
        textBox.frame = CGRectMake(
                                   textBox.frame.origin.x, textBox.frame.origin.y,
                                   textBox.frame.size.width, labelSize.height);
    }
}

- (NSString *)findRegex :(NSString *)regexString :(NSString *)content{
    NSError *error = NULL;
    NSRegularExpression *regex =
    [NSRegularExpression regularExpressionWithPattern:regexString
                                              options:0
                                                error:&error];
    
    NSTextCheckingResult *textCheckingResult = [regex firstMatchInString:content options:0 range:NSMakeRange(0, content.length)];
    
    NSRange matchRange = [textCheckingResult rangeAtIndex:1];
    
    
    NSString *result = [content substringWithRange:matchRange];
    
    return result;
}

- (NSMutableArray *)findMultipleRegex :(NSString *)regexString :(NSString *)content{
    NSError *error = NULL;
    
    NSRange searchedRange = NSMakeRange(0, [content length]);
    
    NSRegularExpression *regex =
    [NSRegularExpression regularExpressionWithPattern:regexString
                                              options:0
                                                error:&error];
    
    NSArray *matches = [regex matchesInString:content options:0 range: searchedRange];
    
    NSMutableArray *regexFinds = [[NSMutableArray alloc] init];
    
    for (NSTextCheckingResult* match in matches) {
        //NSString* matchText = [content substringWithRange:[match range]];
        //NSLog(@"match: %@", matchText);
        NSRange find = [match rangeAtIndex:1];
        //NSRange group2 = [match rangeAtIndex:2];
        //NSLog(@"group1: %@", [content substringWithRange:find]);
        [regexFinds addObject:[content substringWithRange:find]];
        //NSLog(@"group2: %@", [searchedString substringWithRange:group2]);
    }
    return regexFinds;
}


@end
