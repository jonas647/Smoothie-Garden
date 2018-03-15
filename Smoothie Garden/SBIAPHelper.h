//
//  SBIAPHelper.h
//  Smoothie Box
//
//  Created by Jonas C Björkell on 2015-11-15.
//  Copyright © 2015 Jonas C Björkell. All rights reserved.
//

//This is not in use right now since no IAP available

#import "IAPHelper.h"

@interface SBIAPHelper : IAPHelper

+ (SBIAPHelper *)sharedInstance;
- (void) unlockIAP: (NSString*) iapString;
- (BOOL) isIAPUnlocked:(NSString*) iapString;

@end
