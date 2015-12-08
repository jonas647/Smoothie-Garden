//
//  UIFont+FontSizeBasedOnScreenSize.m
//  Smoothie Box
//
//  Created by Jonas C Björkell on 2015-12-06.
//  Copyright © 2015 Jonas C Björkell. All rights reserved.
//

#define LABEL_SIZE_LARGE 1
#define LABEL_SIZE_SMALL 2
#define LABEL_SIZE_TINY 3

#import "UIFont+FontSizeBasedOnScreenSize.h"

@implementation UIFont (FontSizeBasedOnScreenSize)

- (UIFont*) fontSizeBasedOnScreenSize_fontBasedOnScreenSizeForFont:(UIFont*) font withSize: (int) size {
    //Update label size based on device type
    
    float screenHeight = [UIScreen mainScreen].bounds.size.height;
    float largeLabelSize = 15;
    float smallLabelSize = 12;
    float tinyLabelSize = 8;
    
    if (screenHeight == 480) {
        // iPhone 4
        largeLabelSize = 14;
        smallLabelSize = 11;
        tinyLabelSize = 8;
        
    } else if (screenHeight == 568) {
        // IPhone 5
        largeLabelSize = 14;
        smallLabelSize = 11;
        tinyLabelSize = 8;
        
    } else if (screenHeight == 667) {
        // iPhone 6
        largeLabelSize = 24;
        smallLabelSize = 16;
        tinyLabelSize = 12;
        
    } else if (screenHeight == 736) {
        // iPhone 6+
        largeLabelSize = 30;
        smallLabelSize = 20;
        tinyLabelSize = 14;
    } else
        NSLog(@"no recognised phone for height: %f", screenHeight);
    
    switch (size) {
        case LABEL_SIZE_SMALL:
            return [UIFont fontWithName:font.fontName size:smallLabelSize];
            break;
        case LABEL_SIZE_LARGE:
            return [UIFont fontWithName:font.fontName size:largeLabelSize];
            break;
        case LABEL_SIZE_TINY:
            return [UIFont fontWithName:font.fontName size:tinyLabelSize];
        default:
            NSLog(@"No size for: %i", size);
            return [UIFont fontWithName:font.fontName size:12.0f];; //Just return reasonable value
            break;
    }
}

@end
