//
//  RecipeImageViewController.h
//  Smoothie Box
//
//  Created by Jonas C Björkell on 2016-10-11.
//  Copyright © 2016 Jonas C Björkell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Recipe.h"

@interface RecipeImageViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *recipeImage;
@property (nonatomic, strong) Recipe *selectedRecipe;

@end
