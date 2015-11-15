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

@end
