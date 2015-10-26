//
//  RecipeTableViewCell.h
//  Smoothie Garden
//
//  Created by Jonas C Björkell on 2015-10-25.
//  Copyright © 2015 Jonas C Björkell. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecipeTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *recipeImage;
@property (weak, nonatomic) IBOutlet UILabel *recipeTitle;
@property (weak, nonatomic) IBOutlet UITextView *recipeDescription;

@end
