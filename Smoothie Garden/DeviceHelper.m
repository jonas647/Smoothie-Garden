//
//  DeviceHelper.m
//  Smoothie Box
//
//  Created by Jonas C Björkell on 2016-03-30.
//  Copyright © 2016 Jonas C Björkell. All rights reserved.
//

//Change to this in the future
//TODO
/*
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))
#define IS_ZOOMED (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)
*/

#define IPHONE_4        @[@"iPhone 4",@"Verizon iPhone 4",@"iPhone 4S"]
#define IPHONE_5        @[@"iPhone 5 (GSM)",@"iPhone 5 (GSM+CDMA)",@"iPhone 5c (GSM)",@"iPhone 5c (GSM+CDMA)",@"iPhone 5s (GSM)",@"iPhone 5s (GSM+CDMA)", @"iPhone SE"]
#define IPHONE_6        @[@"iPhone 6", @"iPhone 6s", @"iPhone 7", @"iPhone9,3"]
#define IPHONE_6PLUS    @[@"iPhone 6 Plus", @"iPhone 6s Plus", @"iPhone 7 Plus"]
#define IPAD            @[@"iPad",@"iPad 2 (WiFi)",@"iPad 2 (GSM)",@"iPad 2 (CDMA)",@"iPad 2 (WiFi)",@"iPad Mini (WiFi)",@"iPad Mini (GSM)",@"iPad Mini (GSM+CDMA)",@"iPad 3 (WiFi)",@"iPad 3 (GSM+CDMA)",@"iPad 3 (GSM)",@"iPad 4 (WiFi)",@"iPad 4 (GSM)",@"iPad 4 (GSM+CDMA)",@"iPad Air (WiFi)",@"iPad Air (Cellular)",@"iPad Air",@"iPad Mini 2G (WiFi)",@"iPad Mini 2G (Cellular)",@"iPad Mini 2G",@"iPad Mini 3 (WiFi)",@"iPad Mini 3 (Cellular)",@"iPad Mini 3 (China)",@"iPad Air 2 (WiFi)",@"iPad Air 2 (Cellular)"]

#import "DeviceHelper.h"
#import <sys/sysctl.h>

@implementation DeviceHelper {
    
}

+ (DeviceHelper*)sharedInstance {
    static dispatch_once_t once;
    static DeviceHelper * sharedInstance;
    dispatch_once(&once, ^{
        
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (NSString *) platformType:(NSString *)platform
{
    if ([platform isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([platform isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,3"])    return @"Verizon iPhone 4";
    if ([platform isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([platform isEqualToString:@"iPhone5,1"])    return @"iPhone 5 (GSM)";
    if ([platform isEqualToString:@"iPhone5,2"])    return @"iPhone 5 (GSM+CDMA)";
    if ([platform isEqualToString:@"iPhone5,3"])    return @"iPhone 5c (GSM)";
    if ([platform isEqualToString:@"iPhone5,4"])    return @"iPhone 5c (GSM+CDMA)";
    if ([platform isEqualToString:@"iPhone6,1"])    return @"iPhone 5s (GSM)";
    if ([platform isEqualToString:@"iPhone6,2"])    return @"iPhone 5s (GSM+CDMA)";
    if ([platform isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([platform isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([platform isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([platform isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    if ([platform isEqualToString:@"iPhone8,4"])    return @"iPhone SE";
    if ([platform isEqualToString:@"iPhone9,1"])    return @"iPhone 7";
    if ([platform isEqualToString:@"iPhone9,3"])    return @"iPhone 7";
    if ([platform isEqualToString:@"iPhone9,2"])    return @"iPhone 7 Plus";
    if ([platform isEqualToString:@"iPhone9,4"])    return @"iPhone 7 Plus";
    if ([platform isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([platform isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([platform isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([platform isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([platform isEqualToString:@"iPod5,1"])      return @"iPod Touch 5G";
    if ([platform isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([platform isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([platform isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([platform isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([platform isEqualToString:@"iPad2,4"])      return @"iPad 2 (WiFi)";
    if ([platform isEqualToString:@"iPad2,5"])      return @"iPad Mini (WiFi)";
    if ([platform isEqualToString:@"iPad2,6"])      return @"iPad Mini (GSM)";
    if ([platform isEqualToString:@"iPad2,7"])      return @"iPad Mini (GSM+CDMA)";
    if ([platform isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi)";
    if ([platform isEqualToString:@"iPad3,2"])      return @"iPad 3 (GSM+CDMA)";
    if ([platform isEqualToString:@"iPad3,3"])      return @"iPad 3 (GSM)";
    if ([platform isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([platform isEqualToString:@"iPad3,5"])      return @"iPad 4 (GSM)";
    if ([platform isEqualToString:@"iPad3,6"])      return @"iPad 4 (GSM+CDMA)";
    if ([platform isEqualToString:@"iPad4,1"])      return @"iPad Air (WiFi)";
    if ([platform isEqualToString:@"iPad4,2"])      return @"iPad Air (Cellular)";
    if ([platform isEqualToString:@"iPad4,3"])      return @"iPad Air";
    if ([platform isEqualToString:@"iPad4,4"])      return @"iPad Mini 2G (WiFi)";
    if ([platform isEqualToString:@"iPad4,5"])      return @"iPad Mini 2G (Cellular)";
    if ([platform isEqualToString:@"iPad4,6"])      return @"iPad Mini 2G";
    if ([platform isEqualToString:@"iPad4,7"])      return @"iPad Mini 3 (WiFi)";
    if ([platform isEqualToString:@"iPad4,8"])      return @"iPad Mini 3 (Cellular)";
    if ([platform isEqualToString:@"iPad4,9"])      return @"iPad Mini 3 (China)";
    if ([platform isEqualToString:@"iPad5,3"])      return @"iPad Air 2 (WiFi)";
    if ([platform isEqualToString:@"iPad5,4"])      return @"iPad Air 2 (Cellular)";
    if ([platform isEqualToString:@"AppleTV2,1"])   return @"Apple TV 2G";
    if ([platform isEqualToString:@"AppleTV3,1"])   return @"Apple TV 3";
    if ([platform isEqualToString:@"AppleTV3,2"])   return @"Apple TV 3 (2013)";
    if ([platform isEqualToString:@"i386"])         return @"Simulator";
    if ([platform isEqualToString:@"x86_64"])       return @"Simulator";
    
    return platform;
    
}

- (BOOL) isCurrentPlatform: (NSArray*) devices {
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    
    NSString *currentPlatform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    
    if ([devices containsObject:[self platformType:currentPlatform]]) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL) isDeviceIphone4 {
    
    return [self isCurrentPlatform:IPHONE_4];
    
}

- (BOOL) isDeviceIphone5 {
    
    return [self isCurrentPlatform:IPHONE_5];
    
}

- (BOOL) isDeviceIphone6 {
    
    return [self isCurrentPlatform:IPHONE_6];
    
}

- (BOOL) isDeviceIphone6plus {
    
    return [self isCurrentPlatform:IPHONE_6PLUS];
    
}

- (BOOL) isDeviceIpad {
    
    return [self isCurrentPlatform:IPAD];
    
}

- (BOOL) isDeviceSimulator {
    
    //For testing on simulator
    
    return [self isCurrentPlatform:@[@"Simulator"]];
}


@end
