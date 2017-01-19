//
//  DetoxTableViewCell.h
//  Smoothie Box
//
//  Created by Jonas C Björkell on 2016-01-16.
//  Copyright © 2016 Jonas C Björkell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Recipe.h"

@interface DetoxTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *recipeImage;
@property (weak, nonatomic) IBOutlet UILabel *recipeTitle;
@property (weak, nonatomic) IBOutlet UILabel *recipeDescription;
@property (strong, nonatomic) Recipe *selectedRecipe;


@end
