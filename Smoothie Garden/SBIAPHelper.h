//
//  SBIAPHelper.h
//  Smoothie Box
//
//  Created by Jonas C Björkell on 2015-11-15.
//  Copyright © 2015 Jonas C Björkell. All rights reserved.
//

#import "IAPHelper.h"

@interface SBIAPHelper : IAPHelper

+ (SBIAPHelper *)sharedInstance;
- (void) unlockIAP: (NSString*) iapString;
- (BOOL) isIAPUnlocked:(NSString*) iapString;

@end
