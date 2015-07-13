//
//  TransportationViewController.m
//  Swat App
//
//  Created by Steve Jaoudi on 7/12/15.
//  Copyright (c) 2015 Steve Jaoudi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TransportationViewController.h"


@interface TransporationViewController () {
    
}

@end

@implementation TransporationViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //NSLog(@"HoursViewController Loaded");
    
    NSURL *dashURL = [NSURL URLWithString:@"https://secure.swarthmore.edu/dash/"];
    NSData *dashData = [NSData dataWithContentsOfURL:dashURL];
    NSString *dashString = [[NSString alloc] initWithData:dashData encoding:NSUTF8StringEncoding];
    
    NSString *transportationInfo = [self getTransporationInfo:dashString];
    
    NSString *trainTimes = [self getTrains:transportationInfo];
    
}

- (NSString *)getTrains :(NSString *)content {
    
        NSString *trainRegexString = @"train-times\">\\n?(.+)\\s<\\/div>";
        NSString *trainTimes = [self findRegex:trainRegexString :content];
    
    return trainTimes;

}

- (NSString *)getTransporationInfo :(NSString *)content {
    
    NSString *transporationInfoRegexString = @"train-times\">\\n?(.+)\\s<\\/div>";
    NSString *transporationInfo = [self findRegex:transporationInfoRegexString :content];
    
    return transporationInfo;
    
    
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