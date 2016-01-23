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
#import "RecipeTableViewCell.h"
#import "SBActivityIndicatorView.h"
#import "Ingredient.h"
#import "UIFont+FontSizeBasedOnScreenSize.h"

#define LABEL_SIZE_LARGE 1
#define LABEL_SIZE_SMALL 2



@interface RecipeTableViewController ()


@end

@implementation RecipeTableViewController
{
    NSArray *allRecipes;
    Recipe *selectedRecipe;
    NSMutableDictionary *thumbnailImages;
    NSMutableArray *filteredRecipeArray;
    SBActivityIndicatorView *loadingIndicator;
    float imageParallaxEffectFactor;
    UIFont *smallSizeFont;
    UIFont *largeSizeFont;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    imageParallaxEffectFactor = 20;
    
    //TODO
    //Comment out the stuff linked to favorites or use it in another way
    //Perhaps sort by liked recipes first
    
    [self setupActivityIndicator]; //Setup of the activity indicator programmatically
    [loadingIndicator startActivityIndicator];
    
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
    
    //Remove the title text from the back button (in the Detailed recipe table view controller)
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    //Array for handling the filtered search results
    //filteredRecipeArray = [NSMutableArray arrayWithCapacity:[[Recipe allRecipesFromPlist] count]];
    
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
    
    //TODO
    //Change the search controller so that it keeps the search string
}



- (void) viewDidAppear:(BOOL)animated {
    
    //Validate on what tab bar item is chosen to select what data to show
    //This must be in view did appear as the selected index isn't set in the view will appear
    
    self.recipes = [Recipe allRecipesFromPlist];
    allRecipes = self.recipes;
    
    [self setupSearchController]; //Setup the search controller programmatically since it's not possible in storyboard
    
    //Set the starting point for the scroller view below the search bar
    //self.tableView.contentInset = UIEdgeInsetsMake(-40.0f, 0.0f, 0.0f, 0.0);
    
    //This will also solve the problem with wrong picture for search result table view
    thumbnailImages = [[NSMutableDictionary alloc]init];
    for (Recipe *r in self.recipes) {
        UIImage *tempImage = [self createThumbnailForImageWithName:r.imageName];
        [thumbnailImages setObject:tempImage forKey:r.recipeName];
    }
    
    //Update the font to be used in the table views. Based on size.
    //TODO
    
    //Reload the view to get the proper recipes showing
    [self.tableView reloadData];
    
}


/*
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
    
}*/

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Activity indicator for loading

- (void) setupActivityIndicator {
    
    loadingIndicator = [[SBActivityIndicatorView alloc]initWithFrame:CGRectMake(0,0, self.view.frame.size.width/5, self.view.frame.size.width/5)];
    
    [loadingIndicator setCenter:self.view.center];
    
    [self.view addSubview:loadingIndicator];
    [self.view bringSubviewToFront:loadingIndicator];
   
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
    
    self.recipes = allRecipes;
    [self.tableView reloadData];
}


#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    //Called when the search result should be updated
    
    //Get the search text
     NSString *searchText = searchController.searchBar.text;
    
    //Get the recipes to search among
    //TODO, should not get a new list every time, instead have a current list to work with
    NSMutableArray *recipeSearch = (NSMutableArray*)self.recipes;
    
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
        
        //Add the string with all the ingredients to an array to be able to run a predicate on it
        NSArray *ingredientsInOnestring = [NSArray arrayWithObject:[tempRecipe stringWithIngredients]];
                
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
    
    //Hand over the filtered results to our search results table
    //If there's no search string then just show all recipes
    if (searchText.length>0) {
        self.recipes = filteredRecipes;
    } else {
        self.recipes = allRecipes;
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
    
    //Get the custom cell for the recipe 
    static NSString *tableCellIdentifier = @"RecipeTableCell";
    return [self customCellForRecipe:[self.recipes objectAtIndex:indexPath.row] inTableView:tableView withTableViewCellIdentifier:tableCellIdentifier];
}

- (RecipeTableViewCell*) customCellForRecipe: (Recipe*) sRecipe inTableView: (UITableView*) tableView withTableViewCellIdentifier: (NSString*) cellIdentifier {
    
    RecipeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    // Configure the cell...
    
    if (cell == nil) {
        cell = [[RecipeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    
    cell.recipeTitle.text = sRecipe.recipeName;
    cell.recipeDescription.text = sRecipe.RecipeOverviewDescription;
    
    /*
    [cell.recipeTitle setFont:[cell.recipeTitle.font fontSizeBasedOnScreenSize_fontBasedOnScreenSizeForFont:cell.recipeTitle.font withSize:LABEL_SIZE_LARGE]];
    [cell.recipeDescription setFont:[cell.recipeDescription.font fontSizeBasedOnScreenSize_fontBasedOnScreenSizeForFont:cell.recipeDescription.font withSize:LABEL_SIZE_SMALL]];
    
    [cell.recipeTitle sizeToFit];
    [cell.recipeDescription sizeToFit];
    */
    //Removed this since it's taking to long and not efficient for the app to create UIImage here
    //cell.recipeImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", sRecipe.imageName]];
    
    //Instead get the UIImage from memory, stored in a NSDictionary
    cell.recipeImage.image = [thumbnailImages objectForKey:sRecipe.recipeName];
    
    
    //If the recipe is a favorite, then display the like image
    if ([sRecipe isRecipeFavorite]) {
        cell.likeImage.hidden = NO;
    } else
        cell.likeImage.hidden = YES;
    
    
    //Check if the IAP has been purchased and if recipes should be unlocked
    //If the recipe is of type 0 then it's a free recipe, no need to check for IAP
    BOOL isRecipeUnlocked = [sRecipe isRecipeUnlocked];
    
    //Use alpha value to make the unlocked recipes transparent
    
    
    float alphaValue;
    if (!isRecipeUnlocked) {
        
        alphaValue = 0.18;
        
    } else if (isRecipeUnlocked) {
        alphaValue = 1;
    }
    
    [cell.recipeImage setAlpha:alphaValue];
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
 
    //Hardcoded this value based on the image size to get a good image ratio
    //To get it 100% correct I would need to take in the title and text into this. But I think this is fine
    return self.view.frame.size.width*0.9;
    
    /*
    RecipeTableViewCell *cell = [self customCellForRecipe:[self.recipes objectAtIndex:indexPath.row] inTableView:tableView withTableViewCellIdentifier:@"RecipeTableCell"];
    float heightForImage = [UIScreen mainScreen].bounds.size.width*0.75; //Hardcoding since the image has wrong height. Not sure why.
    float heightForTitle = cell.recipeTitle.frame.size.height;
    float heightForDescription = cell.recipeDescription.frame.size.height;
    
    return heightForImage+heightForTitle+heightForDescription;*/
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //This is needed to get proper parallax effect and no stuttering image when loading the table view
    [self updateParallaxEffectForCell:(RecipeTableViewCell*) cell];
}

#pragma mark - Table view data delegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Recipe* selRecipe = (Recipe*)[self.recipes objectAtIndex:indexPath.row];
    
    if ([selRecipe isRecipeUnlocked]) {
        //Move to screen that shows the recipe
        [self performSegueWithIdentifier:@"showRecipeSegue" sender:[self.tableView cellForRowAtIndexPath:indexPath]];
    } else if (![selRecipe isRecipeUnlocked]) {
        //Move to screen for in app purchases
        
        [self performSegueWithIdentifier:@"InAppPurchaseSegue" sender:[self.tableView cellForRowAtIndexPath:indexPath]];
    }
    
}

#pragma mark - Table view sorting

- (void) sortAndReloadTable {
    
    // Set ascending:NO so that "YES" would appear ahead of "NO"
    NSSortDescriptor *boolDescr = [[NSSortDescriptor alloc] initWithKey:@"favorite" ascending:NO];
    // String are alphabetized in ascending order
    NSSortDescriptor *strDescr = [[NSSortDescriptor alloc] initWithKey:@"sorting" ascending:YES];
    // Combine the two
    NSArray *sortDescriptors = @[boolDescr, strDescr];
    // Sort your array
    self.recipes = [self.recipes sortedArrayUsingDescriptors:sortDescriptors];
    
    [self.tableView reloadData];
}

#pragma mark - Parallax effect for recipe image

- (void) updateParallaxEffectForCell: (RecipeTableViewCell*) cellToDisplay {
    
    
    //Offset of the current position in table view
    float offsetY = self.tableView.contentOffset.y;
    
    
    //Only the Y position matters since only vertical scrolling
    float x = cellToDisplay.recipeImage.frame.origin.x;
    float w = cellToDisplay.recipeImage.frame.size.width;
    float h = cellToDisplay.recipeImage.frame.size.height;
    
    //Check where the cell is and split for height and add the parallax factor. Got this from "the internet"...
    float y = ((offsetY - cellToDisplay.frame.origin.y) / h) * imageParallaxEffectFactor;
    cellToDisplay.recipeImage.frame = CGRectMake(x, y, w, h);
    
}


/*
 //Uncommenting this since it shouldn't be possible to edit rows. Not using the favorite tab any longer.
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
    [[self.recipes objectAtIndex:indexPath.row] removeRecipeFromFavorites];
    
    //Set the new favorite recipe list
    self.recipes = [Recipe allRecipesFromPlist];
    
    //Reload the table so that the recipe disappears
    [self.tableView reloadData];
}
 */

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
    
    for (RecipeTableViewCell *cell in self.tableView.visibleCells) {
    
        [self updateParallaxEffectForCell:cell];
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
