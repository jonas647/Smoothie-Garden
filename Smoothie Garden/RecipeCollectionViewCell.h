//
//  RecipeCollectionViewCell.h
//  Smoothie Box
//
//  Created by Jonas C Björkell on 2016-06-04.
//  Copyright © 2016 Jonas C Björkell. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecipeCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *recipeImage;
@property (weak, nonatomic) IBOutlet UILabel *recipeDescription; //Not used in current layout
@property (weak, nonatomic) IBOutlet UILabel *recipeHeader;
@property (weak, nonatomic) IBOutlet UIButton *likedRecipe;

@end
