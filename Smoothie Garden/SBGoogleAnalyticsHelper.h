//
//  SBGoogleAnalyticsHelper.h
//  Smoothie Box
//
//  Created by Jonas C Björkell on 2015-11-18.
//  Copyright © 2015 Jonas C Björkell. All rights reserved.
//

#import "GoogleAnalyticsHelper.h"

@interface SBGoogleAnalyticsHelper : GoogleAnalyticsHelper

+ (void) reportScreenToAnalyticsWithName: (NSString*) screenName;
+ (void) userLikedRecipeName: (NSString*) recipeName;
+ (void) userDislikedRecipeName: (NSString*) recipeName;
+ (void) userEnableAnalytics;
+ (void) userDisablesAnalytics;
+ (void) userStartedPurchasingProcessOf: (NSString*) purchaseName;
+ (BOOL) isAnalyticsEnabled;

@end
