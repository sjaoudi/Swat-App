//
//  FirstViewController.h
//  Swat App
//
//  Created by Steve Jaoudi on 6/14/15.
//  Copyright (c) 2015 Steve Jaoudi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstViewController : UIViewController

-(IBAction)clickTheButton:(id)sender;


@end

@interface Event: NSObject {
    NSString *Title;
    NSString *Time;
    NSString *Description;
}

@property (nonatomic, retain) NSString *Title;
@property (nonatomic, retain) NSString *Time;
@property (nonatomic, retain) NSString *Description;

@end