//
//  AppDelegate.m
//  Smoothie Garden
//
//  Created by Jonas C Björkell on 2015-08-02.
//  Copyright (c) 2015 Jonas C Björkell. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    UIColor *mainColor = [UIColor colorWithRed:248.0f/255.0f green:248.0f/255.0f blue:245.0f/255.0f alpha:1.0f];
    UIColor *secondaryColor = [UIColor colorWithRed:248.0f/255.0f green:248.0f/255.0f blue:245.0f/255.0f alpha:1.0f];
    
    //Update the colors of where in the app the default color should be used
    [[UITabBar appearance] setBarTintColor:mainColor];
    [[UINavigationBar appearance] setBarTintColor:mainColor];
    [[UITableViewCell appearance] setBackgroundColor:mainColor];
    [[UITableView appearance] setBackgroundColor:secondaryColor];
    
    //[[UITableViewCell appearance].layer setCornerRadius:20.0f];
    //[[UITableViewCell appearance].layer setMasksToBounds:YES];
    
    [[UITableViewCell appearance] setLayoutMargins:UIEdgeInsetsMake(5.0f, 5.0f, 5.0f, 5.0f)];
    
    //Remove the top shadow line
    //[[UITabBar appearance] setBackgroundImage:[[UIImage alloc] init]];
    [[UITabBar appearance] setShadowImage:[[UIImage alloc] init]];
    
    //Remove the bottom shadow line
    //[[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    
    [[UITableViewCell appearance].contentView.layer setBorderWidth:2.0f];
    [[UITableViewCell appearance].contentView.layer setBorderColor:mainColor.CGColor];
    
    //Default font
    [[UILabel appearance] setFont:[UIFont fontWithName:@"Verdana" size:10.0f]];
    
    //Tab bar items
    [[UITabBar appearance] setTintColor:secondaryColor];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       [UIColor darkGrayColor], NSForegroundColorAttributeName,
                                                       nil] forState:UIControlStateNormal];
    
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
