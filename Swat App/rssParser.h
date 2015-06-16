//
//  rssParser.h
//  Swat App
//
//  Created by Steve Jaoudi on 6/15/15.
//  Copyright (c) 2015 Steve Jaoudi. All rights reserved.
//

#ifndef Swat_App_rssParser_h
#define Swat_App_rssParser_h


#endif

#import <UIKit/UIKit.h>

@class Event, AppDelegate;

@interface rssParser : NSObject <NSXMLParserDelegate>{
    
    Event *event;
    AppDelegate *appdelegate;
    
    NSMutableString *curElem;
    
}

@property (nonatomic, retain) Event *event;
@property (nonatomic, retain) AppDelegate *appdelegate;
@property (nonatomic, retain) NSMutableString *curElem;

- (rssParser*) initXMLParser;

@end