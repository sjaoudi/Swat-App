//
//  RSSEntry.h
//  Swat App
//
//  Created by Steve Jaoudi on 6/16/15.
//  Copyright (c) 2015 Steve Jaoudi. All rights reserved.
//

#ifndef Swat_App_RSSEntry_h
#define Swat_App_RSSEntry_h


#endif

@interface RSSEntry : NSObject {
    NSString *_blogTitle;
    NSString *_articleTitle;
    NSString *_articleUrl;
    NSDate *_articleDate;
}

@property (copy) NSString *blogTitle;
@property (copy) NSString *articleTitle;
@property (copy) NSString *articleUrl;
@property (copy) NSDate *articleDate;

- (id)initWithBlogTitle:(NSString*)blogTitle articleTitle:(NSString*)articleTitle articleUrl:(NSString*)articleUrl articleDate:(NSDate*)articleDate;

@end