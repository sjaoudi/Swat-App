//
//  HoursViewController.m
//  Swat App
//
//  Created by Steve Jaoudi on 7/8/15.
//  Copyright (c) 2015 Steve Jaoudi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HoursViewController.h"

@implementation Place
@end

@interface HoursViewController () {
    
}

@end

@implementation HoursViewController

@synthesize textView;

- (void)viewDidLoad {
    [super viewDidLoad];
        
    //NSLog(@"HoursViewController Loaded");
    
    NSURL *dashURL = [NSURL URLWithString:@"https://secure.swarthmore.edu/dash/"];
    NSData *dashData = [NSData dataWithContentsOfURL:dashURL];
    NSString *dashString = [[NSString alloc] initWithData:dashData encoding:NSUTF8StringEncoding];
    //NSArray *hoursArray = [self getHours:dashString];
    NSDictionary *hoursInfo = [self getHours:dashString];
    
    //NSLog(@"%@", [hoursInfo valueForKey:@"Sharples"]);
    
    //textView.text = [hoursInfo valueForKey:@"Sharples"];
    
    textView.numberOfLines = 0;
    textView.text = @"hi \n hi";
    CGSize labelSize = [textView.text sizeWithAttributes:@{NSFontAttributeName:textView.font}];
    
    textView.frame = CGRectMake(
                             textView.frame.origin.x, textView.frame.origin.y,
                             textView.frame.size.width, labelSize.height);
    
}

- (NSDictionary *)getHours :(NSString *)dashString {
    
    NSArray *places = @[@"Sharples", @"Essie Mae's", @"Kohlberg", @"Science Center", @"Paces Cafe", @"McCabe", @"Underhill", @"Cornell", @"Help Desk Walk-In Hours", @"Media Center", @"Women's Resource Center", @"Post Office", @"Bookstore", @"Credit Union", @"Athletic Facilities"];
    NSMutableArray *hoursArray = [[NSMutableArray alloc] init];
    NSMutableArray *linksArray = [[NSMutableArray alloc] init];
    
    for (int i=0; i<places.count; i++) {

        NSMutableString *placeRegexMutableString = [[NSMutableString alloc] init];
        if ([places[i] isEqualToString:@"Paces Cafe"]) {
            [placeRegexMutableString appendString:@"<li><strong>:(.+)<\\/li>"];
            [placeRegexMutableString insertString:places[i] atIndex:12];
        }
        else {
            [placeRegexMutableString appendString:@"<li><strong>:(.+)<\\/a><\\/li>"];
            [placeRegexMutableString insertString:places[i] atIndex:12];
        }
        
        NSString *placeRegexString = [NSString stringWithString:placeRegexMutableString];
        NSString *placeToParse = [self findRegex:placeRegexString :dashString];
        
        NSString *linkRegexString = @"<a href=\"(.+)\">";
        NSString *placeLink = [self findRegex:linkRegexString :placeToParse];
        
        NSString *hoursRegexString = @"<\\/strong>\\s?(.+)\\s?<a";
        NSString *placeHours = [self findRegex:hoursRegexString :placeToParse];
        //Place *placeObj = [[Place alloc] init];
        
        //placeObj.placeName = places[i];
        //placeObj.placeHours = placeHours;
        //placeObj.placeLink = placeLink;
        
        [hoursArray addObject:placeHours];
        [linksArray addObject:placeLink];
    }
    //return hoursArray;
    NSDictionary *hoursInfo = [[NSDictionary alloc] initWithObjects:hoursArray forKeys:places];
    return hoursInfo;
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