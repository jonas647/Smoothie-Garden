//
//  RecipeTableViewCell.m
//  Smoothie Garden
//
//  Created by Jonas C Björkell on 2015-10-25.
//  Copyright © 2015 Jonas C Björkell. All rights reserved.
//

#import "RecipeTableViewCell.h"

@implementation RecipeTableViewCell {
    
    float imageParallaxFactor;
    float imgTopInitial;
    float imgBottomInitial;
    
}

- (void)awakeFromNib {
    // Initialization code
    
    //self.clipsToBounds = true;
    self.imageBottomConstraint.constant -= 2 * imageParallaxFactor;
    imgTopInitial = self.imageTopConstraint.constant;
    imgBottomInitial = self.imageBottomConstraint.constant;
    
    imageParallaxFactor = 20;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void) setBackgroundOffset: (float) offset {
    
    float boundOffset = MAX(0, MIN(1, offset));
    
    float pixelOffset = (1-boundOffset)*2*imageParallaxFactor;
    
    self.imageTopConstraint.constant = self.imageTopConstraint.constant - pixelOffset;
    self.imageBottomConstraint.constant = self.imageBottomConstraint.constant + pixelOffset;
    
}


@end
