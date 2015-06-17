//
//  RSSEntry.m
//  Swat App
//
//  Created by Steve Jaoudi on 6/16/15.
//  Copyright (c) 2015 Steve Jaoudi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RSSEntry.h"

@implementation RSSEntry
@synthesize blogTitle = _blogTitle;
@synthesize articleTitle = _articleTitle;
@synthesize articleUrl = _articleUrl;
@synthesize articleDate = _articleDate;

- (id)initWithBlogTitle:(NSString*)blogTitle articleTitle:(NSString*)articleTitle articleUrl:(NSString*)articleUrl articleDate:(NSDate*)articleDate
{
    if ((self = [super init])) {
        _blogTitle = [blogTitle copy];
        _articleTitle = [articleTitle copy];
        _articleUrl = [articleUrl copy];
        _articleDate = [articleDate copy];
    }
    return self;
}

@end