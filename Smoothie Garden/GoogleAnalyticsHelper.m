//
//  GoogleAnalyticsHelper.m
//  Smoothie Box
//
//  Created by Jonas C Björkell on 2015-11-18.
//  Copyright © 2015 Jonas C Björkell. All rights reserved.
//
// Install the Google Analytics SDK
// https://developers.google.com/analytics/devguides/collection/ios/v3/
//

#import "GoogleAnalyticsHelper.h"

@implementation GoogleAnalyticsHelper

+ (GoogleAnalyticsHelper*)sharedInstance {
    static dispatch_once_t once;
    static GoogleAnalyticsHelper * sharedInstance;
    dispatch_once(&once, ^{
        
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

+(void) setupUiViewForTrackingWithName: (NSString*) screenName {
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker set:kGAIScreenName value:screenName];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
}

+ (void) reportEventWithCategory:(NSString *)category andAction:(NSString *)action andLabel:(NSString *)label andValue:(NSNumber *)value {
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:category
                                                          action:action
                                                           label:label
                                                           value:value] build]];
}

+ (void) reportPurchaseWithName:(NSString *)name andPrice:(NSNumber *)price andTransactionId: (NSString*) transactionID {
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    GAIEcommerceProduct *product = [[GAIEcommerceProduct alloc] init];
    [product setName:name];
    [product setPrice:price];
    
    GAIEcommerceProductAction *productAction = [[GAIEcommerceProductAction alloc] init];
    //TODO - uncomment this. But need to have this constant set somewhere?
    //[productAction setAction:kGAIPAPurchase];
    [productAction setTransactionId:transactionID];
    
    GAIDictionaryBuilder *builder = [GAIDictionaryBuilder createScreenView];
    
    // Add the transaction data to the screenview.
    [builder setProductAction:productAction];
    [builder addProduct:product];
    
    // Send the transaction with the screenview.
    [tracker set:kGAIScreenName value:@"In App Store"];
    [tracker send:[builder build]];
    
}

@end
