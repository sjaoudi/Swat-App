//
//  TransportationViewController.m
//  Swat App
//
//  Created by Steve Jaoudi on 7/12/15.
//  Copyright (c) 2015 Steve Jaoudi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TransportationViewController.h"

@implementation TransporationInfo
@end

@interface TransporationViewController () {
    
}

@end

@implementation TransporationViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"TransporationViewController Loaded");
    
    NSURL *dashURL = [NSURL URLWithString:@"http://web.archive.org/web/20121004221810/https://secure.swarthmore.edu/dash/"];
    NSData *dashData = [NSData dataWithContentsOfURL:dashURL];
    NSString *dashString = [[NSString alloc] initWithData:dashData encoding:NSUTF8StringEncoding];
    
    NSString *transportationInfo = [self getTransporationInfo:dashString];

    //NSString *septaScheduleLink = @"http://www.septa.org/schedules/rail/pdf/elw.pdf";
    //NSString *phillyShuttleLink = @"http://www.swarthmore.edu/x10940.xml";
    //NSString *moreShuttlesLink = @"http://www.swarthmore.edu/gettingaround.xml";
    //NSString *parkingLink = @"http://www.swarthmore.edu/x16144.xml";
    
    NSMutableArray *info = [self getInfoStrings:transportationInfo];
    NSLog(@"transportation info: %@", info);
    
}

- (NSMutableArray *)getInfoStrings :(NSString *)transportationInfo{
    NSArray *infoToGet = @[@"trains", @"shuttle", @"tripPlanner", @"vanSchedule"];
    
    NSArray *regexesForInfo = @[@"train-times\">\\n?(.+)\\s<\\/div>", @"shuttle-times\">\\n?(.+)\\s<\\/div>", @"\\s<a href=\"((.|\n)*)\"\\s?\\S+Sep", @"<p><a href=\"(.+)\"[a-z]\\S+T"];
    
    //transportationDict = [NSDictionary dictionaryWithObjects:infoToGet forKeys:regexesForInfo];
    NSMutableArray *transporationInfoArray = [[NSMutableArray alloc] init];
    
    for (int i=0; i<infoToGet.count; i++) {
        TransporationInfo *transportationObj = [[TransporationInfo alloc] init];
        transportationObj.name = infoToGet[i];
        transportationObj.info = [self findRegex:regexesForInfo[i] :transportationInfo];
        [transporationInfoArray addObject:transportationObj];
        
    }
    return transporationInfoArray;
}

- (NSString *)getTransporationInfo :(NSString *)content {
    
    NSString *transporationInfoRegexString = @"transportation_mod\">((.|\n)*)Parking<\\/a>";
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