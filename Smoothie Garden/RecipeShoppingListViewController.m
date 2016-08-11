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
    
    //Just add the ingredients with a name (there are blanks to add a space between sauce and smoothie ie.)
    ingredients = [[NSMutableArray alloc]init];
    for (Ingredient *i in _selectedRecipe.ingredients) {
        if (![i.type isEqualToString:@""]) {
            [ingredients addObject:i];
        }
    }
    
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    _recipeImageView.image = [UIImage imageNamed:_selectedRecipe.imageName];
    
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
        
        UIButton *removeIngredientButton = (UIButton*)[cell viewWithTag:103];
        removeIngredientButton.tag=indexPath.row;
        [removeIngredientButton addTarget:self
                   action:@selector(removeIngredientFromShoppingList:) forControlEvents:UIControlEventTouchUpInside];
        
        Ingredient *activeIngredient = [ingredients objectAtIndex:indexPath.row];
        
        ingredientTitle.text = [activeIngredient stringWithIngredientText];
        ingredientVolume.text = [activeIngredient stringWithQuantityAndMeasure];
        
        UIView *buttonView = [cell viewWithTag:104];
        UIView *circleView = [buttonView viewWithTag:1001];
        
        //Set the attributes for the remove button
        circleView.layer.cornerRadius = circleView.bounds.size.width/2;//Make like view a circle
        circleView.layer.masksToBounds = YES;
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

- (void) removeIngredientFromShoppingList:(id)sender {
    
    CGPoint hitPoint = [sender convertPoint:CGPointZero toView:_shoppingListTableView];
    NSIndexPath *hitIndex = [_shoppingListTableView indexPathForRowAtPoint:hitPoint];
    
    [ingredients removeObjectAtIndex:hitIndex.row];
    
    //Update table
    [_shoppingListTableView reloadData];
}

@end
