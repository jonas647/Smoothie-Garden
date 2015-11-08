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
#import "RecipeTableViewCell.h"

//#define CELL_HEIGHT 176

#define TAB_BAR_ALL 1000
#define TAB_BAR_FAV 1001

@interface RecipeTableViewController ()


@end

@implementation RecipeTableViewController
{
    Recipe *selectedRecipe;
    ArchivingObject *archiveHelper;
    NSMutableDictionary *thumbnailImages;
    NSMutableArray *filteredRecipeArray;
    UIActivityIndicatorView *loadingIndicator;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //TODO
    //Comment out the stuff linked to favorites or use it in another way
    //Perhaps sort by liked recipes first
    
    [self setupActivityIndicator]; //Setup of the activity indicator programmatically
    [self startActivityIndicator];
    
    //This is needed for the reveal controller to work
    SWRevealViewController *revealController = [self revealViewController];
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    
    //Set the target for the main menu button
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.sideBarButton setTarget: self.revealViewController];
        [self.sideBarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    //Adjust the tableview to scroll to top of tapped at top
    self.tableView.scrollsToTop = YES;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //Setup the archiving object
    archiveHelper = [[ArchivingObject alloc]init];
    
    //Remove the title text from the back button (in the Detailed recipe table view controller)
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    //Array for handling the filtered search results
    filteredRecipeArray = [NSMutableArray arrayWithCapacity:[[self recipesFromPlist] count]];
    
}

- (UIImage*) createThumbnailForImageWithName:(NSString *)sourceName {
    
    UIImage* sourceImage = [UIImage imageNamed:sourceName];
    if (!sourceImage) {
        //...
        NSLog(@"Source image is missing: %@", sourceName);
    }
    
    //Size dependent sizing of the thumbnail to make the loading on older devicer quicker
    CGSize thumbnailSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.width*0.8);
    
    UIGraphicsBeginImageContext(thumbnailSize);
    [sourceImage drawInRect:CGRectMake(0,0,thumbnailSize.width,thumbnailSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (void)viewWillAppear:(BOOL)animated {
    
    
    //Reset the navigation bar, set back to being shown
    //Is hidden in the detailed recipe view
    [self.navigationController.navigationBar setBackgroundImage:nil
                                                  forBarMetrics:UIBarMetricsDefault];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    //When the user comes back to the table view after selecting a recipe she should not see the search window
    [self.searchController setActive:NO];
    
}



- (void) viewDidAppear:(BOOL)animated {
    
    //Validate on what tab bar item is chosen to select what data to show
    //This must be in view did appear as the selected index isn't set in the view will appear
    
    self.recipes = [self recipesFromPlist];
    
    [self setupSearchController]; //Setup the search controller programmatically since it's not possible in storyboard
    
    //Set the starting point for the scroller view below the search bar
    //self.tableView.contentInset = UIEdgeInsetsMake(-40.0f, 0.0f, 0.0f, 0.0);
    
    //This will also solve the problem with wrong picture for search result table view
    thumbnailImages = [[NSMutableDictionary alloc]init];
    for (Recipe *r in self.recipes) {
        UIImage *tempImage = [self createThumbnailForImageWithName:r.imageName];
        [thumbnailImages setObject:tempImage forKey:r.recipeName];
    }
    
    //Reload the view to get the proper recipes showing (favorites can change)
    [self.tableView reloadData];
    
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

#pragma mark - Activity indicator for loading

- (void) setupActivityIndicator {
    
    loadingIndicator = [[UIActivityIndicatorView alloc]init];
    
    [loadingIndicator setFrame:CGRectMake(0,0, self.view.frame.size.width/3, self.view.frame.size.width/3)];
    [loadingIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [loadingIndicator setCenter:self.view.center];
    loadingIndicator.hidden = NO;
    [self.view addSubview:loadingIndicator];
    [self.view bringSubviewToFront:loadingIndicator];
    
   
}

- (void) startActivityIndicator {
    
    [loadingIndicator startAnimating];
    [loadingIndicator setBackgroundColor:[UIColor whiteColor]];
    
    
}

- (void) stopActivityIndicator {
    
    [loadingIndicator stopAnimating];
    [loadingIndicator setHidesWhenStopped:YES];
}


#pragma mark - Search bar

- (void) setupSearchController {
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.hidesNavigationBarDuringPresentation = YES;
    
    self.searchController.searchBar.delegate = self;
    self.searchController.delegate = self;
    
    //Set the background color of the search bar to a lighter color
    
    [self.searchController.searchBar setTintColor:[UIColor darkGrayColor]];
    [self.searchController.searchBar setBarTintColor:[UIColor whiteColor]];
    
    [self.searchController.searchBar setAlpha:1.0];
    
    self.searchController.searchBar.placeholder = @"Search for ingredients or smoothie title";

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
    
    //Called when the search result should be updated
    
    //Get the search text
     NSString *searchText = searchController.searchBar.text;
    
    //Get the recipes to search among
    //TODO, should not get a new list every time, instead have a current list to work with
    NSMutableArray *recipeSearch = (NSMutableArray*)[self recipesFromPlist];
    
    //
    //Start with searching for the recipe titles
    //
    
    //Iterate all recipes and save the titles in a new array
    //Save the recipe name and not the recipe itself since that's what the user searches for
    NSMutableArray *searchResults = [[NSMutableArray alloc]init];
    for (Recipe *r in recipeSearch) {
        [searchResults addObject:r.recipeName];
    }
    
    //An array that holds all the recipe titles that matches the user search
    
    //For the search string, check if that word matches a recipe title
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains[c] %@",searchText]; // if you need case sensitive search avoid '[c]' in the predicate
    NSArray *tempRecipeTitles = [searchResults filteredArrayUsingPredicate:predicate];
    
    //Iterate the results to find the actual recipe for that string
    NSMutableArray *filteredRecipes = [[NSMutableArray alloc]init];
    for (NSString *title in tempRecipeTitles) {
        for (Recipe *tempRecipe in recipeSearch) {
            if ([tempRecipe.recipeName isEqualToString:title]) {
                [filteredRecipes addObject:tempRecipe];
            }
        }
    }
    
    //Remove the found recipes from the recipeSearch so that it only contains recipes that aren't yet matched
    [recipeSearch removeObjectsInArray:filteredRecipes];
    
    //
    //Then search for the ingredients
    //
    
    //Create predicate for all different search words
    NSArray *separatedString;
    
    //Remove leading/ending spaces and commas
    searchText = [searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    searchText = [searchText stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@","]];
    
    //Validate for both "," and [space] as separators
    if ([searchText containsString:@","]) {
        separatedString = [searchText componentsSeparatedByString:@","];
    } else
        separatedString = [searchText componentsSeparatedByString:@" "];
    
    
    //Add all the predicates to an Array to be able to collect all the different searchwords
    NSMutableArray *allPredicates = [[NSMutableArray alloc]init];
    for (NSString *str in separatedString) {
        
        //Remove blank spaces for all the search texts
        NSString *tempSearch = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        //Use contain predicate to be able to search anywhere as the recipe ingredient can be "2 Apples". Not always in beginning of search
        NSPredicate *tempPredicate = [NSPredicate predicateWithFormat:@"SELF contains[c] %@",tempSearch];
        
        [allPredicates addObject:tempPredicate];
    }
    
    //Create a compound predicate to gather all predicates into one
    NSPredicate *compoundPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:allPredicates];
    
    //Loop all the recipes and find the ones with recipes that match the search string
    for (Recipe *tempRecipe in recipeSearch) {
        
        //Validate the ingredients array to the predicate and see if it contains the search term. If it does add the recipe to the filtered recipes
        
        //Start by adding all ingredients to the same NSString
        NSString *aggregatedIngredients;
        for (NSString *ingredient in tempRecipe.ingredients) {
            aggregatedIngredients = [NSString stringWithFormat:@"%@,%@", aggregatedIngredients,ingredient];
        }
        
        //Add the string to an array to be able to run a predicate on it
        NSArray *ingredientsInOnestring = [NSArray arrayWithObject:aggregatedIngredients];
        
        //Run the predicate to match if all the search words are among the ingredients
        NSArray *matchedIngredients = [ingredientsInOnestring filteredArrayUsingPredicate:compoundPredicate];
        
        //If the ingredients match then the predicate will have added the one object to the matchedIngredients array
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
    
    //Stop the activity indicator when the last visible object has been shown
    if([indexPath row] == ((NSIndexPath*)[[tableView indexPathsForVisibleRows] lastObject]).row){
        //end of loading
        [loadingIndicator stopAnimating];
    }
    
    static NSString *tableCellIdentifier = @"RecipeTableCell";
    RecipeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableCellIdentifier];
    
    // Configure the cell...
    
    if (cell == nil) {
        cell = [[RecipeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableCellIdentifier];
    }
    
    Recipe *recipeForRow = [self.recipes objectAtIndex:indexPath.row];
    cell.recipeTitle.text = recipeForRow.recipeName;
    cell.recipeDescription.text = recipeForRow.recipeDescription;
    
    //Removed this since it's taking to long and not efficient for the app to create UIImage here
    //cell.recipeImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", recipeForRow.imageName]];
    
    //Instead get the UIImage from memory, stored in a NSDictionary
    cell.recipeImage.image = [thumbnailImages objectForKey:recipeForRow.recipeName];
    
    //Check if the IAP has been purchased and if recipes should be unlocked
    //TODO
    
    //If the recipe is a favorite, then display the like image
    if ([archiveHelper isRecipeFavorite:recipeForRow]) {
        cell.likeImage.hidden = NO;
    } else
        cell.likeImage.hidden = YES;
    
    float alphaValue;
    if (recipeForRow.recipeCategory==1) {
        //Recipe Category 0 means that it's free
        //Recipe Category 1 means that it's locked
        //Show the locked ones with transparent background
        
        alphaValue = 0.18;
        
        
    } else if (recipeForRow.recipeCategory == 0) {
        alphaValue = 1;
    }
    
    //[cell.recipeTitle setAlpha:alphaValue];
    //[cell.recipeDescription setAlpha:alphaValue];
    [cell.recipeImage setAlpha:alphaValue];
    
    return cell;
}

#pragma mark - Table view data delegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Recipe* selRecipe = (Recipe*)[self.recipes objectAtIndex:indexPath.row];
    
    if (selRecipe.recipeCategory == 0) {
        //Move to screen that shows the recipe
        [self performSegueWithIdentifier:@"showRecipeSegue" sender:[self.tableView cellForRowAtIndexPath:indexPath]];
    } else if (selRecipe.recipeCategory == 1) {
        //Move to screen for in app purchases
        
        [self performSegueWithIdentifier:@"InAppPurchaseSegue" sender:[self.tableView cellForRowAtIndexPath:indexPath]];
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

#pragma mark - Scroll view delegate

-(void) scrollViewDidScroll:(UIScrollView *)scrollView {
    
    //Move all the recipes in the table view cells to create a parallax effect
    
    float offsetY = self.tableView.contentOffset.y;
    for (RecipeTableViewCell *cell in self.tableView.visibleCells) {
        
        float x = cell.recipeImage.frame.origin.x;
        float w = cell.recipeImage.frame.size.width;
        float h = cell.recipeImage.frame.size.height;
        
        float y;
        y = ((offsetY - cell.frame.origin.y) / h) * 10;
        cell.recipeImage.frame = CGRectMake(x, y, w, h);
        
        //TODO
        //Fix the scrolling so that the top 2 images are correctly positioned
    }
    
}

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
