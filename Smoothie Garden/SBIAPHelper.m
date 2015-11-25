//
//  SBIAPHelper.m
//  Smoothie Box
//
//  Created by Jonas C Björkell on 2015-11-15.
//  Copyright © 2015 Jonas C Björkell. All rights reserved.
//

#import "SBIAPHelper.h"

@implementation SBIAPHelper

+ (SBIAPHelper*)sharedInstance {
    static dispatch_once_t once;
    static SBIAPHelper * sharedInstance;
    dispatch_once(&once, ^{
        NSSet * productIdentifiers = [NSSet setWithObjects:
                                      @"basicRecipes_01",
                                      nil];
        sharedInstance = [[self alloc] initWithProductIdentifiers:productIdentifiers];
    });
    return sharedInstance;
}

#pragma mark - IAP

- (void) unlockIAP:(NSString *)iapString {
    
    //Save to nsuserdefault that the iap names as the string should be unlocked
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:iapString];
    
}

- (BOOL) isIAPUnlocked:(NSString*) iapString {
    
    //Get the iap name from the nsuserdefault and return the YES/NO for that
    return [[NSUserDefaults standardUserDefaults] boolForKey:iapString];
    
}

@end
