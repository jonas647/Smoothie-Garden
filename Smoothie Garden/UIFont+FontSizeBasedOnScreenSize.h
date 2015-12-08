//
//  UIFont+UIFont_FontSizeBasedOnScreenSize.h
//  Smoothie Box
//
//  Created by Jonas C Björkell on 2015-12-06.
//  Copyright © 2015 Jonas C Björkell. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (FontSizeBasedOnScreenSize)

- (UIFont*) fontSizeBasedOnScreenSize_fontBasedOnScreenSizeForFont:(UIFont*) font withSize: (int) size;

@end
