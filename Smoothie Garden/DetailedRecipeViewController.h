//
//  DetailedRecipeViewController.h
//  Smoothie Garden
//
//  Created by Jonas C Björkell on 2015-08-09.
//  Copyright (c) 2015 Jonas C Björkell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Recipe.h"

@interface DetailedRecipeViewController : UIViewController
{
    __weak IBOutlet UIView *contentView;
    IBOutlet UIScrollView *scrollView;
    
    __weak IBOutlet UITableView *ingredientsTableView;
    __weak IBOutlet UILabel *titleName;
    __weak IBOutlet UIImageView *recipeImage;
    
    __weak IBOutlet UITextView *recipeDescriptionView;
    __weak IBOutlet NSLayoutConstraint *ingredientsHeightConstraint;
    
    __weak IBOutlet NSLayoutConstraint *recipeDescriptionHeightConstraint;
    
    __weak IBOutlet UIButton *likeButton;
    
    __weak IBOutlet UITextView *boosterDescriptionView;
    __weak IBOutlet NSLayoutConstraint *boosterDescriptionHeightConstraint;
    
}

@property (nonatomic, strong) Recipe *selectedRecipe;
- (IBAction)likeRecipe:(id)sender;

@end
