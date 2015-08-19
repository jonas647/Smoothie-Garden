//
//  RecipeTableViewCell.h
//  Smoothie Garden
//
//  Created by Jonas C Björkell on 2015-08-06.
//  Copyright (c) 2015 Jonas C Björkell. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecipeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *recipeImage;
@property (weak, nonatomic) IBOutlet UILabel *recipeTitle;

@end
