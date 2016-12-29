//
//  DetoxTableViewCell.m
//  Smoothie Box
//
//  Created by Jonas C Björkell on 2016-01-16.
//  Copyright © 2016 Jonas C Björkell. All rights reserved.
//

#import "DetoxTableViewCell.h"

@implementation DetoxTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor colorWithRed:255.0f/255.0f green:250.0f/255.0f blue:250.0f/255.0f alpha:1.0f];
    [self setSelectedBackgroundView:bgColorView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
