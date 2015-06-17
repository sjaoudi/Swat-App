//
//  FirstViewController.m
//  Swat App
//
//  Created by Steve Jaoudi on 6/14/15.
//  Copyright (c) 2015 Steve Jaoudi. All rights reserved.
//

#import "FirstViewController.h"
#import "RSSEntry.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

@synthesize allEntries = _allEntries;


- (IBAction)clickTheButton:(id)sender {
    NSLog(@"Git test.");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"Feeds";
    self.allEntries = [NSMutableArray array];
    [self addRows];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addRows {
    
    RSSEntry *entry1 = [[RSSEntry alloc]  initWithBlogTitle: @"1"
                                                articleTitle: @"1"
                                                  articleUrl: @"1"
                                                 articleDate: [NSDate date]];
                         
    RSSEntry *entry2 = [[RSSEntry alloc]  initWithBlogTitle: @"2"
                                                articleTitle: @"2"
                                                  articleUrl: @"2"
                                                articleDate: [NSDate date]];
    
    RSSEntry *entry3 = [[RSSEntry alloc]  initWithBlogTitle: @"3"
                                                articleTitle: @"3"
                                                  articleUrl: @"3"
                                                articleDate: [NSDate date]];
    
    
    [_allEntries insertObject:entry1 atIndex:0];
    [_allEntries insertObject:entry2 atIndex:0];
    [_allEntries insertObject:entry3 atIndex:0];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_allEntries count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    RSSEntry *entry = [_allEntries objectAtIndex:indexPath.row];
    
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    NSString *articleDateString = [dateFormatter stringFromDate:entry.articleDate];
    cell.textLabel.text = entry.articleTitle;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - %@", articleDateString, entry.blogTitle];
    
    return cell;
    
}

@end
