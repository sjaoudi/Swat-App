//
//  HoursViewController.h
//  Swat App
//
//  Created by Steve Jaoudi on 7/8/15.
//  Copyright (c) 2015 Steve Jaoudi. All rights reserved.
//

#ifndef Swat_App_HoursViewController_h
#define Swat_App_HoursViewController_h

#endif

#import <UIKit/UIKit.h>

@interface HoursViewController : UIViewController {
    IBOutlet UILabel *sharplesHoursBox;
    IBOutlet UILabel *essiesHoursBox;
    IBOutlet UILabel *kohlbergHoursBox;
    IBOutlet UILabel *scHoursBox;
    IBOutlet UILabel *pacesHoursBox;
    
    IBOutlet UILabel *mccabeHoursBox;
    IBOutlet UILabel *underhillHoursBox;
    IBOutlet UILabel *cornellHoursBox;
    
    IBOutlet UILabel *helpdeskHoursBox;
    IBOutlet UILabel *mediacenterHoursBox;
    
    IBOutlet UILabel *wrcHoursBox;
    IBOutlet UILabel *postofficeHoursBox;
    IBOutlet UILabel *bookstoreHoursBox;
    IBOutlet UILabel *creditunionHoursBox;
    IBOutlet UILabel *athleticHoursbox;
}

@property (retain, nonatomic) IBOutlet UILabel *sharplesHoursBox;
@property (retain, nonatomic) IBOutlet UILabel *essiesHoursBox;
@property (retain, nonatomic) IBOutlet UILabel *kohlbergHoursBox;
@property (retain, nonatomic) IBOutlet UILabel *scHoursBox;
@property (retain, nonatomic) IBOutlet UILabel *pacesHoursBox;

@property (retain, nonatomic) IBOutlet UILabel *mccabeHoursBox;
@property (retain, nonatomic) IBOutlet UILabel *underhillHoursBox;
@property (retain, nonatomic) IBOutlet UILabel *cornellHoursBox;

@property (retain, nonatomic) IBOutlet UILabel *helpdeskHoursBox;
@property (retain, nonatomic) IBOutlet UILabel *mediacenterHoursBox;

@property (retain, nonatomic) IBOutlet UILabel *wrcHoursBox;
@property (retain, nonatomic) IBOutlet UILabel *postofficeHoursBox;
@property (retain, nonatomic) IBOutlet UILabel *bookstoreHoursBox;
@property (retain, nonatomic) IBOutlet UILabel *creditunionHoursBox;
@property (retain, nonatomic) IBOutlet UILabel *athleticHoursbox;

@end

@interface Place : NSObject {
    
}

@property NSString *placeName;
@property NSString *placeHours;
@property NSString *placeLink;

@end