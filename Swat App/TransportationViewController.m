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

@synthesize phillyTrainsBox;
@synthesize trainScheduleBox;
@synthesize tripPlannerBox;
@synthesize tricoVansBox;
@synthesize vanScheduleBox;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"TransporationViewController Loaded");
    
    NSURL *dashURL = [NSURL URLWithString:@"http://web.archive.org/web/20121004221810/https://secure.swarthmore.edu/dash/"];
    NSData *dashData = [NSData dataWithContentsOfURL:dashURL];
    NSString *dashString = [[NSString alloc] initWithData:dashData encoding:NSUTF8StringEncoding];
    
    NSString *transportationBlock = [self getTransporationInfo:dashString];

    //NSString *septaScheduleLink = @"http://www.septa.org/schedules/rail/pdf/elw.pdf";
    //NSString *phillyShuttleLink = @"http://www.swarthmore.edu/x10940.xml";
    //NSString *moreShuttlesLink = @"http://www.swarthmore.edu/gettingaround.xml";
    //NSString *parkingLink = @"http://www.swarthmore.edu/x16144.xml";
    
    NSArray *infoToGet = @[@"trains", @"shuttle", @"tripPlanner", @"vanSchedule"];
    NSMutableArray *infoToGetMutable = [NSMutableArray arrayWithArray:infoToGet];
    
    NSMutableArray *transportationInfo = [self getInfoStrings:transportationBlock :infoToGet];
    
    NSArray *textBoxes = [[NSArray alloc] initWithObjects:phillyTrainsBox, trainScheduleBox, tripPlannerBox, tricoVansBox, vanScheduleBox, nil];

    [self initTextBoxes:textBoxes :transportationInfo];
    NSDictionary *transportationDict = [[NSDictionary alloc] initWithObjects:transportationInfo forKeys:infoToGetMutable];
    NSMutableDictionary *transportationDictMutable = [NSMutableDictionary dictionaryWithDictionary:transportationDict];
    
    NSString *trainTimesList = [[transportationDict objectForKey:@"trains"] stringByReplacingOccurrencesOfString:@"," withString:@"\n"];
    
    [[transportationDictMutable objectForKey:@"trains"] setObject:trainTimesList forKey:@"trains"];
    
    //NSLog(@"%@", transportationDictMutable);
    NSLog(@"%@", [transportationDict objectForKey:@"trains"]);
    
}

- (void)initTextBoxes :(NSArray *)textBoxes :(NSArray *)places{
    
    for (int i=0; i < textBoxes.count; i++) {
        UILabel *textBox = [[UILabel alloc] init];
        textBox = textBoxes[i];
        textBox.numberOfLines = 0;
        textBox.text = [places objectAtIndex:i];
        
        CGSize labelSize = [textBox.text sizeWithAttributes:@{NSFontAttributeName:textBox.font}];
        
        textBox.frame = CGRectMake(
                                   textBox.frame.origin.x, textBox.frame.origin.y,
                                   textBox.frame.size.width, labelSize.height);
    }
}

- (NSMutableArray *)getInfoStrings :(NSString *)transportationInfo :(NSArray *)infoToGet{
    
    NSArray *regexesForInfo = @[@"train-times\">\\n?(.+)\\s<\\/div>", @"shuttle-times\">\\n?(.+)\\s<\\/div>", @"\\s<a href=\"((.|\n)*)\"\\s?\\S+Sep", @"<p><a href=\"(.+)\"[a-z]\\S+T"];
    
    //transportationDict = [NSDictionary dictionaryWithObjects:infoToGet forKeys:regexesForInfo];
    NSMutableArray *transporationInfoArray = [[NSMutableArray alloc] init];
    
    for (int i=0; i<infoToGet.count; i++) {
        //TransporationInfo *transportationObj = [[TransporationInfo alloc] init];
        //transportationObj.name = infoToGet[i];
        //transportationObj.info = [self findRegex:regexesForInfo[i] :transportationInfo];
        //[transporationInfoArray addObject:transportationObj];
        [transporationInfoArray addObject: [self findRegex:regexesForInfo[i] :transportationInfo]];
        
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