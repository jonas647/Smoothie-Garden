//
//  AppReviewHelper.h
//  Smoothie Box
//
//  Created by Jonas C Björkell on 2015-11-29.
//  Copyright © 2015 Jonas C Björkell. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppReviewHelper : NSObject

+ (BOOL) shouldShowReviewAlert;
+ (void) dontShowAnyMoreReviewAlerts;
+ (void) firstTimeAppLaunch;

@end
