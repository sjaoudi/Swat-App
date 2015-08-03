//
//  AppDelegate.m
//  Swat App
//
//  Created by Steve Jaoudi on 6/14/15.
//  Copyright (c) 2015 Steve Jaoudi. All rights reserved.
//

#import "AppDelegate.h"
#import "MWFeedParser.h"

#import "HoursViewController.h"
#import "MenuViewController.h"
#import "TransportationViewController.h"

//@interface AppDelegate ()

//@end

@implementation AppDelegate

@synthesize window;
@synthesize navigationController;

@synthesize hours;
@synthesize menu;
@synthesize transportation;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    NSLog(@"App has launched.");
    
    //NSURL *dashURL = [NSURL URLWithString:@"https://secure.swarthmore.edu/dash/"];
    NSURL *dashURL = [NSURL URLWithString:@"http://web.archive.org/web/20121004221810/https://secure.swarthmore.edu/dash/"];
    NSData *dashData = [NSData dataWithContentsOfURL:dashURL];
    NSString *dashString = [[NSString alloc] initWithData:dashData encoding:NSUTF8StringEncoding];
    
    [window addSubview:[navigationController view]];
    [window makeKeyAndVisible];
    
    [[UITabBar appearance] setTintColor:[UIColor colorWithRed:(185/255.f) green:(22/255.f) blue:(60/255.f) alpha:1.0f]];
    HoursViewController *hoursLoad = [[HoursViewController alloc] initWithNibName:@"HoursViewController" bundle:nil];
    hours = [hoursLoad HoursViewLoad :dashString];
    hoursLoad.loadedHoursInfo = hours;
    
    MenuViewController *menuLoad = [[MenuViewController alloc] initWithNibName:@"MenuViewController" bundle:nil];
    menu = [menuLoad menuViewLoad :dashString];
    menuLoad.loadedTitlesAndMenus = menu;
    
    TransporationViewController *transportationLoad = [[TransporationViewController alloc] initWithNibName:@"TransportationViewController" bundle:nil];
    transportation = [transportationLoad transportationViewLoad :dashString];
    transportationLoad.loadedTransportationInfo = transportation;
    
    NSLog(@"App has parsed data.");
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
