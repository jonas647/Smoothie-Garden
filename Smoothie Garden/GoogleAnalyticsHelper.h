//
//  GoogleAnalyticsHelper.h
//  Smoothie Box
//
//  Created by Jonas C Björkell on 2015-11-18.
//  Copyright © 2015 Jonas C Björkell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GAI.h"
#import "GAIDictionaryBuilder.h"
#import "GAIFields.h"
#import "GAILogger.h"
#import "GAIEcommerceProduct.h"
#import <UIKit/UIKit.h>

@interface GoogleAnalyticsHelper : NSObject

+(void) setupUiViewForTrackingWithName: (NSString*) screenName;
+(void) reportEventWithCategory:(NSString *)category andAction:(NSString *)action andLabel:(NSString *)label andValue:(NSNumber *)value;
+(void) reportPurchaseWithName:(NSString *)name andPrice:(NSNumber *)price andTransactionId: (NSString*) transactionID;

@end
