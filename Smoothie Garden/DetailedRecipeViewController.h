//
//  DetailedRecipeViewController.h
//  Smoothie Garden
//
//  Created by Jonas C Björkell on 2015-08-09.
//  Copyright (c) 2015 Jonas C Björkell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Recipe.h"

@interface DetailedRecipeViewController : UIViewController <UIScrollViewDelegate, UIGestureRecognizerDelegate>
{
    __weak IBOutlet UIView *contentView;
    
    __weak IBOutlet UIView *topViewArea;
    __weak IBOutlet UIView *statusbarBackground;
    __weak IBOutlet UIView *titleBackground;
    __weak IBOutlet UITableView *ingredientsTableView;
    __weak IBOutlet UILabel *titleName;
    __weak IBOutlet UIImageView *recipeImage;
    
    __weak IBOutlet NSLayoutConstraint *ingredientsHeightConstraint;
    
    
    __weak IBOutlet UILabel *recipeDescription;
    __weak IBOutlet UIButton *likeButton;
    
    __weak IBOutlet UIView *whiteBackground;
    __weak IBOutlet NSLayoutConstraint *whiteBackgroundVerticalPositioningConstraint;
    __weak IBOutlet NSLayoutConstraint *contentViewHeightConstraint;
    __weak IBOutlet UIView *likeView;
    __weak IBOutlet UITableView *recipeTableView;
    __weak IBOutlet NSLayoutConstraint *recipeTableViewHeightConstraint;
    __weak IBOutlet UIView *recipeImageView; //To be able to change z order
    
    __weak IBOutlet UIScrollView *recipeScrollView; //To be able to change z order
    
    
}

@property (nonatomic, strong) Recipe *selectedRecipe;

- (IBAction)likeRecipe:(id)sender;
- (IBAction)nutritionFacts:(id)sender;

@end
