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
    IBOutlet UILabel *trainScheduleBox;
    IBOutlet UILabel *tripPlannerBox;
    IBOutlet UILabel *tricoVansBox;
    IBOutlet UILabel *vanScheduleBox;
    
}

@property (retain, nonatomic) IBOutlet UILabel *phillyTrainsBox;
@property (retain, nonatomic) IBOutlet UILabel *trainScheduleBox;
@property (retain, nonatomic) IBOutlet UILabel *tripPlannerBox;
@property (retain, nonatomic) IBOutlet UILabel *tricoVansBox;
@property (retain, nonatomic) IBOutlet UILabel *vanScheduleBox;

@end

@interface TransporationInfo : NSObject {
    
}

@property NSString *name;
@property NSString *info;

@end