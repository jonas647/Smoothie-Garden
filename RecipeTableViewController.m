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
#import "ArchivingObject.h"
#import <QuartzCore/QuartzCore.h>

#define CELL_HEIGHT 176

#define TAB_BAR_ALL 1000
#define TAB_BAR_FAV 1001

@interface RecipeTableViewController ()


@end

@implementation RecipeTableViewController
{
    Recipe *selectedRecipe;
    ArchivingObject *archiveHelper;
}




- (void)viewDidLoad {
    [super viewDidLoad];
    
    
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
    
    //Setup the archiving object
    archiveHelper = [[ArchivingObject alloc]init];
    
    //Remove the title text from the back button
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    
    
}

- (void) viewDidAppear:(BOOL)animated {
    
    //Validate on what tab bar item is chosen to select what data to show
    //This must be in view did appear as the selected index isn't set in the view will appear
    
    self.recipes = [self recipesFromPlist];
    
    [self setupSearchController];
    
    //Reload the view to get the proper recipes showing (favorites can change)
    [self.tableView reloadData];
    
    //Set the starting point for the scroller view below the search bar
    //self.tableView.contentInset = UIEdgeInsetsMake(-40.0f, 0.0f, 0.0f, 0.0);
    
}

#pragma mark - Select Recipes

- (NSArray*) recipesFromPlist {
    
    switch ([self selectedTabBar]) {
        case TAB_BAR_ALL:
            //Show all recipes
            return [self allRecipesFromPlist];
            break;
        case TAB_BAR_FAV:
            //Show the favorite recipes
            return [self favoriteRecipes];
            break;
        default:
            break;
    }
    
    return nil;
}

- (int) selectedTabBar {
    
    switch ([self.tabBarController selectedIndex]) {
        case 0:
            //Show all recipes
            return TAB_BAR_ALL;
            break;
        case 1:
            //Show the favorite recipes
            return TAB_BAR_FAV;
            break;
        default:
            return 0;
            break;
    }
    
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
    NSArray *favoriteRecipes = [archiveHelper favoriteRecipes];
    NSMutableArray *tempFavoriteRecipes = [[NSMutableArray alloc]init];
    
    //Iterate all recipes and match with the names saved as favorites to get all favorite recipes to a new array
    for (Recipe *tempRecipe in [self allRecipesFromPlist]) {
        
        for (NSString *tempName in favoriteRecipes) {
            if ([tempRecipe.recipeName isEqualToString:tempName]) {
                [tempFavoriteRecipes addObject:tempRecipe];
            }
        }
        
    }
    
    NSArray *favoritesToReturn = [NSArray arrayWithArray:tempFavoriteRecipes];
    return favoritesToReturn;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Search bar

- (void) setupSearchController {
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    
    self.searchController.searchBar.delegate = self;
    self.searchController.delegate = self;
    
    self.tableView.tableHeaderView = self.searchController.searchBar;
    self.definesPresentationContext = YES;
    [self.searchController.searchBar sizeToFit];
    
}

#pragma mark - Search bar delegate
- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope
{
    [self updateSearchResultsForSearchController:self.searchController];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

#pragma mark - UISearchControllerDelegate

// Called after the search controller's search bar has agreed to begin editing or when
// 'active' is set to YES.
// If you choose not to present the controller yourself or do not implement this method,
// a default presentation is performed on your behalf.
//
// Implement this method if the default presentation is not adequate for your purposes.
//
- (void)presentSearchController:(UISearchController *)searchController {
    //self.searchController.active = NO;
}

- (void)willPresentSearchController:(UISearchController *)searchController {
    // do something before the search controller is presented
}

- (void)didPresentSearchController:(UISearchController *)searchController {
    // do something after the search controller is presented
}

- (void)willDismissSearchController:(UISearchController *)searchController {
    // do something before the search controller is dismissed
}

- (void)didDismissSearchController:(UISearchController *)searchController {
    // do something after the search controller is dismissed
    
    self.recipes = [self recipesFromPlist];
    [self.tableView reloadData];
}

#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    //Get the search text
     NSString *searchText = searchController.searchBar.text;
    
    // strip out all the leading and trailing spaces
    NSString *strippedString = [searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    // break up the search terms (separated by spaces)
    NSArray *searchItems = nil;
    if (strippedString.length > 0) {
        searchItems = [strippedString componentsSeparatedByString:@" "];
    }
    
    //Get the recipes to search among
    NSArray *recipeSearch = [self recipesFromPlist];
    
    //
    //Start with searching for the recipe titles
    //
    
    //Iterate all recipes and save the titles in a new array
    NSMutableArray *searchResults = [[NSMutableArray alloc]init];
    for (Recipe *r in recipeSearch) {
        [searchResults addObject:r.recipeName];
    }
    
    //Match with the search titles
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains[c] %@",searchText]; // if you need case sensitive search avoid '[c]' in the predicate
    
    NSArray *recipeTitleResults = [searchResults filteredArrayUsingPredicate:predicate];
    
    //Iterate the results to find the recipes that match
    NSMutableArray *filteredRecipes = [[NSMutableArray alloc]init];
    for (NSString *title in recipeTitleResults) {
        for (Recipe *tempRecipe in recipeSearch) {
            if ([tempRecipe.recipeName isEqualToString:title]) {
                [filteredRecipes addObject:tempRecipe];
                
            }
        }
    }
    
    //
    //Then search for the ingredients
    //
    
    //Loop all the recipes and find the ones with recipes that match the search string
    for (Recipe *tempRecipe in recipeSearch) {
        
        //Validate the ingredients array to the predicate and see if it contains the search term. If it does add the recipe to the filtered recipes
        
        NSArray *matchedIngredients = [tempRecipe.ingredients filteredArrayUsingPredicate:predicate];
        if (matchedIngredients.count>0) {
            //Add to the filtered recipes if it isn't already added
            if (![filteredRecipes containsObject:tempRecipe]) {
                [filteredRecipes addObject:tempRecipe];
                
            }
        }
        
    }
    
    // hand over the filtered results to our search results table
    if (searchText.length>0) {
        self.recipes = filteredRecipes;
    } else {
        self.recipes = [self recipesFromPlist];
    }
    
    [self.tableView reloadData];
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
    return [self.recipes count];
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
    
    Recipe *recipeForRow = [self.recipes objectAtIndex:indexPath.row];
    titel.text = recipeForRow.recipeName;
    desc.text = recipeForRow.recipeDescription;
    imv.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", recipeForRow.imageName]];
    
    
    //Check if the IAP has been purchased and if recipes should be unlocked
    
    
    if (recipeForRow.recipeCategory==1) {
        //Recipe Category 0 means that it's free
        //Recipe Category 1 means that it's locked
        
        float alphaValue = 0.18;
        [imv setAlpha:alphaValue];
        [titel setAlpha:alphaValue];
        [desc setAlpha:alphaValue];
        
    }
    
    
    return cell;
}

#pragma mark - Table view data delegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Recipe* selRecipe = (Recipe*)[self.recipes objectAtIndex:indexPath.row];
    
    if (selRecipe.recipeCategory == 0) {
        [self performSegueWithIdentifier:@"showRecipeSegue" sender:[self.tableView cellForRowAtIndexPath:indexPath]];
    } else if (selRecipe.recipeCategory == 1) {
        //Create UIAlertView and ask the user if he wants to purchase the recipes
        
        [self performSegueWithIdentifier:@"InAppPurchaseSegue" sender:[self.tableView cellForRowAtIndexPath:indexPath]];
        /*
        NSString *alertTitle = @"Locked Recipe";
        NSString *alertMessage = @"Start a healthy lifestyle by unlocking all recipes for $2.99";
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:alertTitle
                                              message:alertMessage
                                              preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction
                                       actionWithTitle:NSLocalizedString(@"Not yet", @"Cancel action")
                                       style:UIAlertActionStyleCancel
                                       handler:^(UIAlertAction *action)
                                       {
                                           NSLog(@"Cancel action");
                                       }];
        
        UIAlertAction *purchaseAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"Purchase", @"OK action")
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                       NSLog(@"OK action");
                                   }];
        
        [alertController addAction:cancelAction];
        [alertController addAction:purchaseAction];
        
        [self presentViewController:alertController animated:YES completion:nil];*/
    }
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return YES - we will be able to delete all rows
    if ([self selectedTabBar]==TAB_BAR_FAV) {
        return YES;
    } else
        return NO;
    
}

// Support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Perform the real delete action here. Note: you may need to check editing style
    //   if you do not perform delete only.
    
    //Remove the recipe from favorites
    [archiveHelper removeRecipeFromFavorites:[self.recipes objectAtIndex:indexPath.row]];
    
    //Set the new favorite recipe list
    self.recipes = [self recipesFromPlist];
    
    //Reload the table so that the recipe disappears
    [self.tableView reloadData];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    //If the view is scrolled
    
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
    
    if ([segue.destinationViewController isKindOfClass:[DetailedRecipeViewController class]]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        
        DetailedRecipeViewController *vcToPushTo = (DetailedRecipeViewController*)segue.destinationViewController;
        vcToPushTo.selectedRecipe = [self.recipes objectAtIndex:indexPath.row];
    
    }
    
}


@end
