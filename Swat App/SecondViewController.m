//
//  SecondViewController.m
//  Swat App
//
//  Created by Steve Jaoudi on 6/14/15.
//  Copyright (c) 2015 Steve Jaoudi. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController ()

@end

@implementation SecondViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSURL *rssURL =[[NSURL alloc] initWithString:@"http://calendar.swarthmore.edu/calendar/RSSSyndicator.aspx?category=&location=&type=N&starting=5/1/2015&ending=5/29/2015&binary=Y&keywords=&ics=Y"];
    NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:rssURL];
    [parser setDelegate:self];
    [parser parse];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    self.currentElement = elementName;
    if([self.currentElement isEqualToString:@"title"])
    {
        self.currentTitle = [NSMutableString string];
    }
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if([self.currentElement isEqualToString:@"title"])
    {
        NSLog(@"%@", self.currentTitle);
    }
    self.currentTitle=nil;
    self.currentElement=nil;
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (!self.currentElement) return;
    if([self.currentElement isEqualToString:@"title"])
    {
        self.currentTitle=string;
    }
}

@end
