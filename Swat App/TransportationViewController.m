//
//  TransportationViewController.m
//  Swat App
//
//  Created by Steve Jaoudi on 7/12/15.
//  Copyright (c) 2015 Steve Jaoudi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TransportationViewController.h"
#import "AppDelegate.h"

#import "FirstViewController.h"

@implementation TransporationInfo
@end

@interface TransporationViewController () {
    
}

@end

@implementation TransporationViewController

@synthesize phillyTrainsBox;
@synthesize trainScheduleBox;
@synthesize tripPlannerBox;
@synthesize tricoVanScheduleBox;
@synthesize vanScheduleBox;

@synthesize loadedTransportationInfo;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"TransporationViewController Loaded");
    
    FirstViewController *firstView = [[FirstViewController alloc] init];
    self.navigationItem.titleView = [firstView createNavbarTitle:@"Transportation"];
    
//    //NSURL *dashURL = [NSURL URLWithString:@"http://web.archive.org/web/20121004221810/https://secure.swarthmore.edu/dash/"];
//    NSURL *dashURL = [NSURL URLWithString:@"https://secure.swarthmore.edu/dash/"];
//    
//    NSData *dashData = [NSData dataWithContentsOfURL:dashURL];
//    NSString *dashString = [[NSString alloc] initWithData:dashData encoding:NSUTF8StringEncoding];
//    
//    NSString *transportationBlock = [self getTransporationInfo:dashString];
//
//    NSString *septaScheduleLink = @"http://www.septa.org/schedules/rail/pdf/elw.pdf";
//    //NSString *phillyShuttleLink = @"http://www.swarthmore.edu/x10940.xml";
//    //NSString *moreShuttlesLink = @"http://www.swarthmore.edu/gettingaround.xml";
//    //NSString *parkingLink = @"http://www.swarthmore.edu/x16144.xml";
//    
//    NSMutableArray *transportationLinksInitial = [[NSMutableArray alloc] initWithObjects:septaScheduleLink, nil];
//    
//    NSMutableArray *transportationTimes = [self getInfoStrings:transportationBlock];
//    [self replaceCommas:transportationTimes];
//   
//    NSMutableArray *transporationLinks = [self getLinks:transportationBlock];
//    [transporationLinks addObjectsFromArray:transportationLinksInitial];
    
    //NSLog(@"%@", transporationLinks);
    
    NSArray *linkLabels = @[@"Septa Trip Planner", @"Trico Van Schedule", @"Septa Schedule"];

    NSMutableArray *textBoxes = [[NSMutableArray alloc] initWithObjects:phillyTrainsBox, vanScheduleBox, nil];
    NSMutableArray *linkBoxes = [[NSMutableArray alloc] initWithObjects:trainScheduleBox, tripPlannerBox, tricoVanScheduleBox, nil];
    
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    loadedTransportationInfo = appDelegate.transportation;
    
    [self initTextBoxes:textBoxes :loadedTransportationInfo[0]];
    [self initLinks:loadedTransportationInfo[1] :linkBoxes :linkLabels];
    
    
    UIScrollView *tempScrollView=(UIScrollView *)self.view;
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    //CGFloat height = [UIScreen mainScreen].bounds.size.height;
    
    tempScrollView.contentSize=CGSizeMake(width,450);
    
}

- (NSArray *)transportationViewLoad :(NSString *)dashString{
    
    NSString *transportationBlock = [self getTransporationInfo:dashString];
    
    NSString *septaScheduleLink = @"http://www.septa.org/schedules/rail/pdf/elw.pdf";
    //NSString *phillyShuttleLink = @"http://www.swarthmore.edu/x10940.xml";
    //NSString *moreShuttlesLink = @"http://www.swarthmore.edu/gettingaround.xml";
    //NSString *parkingLink = @"http://www.swarthmore.edu/x16144.xml";
    
    NSMutableArray *transportationLinksInitial = [[NSMutableArray alloc] initWithObjects:septaScheduleLink, nil];
    
    NSMutableArray *transportationTimes = [self getInfoStrings:transportationBlock];
    [self replaceCommas:transportationTimes];
    
    NSMutableArray *transportationLinks = [self getLinks:transportationBlock];
    [transportationLinks addObjectsFromArray:transportationLinksInitial];
    
    NSArray *transportationInfo = [[NSArray alloc] initWithObjects:transportationTimes, transportationLinks, nil];
    
    return transportationInfo;
}

- (void)replaceCommas :(NSMutableArray *)transportationTimes {
    for (int i=0; i<transportationTimes.count; i++) {
        NSString *transportationTime = transportationTimes[i];
        transportationTime = [transportationTime stringByReplacingOccurrencesOfString:@", " withString:@"\n"];
        transportationTimes[i] = transportationTime;
    }
}

- (void)initTextBoxes :(NSArray *)textBoxes :(NSArray *)places{
    
    for (int i=0; i < textBoxes.count; i++) {
        UILabel *textBox = [[UILabel alloc] init];
        textBox = textBoxes[i];
        
        //textBox.numberOfLines = 0;
        textBox.text = [places objectAtIndex:i];
        //textBox.text = @"hi \n hi";
        textBox.numberOfLines = 0;
        
        CGSize labelSize = [textBox.text sizeWithAttributes:@{NSFontAttributeName:textBox.font}];
        
        
        textBox.frame = CGRectMake(
                                   textBox.frame.origin.x, textBox.frame.origin.y,
                                   textBox.frame.size.width, labelSize.height);
    }
}

- (void)initLinks :(NSArray *)links :(NSMutableArray *)linkBoxes :(NSArray *)linkLabels{
    for (int i=0; i<linkBoxes.count; i++) {
        NSURL* URL = [NSURL URLWithString:[links[i] stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];
        NSMutableAttributedString * str = [[NSMutableAttributedString alloc] initWithString:linkLabels[i]];
//        UIFont *font = [UIFont fontWithName:@"Avenir" size:18];
//        NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:font
//                                                                    forKey:NSFontAttributeName];
//        NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:linkLabels[i] attributes:attrsDictionary];
        [str addAttribute: NSLinkAttributeName value:URL range: NSMakeRange(0, str.length)];
        [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Avenir" size:18] range:NSMakeRange(0, str.length)];
        
        UITextView *box = linkBoxes[i];
        box.attributedText = str;
        box.tintColor = [UIColor colorWithRed:(0/255.f) green:(122/255.f) blue:(255/255.f) alpha:1.0f];
        
    }
}

- (NSMutableArray *)getInfoStrings :(NSString *)transportationInfo{
    
    NSArray *regexesForInfo = @[@"train-times\">\\n?(.+)\\s<\\/div>", @"shuttle-times\">\\n?(.+)\\s<\\/div>"];
    NSMutableArray *transporationInfoArray = [[NSMutableArray alloc] init];
    
    for (int i=0; i<regexesForInfo.count; i++) {
        [transporationInfoArray addObject: [self findRegex:regexesForInfo[i] :transportationInfo]];
        
    }
    return transporationInfoArray;
    
}

- (NSMutableArray *)getLinks :(NSString *)transportationInfo {
    NSArray *regexesForLinks = @[@"\\s<a href=\"((.|\n)*)\"\\s?\\S+Sep", @"<p><a href=\"(.+)\"[a-z]\\S+T"];
    NSMutableArray *linkArray = [[NSMutableArray alloc] init];
    
    for (int i=0; i<regexesForLinks.count; i++) {
        [linkArray addObject: [self findRegex:regexesForLinks[i] :transportationInfo]];
    }
    return linkArray;
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
    
    //result = [result stringByReplacingOccurrencesOfString:@"," withString:@"\n"];
    
    return result;
}


@end