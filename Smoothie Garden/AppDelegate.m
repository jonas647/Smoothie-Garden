//
//  AppDelegate.m
//  Smoothie Garden
//
//  Created by Jonas C Björkell on 2015-08-02.
//  Copyright (c) 2015 Jonas C Björkell. All rights reserved.
//

#import "AppDelegate.h"
#import "SBIAPHelper.h"
//#import <Google/Analytics.h>
#import "AppReviewHelper.h"
#import "Ingredient.h"
#import "DeviceHelper.h"
#import "DetailedRecipeViewController.h"


/** Google Analytics configuration constants **/
static NSString *const kGaPropertyId = @"UA-51056320-4"; // Placeholder property ID.
static NSString *const kTrackingPreferenceKey = @"allowTracking";
static BOOL const kGaDryRun = NO;
static int const kGaDispatchPeriod = 20;

@interface AppDelegate ()

@end

@implementation AppDelegate
{
   
    
}



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //Google Analytics
    
    
    //If the analytics key hasn't been touched (first app launch) then set it to enabled
    BOOL analyticsEnabled;
    if(![[[[NSUserDefaults standardUserDefaults] dictionaryRepresentation] allKeys] containsObject:@"AnalyticsEnabled"]){
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"AnalyticsEnabled"];
        analyticsEnabled = YES;
    } else
        analyticsEnabled = [[NSUserDefaults standardUserDefaults]boolForKey:@"AnalyticsEnabled"];
    
    
    if (analyticsEnabled) {
        //NSLog(@"Remember to activate GA when releasing app");
        
        //If the user has enabled the analytics (or hasn't touched to analytics toggle)
        
        //Doing this initiliazation so that I can activate bitcode (Google/Analytics doesn't include this but GoogleAnalytics does...)
        // Optional: automatically send uncaught exceptions to Google Analytics.
        [GAI sharedInstance].trackUncaughtExceptions = YES;
        [GAI sharedInstance].dryRun = kGaDryRun;
        // Optional: set Google Analytics dispatch interval to e.g. 20 seconds.
        [GAI sharedInstance].dispatchInterval = kGaDispatchPeriod;
        // Optional: set debug to YES for extra debugging information.
        //[GAI sharedInstance].debug = YES;
        // Create tracker instance.
        [[GAI sharedInstance]trackerWithTrackingId:kGaPropertyId];
        
    } else {
        NSLog(@"Analytics disabled");
    }

    //End of Google Analytics
    
    //App Review start-up
    [AppReviewHelper firstTimeAppLaunch];
    
    //TODO
    //Check Country, If English then set measurement as US customary units at start (if hans't been set earlier)
    
    //Set all the navigation texts to be black
    [[UINavigationBar appearance] setTintColor:[UIColor blackColor]];
    [[UIToolbar appearance] setTintColor:[UIColor blackColor]];
    [[UIBarButtonItem appearance] setTintColor:[UIColor blackColor]];
    
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
