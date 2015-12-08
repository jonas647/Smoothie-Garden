//
//  UILabel+LabelHeight.h
//  Smoothie Box
//
//  Created by Jonas C Björkell on 2015-12-06.
//  Copyright © 2015 Jonas C Björkell. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (LabelHeight)

+ (UILabel*) labelHeight_heightForLabelWithFont: (UIFont*) font andText: (NSString*) text andWidth: (float) width;

@end
