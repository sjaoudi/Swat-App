//
//  HoursViewController.m
//  Swat App
//
//  Created by Steve Jaoudi on 7/8/15.
//  Copyright (c) 2015 Steve Jaoudi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HoursViewController.h"

#import "AppDelegate.h"

@implementation Place
@end

@interface HoursViewController () {
    
}

@end

@implementation HoursViewController

@synthesize sharplesHoursBox;
@synthesize essiesHoursBox;
@synthesize kohlbergHoursBox;
@synthesize scHoursBox;
@synthesize pacesHoursBox;

@synthesize mccabeHoursBox;
@synthesize underhillHoursBox;
@synthesize cornellHoursBox;

@synthesize helpdeskHoursBox;
@synthesize mediacenterHoursBox;

@synthesize wrcHoursBox;
@synthesize postofficeHoursBox;
@synthesize bookstoreHoursBox;
@synthesize creditunionHoursBox;
@synthesize athleticHoursbox;

@synthesize loadedHoursInfo;

- (void)viewDidLoad {
    [super viewDidLoad];
        
    NSLog(@"HoursViewController Loaded");
    
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    loadedHoursInfo = appDelegate.hours;
    
    NSArray *textBoxes = [[NSArray alloc] initWithObjects:sharplesHoursBox, essiesHoursBox, kohlbergHoursBox, scHoursBox, pacesHoursBox, mccabeHoursBox, underhillHoursBox, cornellHoursBox, helpdeskHoursBox, mediacenterHoursBox, wrcHoursBox, postofficeHoursBox, bookstoreHoursBox, creditunionHoursBox, athleticHoursbox, nil];
    
    [self initTextBoxes:textBoxes :loadedHoursInfo];
    
    UIScrollView *tempScrollView=(UIScrollView *)self.view;
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    //CGFloat height = [UIScreen mainScreen].bounds.size.height;
    
    tempScrollView.contentSize=CGSizeMake(width,550);
    
}

- (NSArray *)HoursViewLoad :(NSString *)dashString{
    
    //[super viewDidLoad];
    //NSLog(@"HoursViewController Loaded");
    
//    //NSURL *dashURL = [NSURL URLWithString:@"https://secure.swarthmore.edu/dash/"];
//    NSURL *dashURL = [NSURL URLWithString:@"http://web.archive.org/web/20121004221810/https://secure.swarthmore.edu/dash/"];
//    NSData *dashData = [NSData dataWithContentsOfURL:dashURL];
//    NSString *dashString = [[NSString alloc] initWithData:dashData encoding:NSUTF8StringEncoding];

    NSArray *places = @[@"Sharples", @"Essie Mae's", @"Kohlberg", @"Science Center", @"Paces Cafe", @"McCabe", @"Underhill", @"Cornell", @"Help Desk Walk-In Hours", @"Media Center", @"Women's Resource Center", @"Post Office", @"Bookstore", @"Credit Union", @"Athletic Facilities"];
    
    NSArray *hoursInfo = [self getHours:dashString :places];

    return hoursInfo;
}

- (void)viewDidAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)initTextBoxes :(NSArray *)textBoxes :(NSArray *)hoursInfo{
    
    for (int i=0; i < textBoxes.count; i++) {
        UILabel *textBox = [[UILabel alloc] init];
        textBox = textBoxes[i];
        textBox.numberOfLines = 0;
        NSString *textBoxString = [hoursInfo objectAtIndex:i];
        textBoxString = [textBoxString stringByReplacingOccurrencesOfString:@"," withString:@"\n"];
        textBox.text = textBoxString;
        
        CGSize labelSize = [textBox.text sizeWithAttributes:@{NSFontAttributeName:textBox.font}];
        
        textBox.frame = CGRectMake(
                                    textBox.frame.origin.x, textBox.frame.origin.y,
                                    textBox.frame.size.width, labelSize.height);
    }
}


- (NSArray *)getHours :(NSString *)dashString :(NSArray *)places{
    
    NSMutableArray *hoursArray = [[NSMutableArray alloc] init];
    //NSMutableArray *linksArray = [[NSMutableArray alloc] init];
    
    for (int i=0; i<places.count; i++) {

        NSMutableString *placeRegexMutableString = [[NSMutableString alloc] init];
        if ([places[i] isEqualToString:@"Paces Cafe"]) {
            [placeRegexMutableString appendString:@"<strong>:\\W?<\\/strong><ul><li>(.+)<\\/li>"];
            [placeRegexMutableString insertString:places[i] atIndex:8];
            
        }
        else {
            [placeRegexMutableString appendString:@"<li><strong>:(.+)<\\/a><\\/li>"];
            [placeRegexMutableString insertString:places[i] atIndex:12];
        }
        
        // Entire dash string??
        NSString *placeRegexString = [NSString stringWithString:placeRegexMutableString];
        NSString *placeToParse = [self findRegex:placeRegexString :dashString];
        
        //NSString *linkRegexString = @"<a href=\"(.+)\">";
        //NSString *placeLink = [self findRegex:linkRegexString :placeToParse];
        
        NSString *hoursRegexString = @"<\\/strong>\\s?(.+)\\s?<a";
        NSString *placeHours = [self findRegex:hoursRegexString :placeToParse];
        //Place *placeObj = [[Place alloc] init];
        
        //placeObj.placeName = places[i];
        //placeObj.placeHours = placeHours;
        //placeObj.placeLink = placeLink;
        
        [hoursArray addObject:placeHours];
        //[linksArray addObject:placeLink];
    }
    //return hoursArray;
    
    //NSDictionary *hoursInfo = [[NSDictionary alloc] initWithObjects:hoursArray forKeys:places];
    //return hoursInfo;
    return hoursArray;
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


@end