//
//  ContentHeightTextView.m
//  Smoothie Garden
//
//  Created by Jonas C Björkell on 2015-09-15.
//  Copyright (c) 2015 Jonas C Björkell. All rights reserved.
//

#import "ContentHeightTextView.h"

@implementation ContentHeightTextView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize size = [self sizeThatFits:CGSizeMake(self.bounds.size.width, FLT_MAX)];
    
    if (!self.heightConstraint) {
        self.heightConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1.0f constant:size.height];
        [self addConstraint:self.heightConstraint];
    }
    
    self.heightConstraint.constant = size.height;
    
    [super layoutSubviews];
}

@end
