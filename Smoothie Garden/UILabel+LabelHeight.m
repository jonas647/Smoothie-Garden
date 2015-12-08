//
//  UILabel+LabelHeight.m
//  Smoothie Box
//
//  Created by Jonas C Björkell on 2015-12-06.
//  Copyright © 2015 Jonas C Björkell. All rights reserved.
//

#import "UILabel+LabelHeight.h"

@implementation UILabel (LabelHeight)


+ (UILabel*) labelHeight_heightForLabelWithFont: (UIFont*) font andText: (NSString*) text andWidth:(float)width {
    
    UILabel *newLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, width, CGFLOAT_MAX)];
    newLabel.numberOfLines = 0;
    newLabel.lineBreakMode = NSLineBreakByWordWrapping;
    newLabel.text = text;
    newLabel.font = font;
    [newLabel sizeToFit];
    
    return newLabel;
}

@end
