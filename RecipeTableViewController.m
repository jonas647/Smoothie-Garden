//
//  RecipeTableViewController.m
//  Smoothie Garden
//
//  Created by Jonas C Björkell on 2015-08-06.
//  Copyright (c) 2015 Jonas C Björkell. All rights reserved.
//

#import "RecipeTableViewController.h"
#import "DetailedRecipeViewController.h"
#import "Recipe.h"
#import "SWRevealViewController.h"
#import <QuartzCore/QuartzCore.h>

#define CELL_HEIGHT 176

@interface RecipeTableViewController ()


@end

@implementation RecipeTableViewController
{
    NSArray *recipes;
    Recipe *selectedRecipe;
}




- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Validate on what tab bar item is chosen to select what data to show
    switch ([self.tabBarController selectedIndex]) {
        case 0:
            //Show all recipes
            recipes = [self allRecipesFromPlist];
            break;
        case 1:
            //Show the favorite recipes
            recipes = [self favoriteRecipes];
            break;
        default:
            break;
    }
    
    NSLog(@"Number of loaded recipes: %i", (int)recipes.count);
    NSLog(@"Selected tab bar: %lu", (unsigned long)[self.tabBarController selectedIndex]);
    
    self.tableView.sectionHeaderHeight = 0.0;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
    //self.navigationController.hidesBarsOnSwipe = true;
    
    //Set the target for the main menu button
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.sideBarButton setTarget: self.revealViewController];
        [self.sideBarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    
}

#pragma mark - Load Recipes
- (NSArray*) allRecipesFromPlist {

    NSString *filepath = [[NSBundle mainBundle] pathForResource:@"Recipes" ofType:@"plist"];
    NSDictionary *recipeDictionary = [NSDictionary dictionaryWithContentsOfFile:filepath];
    
    NSMutableArray *tempRecipes = [[NSMutableArray alloc] init];

    for (NSString *name in recipeDictionary) {
        Recipe *newRecipe = [[Recipe alloc]init];
        NSMutableArray *tempIngredients = [[NSMutableArray alloc]init];
        
        [newRecipe setRecipeType:[[[recipeDictionary objectForKey:name] objectForKey:@"RecipeType"]intValue]];
        [newRecipe setRecipeCategory:[[[recipeDictionary objectForKey:name] objectForKey:@"RecipeCategory"]intValue]];
        [newRecipe setRecipeName:[[recipeDictionary objectForKey:name] objectForKey:@"RecipeName"]];
        [newRecipe setImageName:[[recipeDictionary objectForKey:name] objectForKey:@"ImageName"]];
        [newRecipe setRecipeDescription:[[recipeDictionary objectForKey:name] objectForKey:@"RecipeDescription"]];
        [newRecipe setDetailedRecipedescription:[[recipeDictionary objectForKey:name] objectForKey:@"DetailedRecipeDescription"]];
        [newRecipe setBoosterDescription:[[recipeDictionary objectForKey:name] objectForKey:@"BoosterDescription"]];
        
        for (NSString *ingredient in [[recipeDictionary objectForKey:name] objectForKey:@"Ingredients"]) {
            [tempIngredients addObject:ingredient];
        }
        
        newRecipe.ingredients  = [tempIngredients copy];
        
        [tempRecipes addObject:newRecipe];
    }
    
    return tempRecipes;

}

- (NSArray*) favoriteRecipes {
    
    //Load the favorite recipes array
    NSArray *favoriteRecipes = [[NSUserDefaults standardUserDefaults]arrayForKey:@"FavoriteRecipes"];
    NSMutableArray *tempFavoriteRecipes = [[NSMutableArray alloc]init];
    
    //Iterate all recipes and match with the names saved as favorites to get all favorite recipes to a new array
    for (Recipe *tempRecipe in [self allRecipesFromPlist]) {
        
        for (NSString *tempName in favoriteRecipes) {
            if ([tempRecipe.recipeName isEqualToString:tempName]) {
                [tempFavoriteRecipes addObject:tempRecipe];
            }
        }
        
    }
    
    NSLog(@"Returning favorite recipes: %@", tempFavoriteRecipes);
    NSArray *favoritesToReturn = [NSArray arrayWithArray:tempFavoriteRecipes];
    return favoritesToReturn;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [recipes count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *tableCellIdentifier = @"RecipeTableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableCellIdentifier];
    
    
    // Configure the cell...
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableCellIdentifier];
    }
    
    
    //Dummy code to just show different images
    
    UIImageView *imv = (UIImageView *)[cell viewWithTag:100];
    UILabel *titel = (UILabel *)[cell viewWithTag:101];
    UITextView *desc = (UITextView *)[cell viewWithTag:102];
    
    Recipe *recipeForRow = [recipes objectAtIndex:indexPath.row];
    titel.text = recipeForRow.recipeName;
    desc.text = recipeForRow.recipeDescription;
    imv.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", recipeForRow.imageName]];
    
    
    
    return cell;
}

/*
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Chose row: %li", indexPath.row);
    
    selectedRecipe = [recipes objectAtIndex:indexPath.row];
    
    
    [self performSegueWithIdentifier: @"DetailedRecipeSegue" sender: self];
    
}*/

/*
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return CELL_HEIGHT;
    
}*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    
    DetailedRecipeViewController *vcToPushTo = (DetailedRecipeViewController*)segue.destinationViewController;
    vcToPushTo.selectedRecipe = [recipes objectAtIndex:indexPath.row];
    
    Recipe *tempRecipe = (Recipe*) [recipes objectAtIndex:indexPath.row];
    
    NSLog(@"Recipes: %@", tempRecipe.ingredients);
    
    
}


@end
