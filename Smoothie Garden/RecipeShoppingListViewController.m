//
//  RecipeShoppingListViewController.m
//  Smoothie Box
//
//  Created by Jonas C Björkell on 2016-07-23.
//  Copyright © 2016 Jonas C Björkell. All rights reserved.
//

#import "RecipeShoppingListViewController.h"
#import "ShoppingList.h"

@interface RecipeShoppingListViewController ()

@end

@implementation RecipeShoppingListViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    ingredients = [NSMutableArray arrayWithArray:_selectedRecipe.ingredients];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    _recipeImageView.image = [UIImage imageNamed:_selectedRecipe.imageName];
    
    NSLog(@"Image: %@", _selectedRecipe.recipeName);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ingredients.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellIdentifier = @"ingredientCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    if ([cellIdentifier isEqualToString:@"ingredientCell"]) {
        UILabel *ingredientTitle = (UILabel*)[cell viewWithTag:101];
        UILabel *ingredientVolume = (UILabel*)[cell viewWithTag:102];
        
        Ingredient *activeIngredient = [ingredients objectAtIndex:indexPath.row];
        
        ingredientTitle.text = [activeIngredient stringWithIngredientText];
        ingredientVolume.text = [activeIngredient stringWithQuantityAndMeasure];
    }
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code here for when you hit delete
        [ingredients removeObjectAtIndex:indexPath.row];
        [_shoppingListTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
    }
}

- (IBAction)addIngredientsToShoppingList:(id)sender {
    
    //Add the ingredients to shopping list
    
    [[ShoppingList sharedInstance] addShoppingListItems:ingredients];
    
    //Should run an animation and then pop the view controller
    
    //Pop the viewcontroller from the navigation tree
    [self.navigationController popViewControllerAnimated:YES];
}

@end
