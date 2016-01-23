//
//  AppDelegate.m
//  Smoothie Garden
//
//  Created by Jonas C Björkell on 2015-08-02.
//  Copyright (c) 2015 Jonas C Björkell. All rights reserved.
//

#import "AppDelegate.h"
#import "SBIAPHelper.h"
#import <Google/Analytics.h>
#import "AppReviewHelper.h"
#import "Ingredient.h"


@interface AppDelegate ()

@end

@implementation AppDelegate
{
    /*
    NSManagedObjectContext *_managedObjectContext;
    NSManagedObjectModel *_managedObjectModel;
    NSPersistentStoreCoordinator *_persistentStoreCoordinator;
     */
}



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //Core Data, to save data in the app
    
    
    
    
    //End of Core data
    
    UIColor *mainColor = [UIColor colorWithRed:248.0f/255.0f green:248.0f/255.0f blue:245.0f/255.0f alpha:1.0f];
    //mainColor = [UIColor colorWithRed:245.0f/255.0f green:247.0f/255.0f blue:254.0f/255.0f alpha:1.0f];

    
    //UIColor *secondaryColor = [UIColor colorWithRed:175.0f/255.0f green:191.0f/255.0f blue:247.0f/255.0f alpha:1.0f];
    
    //Update the colors of where in the app the default color should be used
    [[UITabBar appearance] setBarTintColor:mainColor];
    [[UINavigationBar appearance] setBarTintColor:mainColor];
    
    /*
    NSShadow* shadow = [NSShadow new];
    shadow.shadowOffset = CGSizeMake(0.0f, 1.0f);
    shadow.shadowColor = secondaryColor;
     */
    [[UINavigationBar appearance] setTitleTextAttributes: @{
                                                            NSFontAttributeName: [UIFont fontWithName:@"Apple SD Gothic Neo" size:16.0f],
                                                            }];
    
    //Remove the top shadow line
    //[[UITabBar appearance] setBackgroundImage:[[UIImage alloc] init]];
    [[UITabBar appearance] setShadowImage:[[UIImage alloc] init]];
    
    //Remove the bottom shadow line
    //[[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    
    [[UITableViewCell appearance].contentView.layer setBorderWidth:2.0f];
    [[UITableViewCell appearance].contentView.layer setBorderColor:mainColor.CGColor];
    
    //Default font
    //[[UILabel appearance] setFont:[UIFont fontWithName:@"Verdana" size:10.0f]];
    
    //Tab bar items
    /*
    [[UITabBar appearance] setTintColor:secondaryColor];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       [UIColor darkGrayColor], NSForegroundColorAttributeName,
                                                       nil] forState:UIControlStateNormal];
    */

    
    //Appearance of the page control
    UIPageControl *pageControl = [UIPageControl appearance];
    pageControl.pageIndicatorTintColor = [UIColor blackColor];
    pageControl.currentPageIndicatorTintColor = [UIColor groupTableViewBackgroundColor];
    pageControl.backgroundColor = [UIColor clearColor];
    pageControl.alpha = 1;
    
    [self.window setTintColor:[UIColor blackColor]];
    
    //Get the in app purchases from the in app purchase helper singleton
    //Load it here so that the purchases are available when the user tries to buy the IAP
    [[SBIAPHelper sharedInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
        if (success) {
            _iTunesPurchases = [NSArray arrayWithArray:products];
            //array gets populated with skproduct objects
        }
    }];
    
    //Google Analytics
    
    //If the analytics key hasn't been touched (first app launch) then set it to enabled
    BOOL analyticsEnabled;
    if(![[[[NSUserDefaults standardUserDefaults] dictionaryRepresentation] allKeys] containsObject:@"AnalyticsEnabled"]){
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"AnalyticsEnabled"];
        analyticsEnabled = YES;
    } else
        analyticsEnabled = [[NSUserDefaults standardUserDefaults]boolForKey:@"AnalyticsEnabled"];
    
    if (analyticsEnabled) {
        //Since the key is null if the user hasn't disabled the analytics we need to invert the bool
        NSLog(@"Analytics Enabled");
        //If the user has enabled the analytics (or hasn't touched to analytics toggle)
        
        // Configure tracker from GoogleService-Info.plist.
        NSError *configureError;
        [[GGLContext sharedInstance] configureWithError:&configureError];
        NSAssert(!configureError, @"Error configuring Google services: %@", configureError);
        
        // Optional: configure GAI options.
        GAI *gai = [GAI sharedInstance];
        gai.trackUncaughtExceptions = YES;  // report uncaught exceptions
        gai.logger.logLevel = kGAILogLevelVerbose;  // remove before app release (TODO)
        
    } else {
        NSLog(@"Analytics disabled");
    }
    
    //End of Google Analytics
    
    //App Review start-up
    [AppReviewHelper firstTimeAppLaunch];
    
    //TODO
    //Check Country, If English then set measurement as US customary units at start (if hans't been set earlier)
    
    
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
/*
- (void) saveContext {
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = _managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (self.managedObjectContext != nil) {
        return self.managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return self.managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"DataModelName" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"ProjectName.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
 
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
 
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}
*/

@end
