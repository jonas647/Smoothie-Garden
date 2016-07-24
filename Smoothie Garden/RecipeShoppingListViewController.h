//
//  RecipeShoppingListViewController.h
//  Smoothie Box
//
//  Created by Jonas C Björkell on 2016-07-23.
//  Copyright © 2016 Jonas C Björkell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Recipe.h"

@interface RecipeShoppingListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

{
    NSMutableArray *ingredients;
    
}

@property (strong, nonatomic) Recipe *selectedRecipe;;
@property (weak, nonatomic) IBOutlet UIImageView *recipeImageView;
@property (weak, nonatomic) IBOutlet UITableView *shoppingListTableView;

- (IBAction)addIngredientsToShoppingList:(id)sender;

@end
