//
//  SBGoogleAnalyticsHelper.m
//  Smoothie Box
//
//  Created by Jonas C Björkell on 2015-11-18.
//  Copyright © 2015 Jonas C Björkell. All rights reserved.
//

#import "SBGoogleAnalyticsHelper.h"

@implementation SBGoogleAnalyticsHelper


//TODO separate GA and google AD information
//User should be able to shut off google ad info

+ (void) userLikedRecipeName:(NSString *)recipeName {
    
    //Check if google analytics is active
    if ([self isAnalyticsEnabled]) {
        //[self reportEventWithCategory:@"Recipe" andAction:@"Liked" andLabel:recipeName andValue:nil];
    }
}

+ (void) userDislikedRecipeName:(NSString *)recipeName {
    
    if ([self isAnalyticsEnabled]) {
        //[self reportEventWithCategory:@"Recipe" andAction:@"Disliked" andLabel:recipeName andValue:nil];
    }
}

+ (void) userEnableAnalytics {
    [self reportEventWithCategory:@"System" andAction:@"Toggle Analytics" andLabel:@"Enabled" andValue:nil];
    [self enableAnalytics:YES];
    
}

+ (void) userDisablesAnalytics {
    [self reportEventWithCategory:@"System" andAction:@"Toggle Analytics" andLabel:@"Disabled" andValue:nil];
    [self enableAnalytics:NO];
}

+ (void) userStartedPurchasingProcessOf:(NSString*)purchaseName {
    
    if ([self isAnalyticsEnabled]) {
        //[self reportEventWithCategory:@"Purchase" andAction:purchaseName andLabel:@"Started Purchasing" andValue:nil];
    }
}


+ (void) reportPurchaseWithName:(NSString *)name andPrice:(NSNumber *)price andTransactionId:(NSString *)transactionID{
    
    if ([self isAnalyticsEnabled]) {
        //TODO
        //Does this work??
        [super reportPurchaseWithName:name andPrice:price andTransactionId:transactionID];
    }
}
   

+ (void) reportScreenToAnalyticsWithName:(NSString *)screenName {
    
    //Check if google analytics is active
    if ([self isAnalyticsEnabled]) {
        [self setupUiViewForTrackingWithName:screenName];
    }
}

+ (BOOL) isAnalyticsEnabled {
    
    NSString *analyticsKey = @"AnalyticsEnabled";
    if (![[[[NSUserDefaults standardUserDefaults] dictionaryRepresentation] allKeys] containsObject:analyticsKey]) {
        //The analytics key will be setup at start-up. This is for safety
        NSLog(@"WARNING!!!!, the analytics key isn't set");
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:analyticsKey];
    }
    
    return [[NSUserDefaults standardUserDefaults]boolForKey:analyticsKey];
}

+ (void) enableAnalytics: (BOOL) enable {
    
    NSString *analyticsKey = @"AnalyticsEnabled";
    
    if (enable) {
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:analyticsKey];
    } else if (!enable) {
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:analyticsKey];
    }
}


@end
