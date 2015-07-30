//
//  TransportationViewController.h
//  Swat App
//
//  Created by Steve Jaoudi on 7/12/15.
//  Copyright (c) 2015 Steve Jaoudi. All rights reserved.
//

#ifndef Swat_App_TransportationViewController_h
#define Swat_App_TransportationViewController_h


#endif

#import <UIKit/UIKit.h>

@interface TransporationViewController : UIViewController {
    IBOutlet UILabel *phillyTrainsBox;
    IBOutlet UITextView *trainScheduleBox;
    IBOutlet UITextView *tripPlannerBox;
    IBOutlet UITextView *tricoVanScheduleBox;
    IBOutlet UILabel *vanScheduleBox;
    
}

@property (retain, nonatomic) IBOutlet UILabel *phillyTrainsBox;
@property (retain, nonatomic) IBOutlet UITextView *trainScheduleBox;
@property (retain, nonatomic) IBOutlet UITextView *tripPlannerBox;
@property (retain, nonatomic) IBOutlet UITextView *tricoVanScheduleBox;
@property (retain, nonatomic) IBOutlet UILabel *vanScheduleBox;

@property (retain, nonatomic) NSArray *loadedTransportationInfo;

- (NSArray *)transportationViewLoad :(NSString *)dashString;

@end

@interface TransporationInfo : NSObject {
    
}

@property NSString *name;
@property NSString *info;

@end