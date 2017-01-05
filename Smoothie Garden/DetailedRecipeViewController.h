//
//  DetailedRecipeViewController.h
//  Smoothie Garden
//
//  Created by Jonas C Björkell on 2015-08-09.
//  Copyright (c) 2015 Jonas C Björkell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Recipe.h"
#import "DetailedRecipeViewController.h"

@protocol DetailedRecipeViewControllerDelegate

//- (void) didSelectRecipe: (Recipe*) selectedRecipe;

@end

@interface DetailedRecipeViewController : UIViewController <UIScrollViewDelegate, DetailedRecipeViewControllerDelegate>
{
    __weak IBOutlet UIView *contentView;
    
    __weak IBOutlet UILabel *caloriesText;
    __weak IBOutlet UIView *statusbarBackground;
    __weak IBOutlet UIView *titleBackground;
    __weak IBOutlet UITableView *ingredientsTableView;
    __weak IBOutlet UILabel *titleName;
    __weak IBOutlet UILabel *byText;
    __weak IBOutlet UILabel *smoothieBoxText;
    
    
    __weak IBOutlet UIView *recipeImageView;
    
    __weak IBOutlet NSLayoutConstraint *ingredientsHeightConstraint;
    __weak IBOutlet NSLayoutConstraint *recipeTableViewHeightConstraint;
    
    __weak IBOutlet UIView *likeView;
    __weak IBOutlet UITableView *recipeTableView;
    
    
    __weak IBOutlet NSLayoutConstraint *recipeImageViewHeight;
    
    __weak IBOutlet UITableView *longDescriptionTable;
    __weak IBOutlet NSLayoutConstraint *longDescriptionTableHeightConstraint;
    
    __weak IBOutlet UIButton *shoppingListButton;

    __weak IBOutlet NSLayoutConstraint *titleToTop;
    __weak IBOutlet NSLayoutConstraint *servingsViewToTop;
    
    __weak IBOutlet UICollectionView *nutrientCollectionView;
    __weak IBOutlet NSLayoutConstraint *nutrientCollectionViewHeightConstraint;
    
    
    __weak IBOutlet NSLayoutConstraint *navigationBariPadHeightConstraint;
    
    __weak IBOutlet UIView *titleBackgroundCopy;
    
    __weak IBOutlet UILabel *titleCopy;
    __weak IBOutlet UILabel *byCopy;
    __weak IBOutlet UILabel *smoothieBoxCopy;
    
    
    
}

@property (nonatomic, strong) Recipe *selectedRecipe;


-(void)selectedRecipe:(Recipe *)newRecipe;
-(BOOL)isRecipeLiked;
-(void)likeRecipe;

//- (IBAction)likeRecipe:(id)sender;

@end
