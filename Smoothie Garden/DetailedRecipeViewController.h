//
//  DetailedRecipeViewController.h
//  Smoothie Garden
//
//  Created by Jonas C Björkell on 2015-08-09.
//  Copyright (c) 2015 Jonas C Björkell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Recipe.h"

@interface DetailedRecipeViewController : UIViewController <UIScrollViewDelegate>
{
    __weak IBOutlet UIView *contentView;
    
    __weak IBOutlet UIView *statusbarBackground;
    __weak IBOutlet UIView *titleBackground;
    __weak IBOutlet UITableView *ingredientsTableView;
    __weak IBOutlet UILabel *titleName;
    __weak IBOutlet UIView *recipeImageView;
    
    __weak IBOutlet NSLayoutConstraint *ingredientsHeightConstraint;
    __weak IBOutlet NSLayoutConstraint *recipeTableViewHeightConstraint;
    
    __weak IBOutlet UIView *likeView;
    __weak IBOutlet UITableView *recipeTableView;
    
    
    __weak IBOutlet NSLayoutConstraint *recipeImageViewHeight;
    __weak IBOutlet NSLayoutConstraint *blankBackgroundToTop;
    
    __weak IBOutlet UITableView *longDescriptionTable;
    __weak IBOutlet NSLayoutConstraint *longDescriptionTableHeightConstraint;
    
    __weak IBOutlet UIView *servingView;
    
    __weak IBOutlet UIButton *shoppingListButton;
}

@property (nonatomic, strong) Recipe *selectedRecipe;

//- (IBAction)likeRecipe:(id)sender;

@end
