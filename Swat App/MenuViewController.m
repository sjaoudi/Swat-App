//
//  MenuViewController.m
//  Swat App
//
//  Created by Steve Jaoudi on 7/19/15.
//  Copyright (c) 2015 Steve Jaoudi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MenuViewController.h"
#import "AppDelegate.h"

#import "FirstViewController.h"

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

@synthesize loadedTitlesAndMenus;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"MenuViewController Loaded");
    
    FirstViewController *firstView = [[FirstViewController alloc] init];
    self.navigationItem.titleView = [firstView createNavbarTitle:@"Menus" :NO];
    
    NSMutableArray *textBoxes = [[NSMutableArray alloc] initWithObjects:breakfastBox, lunchBox, dinnerBox, nil];
    NSMutableArray *labelBoxes = [[NSMutableArray alloc] initWithObjects:breakfastLabel, lunchLabel, dinnerLabel, nil];
    
    NSArray *meals = @[@"Breakfast", @"Lunch", @"Dinner"];
    
    NSMutableDictionary *mealsAndBoxes = [[NSMutableDictionary alloc] initWithObjects:textBoxes forKeys:meals];
    NSMutableDictionary *labelsAndBoxes = [[NSMutableDictionary alloc] initWithObjects:labelBoxes forKeys:meals];
    
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    loadedTitlesAndMenus = appDelegate.menu;
    
    [self initTextBoxes:loadedTitlesAndMenus :mealsAndBoxes :@"meal"];
    [self initTextBoxes:loadedTitlesAndMenus :labelsAndBoxes :@"label"];
    
    UIScrollView *tempScrollView=(UIScrollView *)self.view;
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    tempScrollView.contentSize=CGSizeMake(width,550);
    
}

- (NSArray *)menuViewLoad :(NSString *)dashString{

    NSString *menuBlock = [self getMenuInfo:dashString];
    
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
    
    NSArray *titlesAndMenus = [[NSArray alloc] initWithObjects:mealTitles, mealMenus, nil];
    
    return titlesAndMenus;
}

- (NSString *)getMenuInfo :(NSString *)content {
    
    NSString *menuInfoRegexString = @"id=\"dining\">((.|\n)*)id=\"entertainment";
    NSString *menuInfo = [self findRegex:menuInfoRegexString :content];
    
    return menuInfo;
}

- (void)initTextBoxes :(NSArray *)titlesAndMenus :(NSMutableDictionary *)dict :(NSString *)labelOrMeal{
    
    NSArray *mealTitles = titlesAndMenus[0];
    NSArray *mealMenus = titlesAndMenus[1];
    
    //for (int i=0; i < textBoxes.count; i++) {
    for (int i=0; i < mealMenus.count; i++) {
        UILabel *textBox = [[UILabel alloc] init];
        //textBox = textBoxes[i];
        textBox = [dict objectForKey:mealTitles[i]];
        
        if ([labelOrMeal isEqualToString:@"meal"]) {
            NSString *mealText = [mealMenus objectAtIndex:i];
            textBox.text = mealText;
        }
        
        if ([labelOrMeal isEqualToString:@"label"]) {
            NSString *labelText = [mealTitles objectAtIndex:i];
            textBox.text = labelText;
        }
        

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
        NSRange find = [match rangeAtIndex:1];
        [regexFinds addObject:[content substringWithRange:find]];
    }
    return regexFinds;
}


@end
