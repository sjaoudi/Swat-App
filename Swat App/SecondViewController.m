//
//  SecondViewController.m
//  Swat App
//
//  Created by Steve Jaoudi on 6/14/15.
//  Copyright (c) 2015 Steve Jaoudi. All rights reserved.
//

#import "SecondViewController.h"
#import "MWFeedParser.h"

@interface SecondViewController ()

@end

@implementation SecondViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSURL *rssURL =[[NSURL alloc] initWithString:@"http://calendar.swarthmore.edu/calendar/RSSSyndicator.aspx?category=&location=&type=N&starting=5/1/2015&ending=5/15/2015&binary=Y&keywords=&ics=Y"];
    
    
    NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:rssURL];
    //NSXMLParser *parser = [[NSXMLParser alloc] initWithData:xmlData];
    
    [parser setDelegate:self];
    [parser parse];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// Finds all titles.
- (void)parser:(NSXMLParser *)parser foundCDATA:(NSData *)CDATABlock
{
    NSString *someString = [[NSString alloc] initWithData:CDATABlock encoding:NSUTF8StringEncoding];
    NSLog(@"Found CDATA: %@", someString);
}


-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    self.currentElement = elementName;
    if([self.currentElement isEqualToString:@"pubDate"])
    {
        //self.currentTitle = [NSMutableString string];
    }
}


-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if([self.currentElement isEqualToString:@"pubDate"])
    {
        //NSLog(@"%@", self.currentTitle);
    }
    self.currentTitle=nil;
    self.currentElement=nil;
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (!self.currentElement) return;
    
    if([self.currentElement isEqualToString:@"pubDate"])
    //if([self.currentTitle hasPrefix:@"<![CDATA"])
    {
        self.currentTitle=string;
        NSLog(@"Characters: %@", string);
    }
    
}

//- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
//    
//    if(!self.currentElement)
//        self.currentElement = [[NSMutableString alloc] initWithString:string];
//    else
//        self.currentTitle=string;
//    if ([self.currentElement isEqualToString:@"title"]) {
//        NSLog(@"Characters: %@", self.currentTitle);
//    }
//
//}



@end
