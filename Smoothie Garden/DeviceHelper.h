//
//  DeviceHelper.h
//  Smoothie Box
//
//  Created by Jonas C Björkell on 2016-03-30.
//  Copyright © 2016 Jonas C Björkell. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceHelper : NSObject

+ (DeviceHelper*)sharedInstance ;
- (BOOL) isDeviceIphone4;
- (BOOL) isDeviceIphone5;
- (BOOL) isDeviceIphone6;
- (BOOL) isDeviceIphone6plus;
- (BOOL) isDeviceIpad;
- (BOOL) isDeviceSimulator;

@end
