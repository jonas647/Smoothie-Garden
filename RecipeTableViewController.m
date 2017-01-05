//
//  RecipeTableViewController.m
//  Smoothie Garden
//
//  Created by Jonas C Björkell on 2015-08-06.
//  Copyright (c) 2015 Jonas C Björkell. All rights reserved.
//

#import "RecipeTableViewController.h"
#import "DetailedRecipeViewController.h"
#import "SWRevealViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "RecipeTableViewCell.h"
#import "SBActivityIndicatorView.h"
#import "Ingredient.h"
#import "Recipe.h"
#import "RecipeManager.h"
#import "DeviceHelper.h"

@interface RecipeTableViewController ()



@end

@implementation RecipeTableViewController
{
    NSArray *allRecipes;
    NSIndexPath *indexOfSelectedObject;
    NSDictionary *thumbnailImages;
    NSMutableArray *filteredRecipeArray;
    SBActivityIndicatorView *loadingIndicator;
    float imageParallaxEffectFactor;
    float titleTextSize;
    float descriptionTextSize;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Handle the uisplitview
    if ([self splitViewController]) {
        NSLog(@"Split view active");
        
        NSArray *viewControllers = [[self splitViewController]viewControllers];
        self.delegate = (DetailedRecipeViewController*)[[viewControllers objectAtIndex:viewControllers.count-1]topViewController];
        
        NSLog(@"Delegate: %@", self.delegate);
    }
    
    
    [self setupSearchController];  //Setup the search controller programmatically since it's not possible in storyboard
    //[self setupActivityIndicator]; //Setup of the activity indicator programmatically
    //[loadingIndicator startActivityIndicator];
    
    //Set the table view array
    [self setupRecipesFromRecipeMaster];
    
    //Create thumbnail images to display in tableview
    thumbnailImages = [[RecipeManager sharedInstance]thumbnailImages];
    
    
    //How much parallax effect the images will have. The higher the bigger vertical move.
    imageParallaxEffectFactor = 15;
    
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
    
    //Remove the title text from the back button (in the Detailed recipe table view controller)
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    if ([[DeviceHelper sharedInstance] isDeviceIphone4] || [[DeviceHelper sharedInstance] isDeviceIphone5]) {
        
        titleTextSize = 17;
        descriptionTextSize = 13;
        
    } else if ([[DeviceHelper sharedInstance] isDeviceIphone6]) {
        
        titleTextSize = 18;
        descriptionTextSize = 14;
        
    } else if ([[DeviceHelper sharedInstance] isDeviceIphone6plus]) {
        
        titleTextSize = 21;
        descriptionTextSize = 16;
        
    } else if ([[DeviceHelper sharedInstance] isDeviceSimulator]) {
        
        //Just to test on simulator
        titleTextSize = 21;
        descriptionTextSize = 16;
    } else {
        // If a new device is released before the app is updated
        titleTextSize = 17;
        descriptionTextSize = 13;
    }
    
}


- (void)viewWillAppear:(BOOL)animated {
    
    //Reset the navigation bar, set back to being shown
    //Is hidden in the detailed recipe view
    [self.navigationController.navigationBar setBackgroundImage:nil
                                                  forBarMetrics:UIBarMetricsDefault];
    
    //Update the uitableviewcell that was presented (if returning from detail view
    if (indexOfSelectedObject) {
        [self.tableView beginUpdates];
        
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexOfSelectedObject] withRowAnimation:UITableViewRowAnimationFade];
        
        [self.tableView endUpdates];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    
    //Uncomment to remove the last search
    //[self.searchController setActive:NO];
    
}



- (void) viewDidAppear:(BOOL)animated {
    
    
    //Remove this to reload the table for liked recipes, but takes a bit longer before user can scroll
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) setupRecipesFromRecipeMaster {
    //Set the table view array
    self.recipes = [[RecipeManager sharedInstance] recipesMaster];
    
    allRecipes = self.recipes;
    
    
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
    
    self.searchController.searchBar.placeholder = NSLocalizedString(@"LOCALIZE_Search", @"Search for recipe or ingredient");

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
    
}


#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    //Called when the search result should be updated
    
    //Get the search text
     NSString *searchText = searchController.searchBar.text;
    
    //Get the recipes to search among
    NSMutableArray *recipeSearch = [[NSMutableArray alloc]initWithArray:allRecipes];
    
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
    
    [self sortAndReloadTable];
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
    cell.recipeDescription.text = sRecipe.shortDescription;
    
    //Size of font depending on device
    cell.recipeTitle.font = [UIFont fontWithName:cell.recipeTitle.font.fontName size:titleTextSize];
    cell.recipeDescription.font = [UIFont fontWithName:cell.recipeTitle.font.fontName size:descriptionTextSize];
    
    //Instead get the UIImage from memory, stored in a NSDictionary
    cell.recipeImage.image = [thumbnailImages objectForKey:sRecipe.recipeName];
    
    //If the recipe is a favorite, then display the like image
    if ([[RecipeManager sharedInstance] isRecipeFavorite:sRecipe]) {
        cell.likeImage.hidden = NO;
    } else
        cell.likeImage.hidden = YES;
    
    
    //Not in use right now
    //Check if the IAP has been purchased and if recipes should be unlocked
    //If the recipe is of type 0 then it's a free recipe, no need to check for IAP
    /*
    BOOL isRecipeUnlocked = [[RecipeManager sharedInstance] isRecipeUnlocked];
    
    //Use alpha value to make the unlocked recipes transparent
    float alphaValue;
    if (!isRecipeUnlocked) {
        
        alphaValue = 0.18;
        
    } else if (isRecipeUnlocked) {
        alphaValue = 1;
    }
    
    [cell.recipeImage setAlpha:alphaValue];
    */
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
 
    //Hardcoded this value based on the image size to get a good image ratio
    //To get it 100% correct I would need to take in the title and text into this. But I think this is fine
    return self.view.frame.size.width*0.9;
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //This is needed to get proper parallax effect and no stuttering image when loading the table view
    [self updateParallaxEffectForCell:(RecipeTableViewCell*) cell];
}

#pragma mark - Table view data delegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    //Splitviewcontroller
    /*
    Recipe *selectedRecipe = [_recipes objectAtIndex:indexPath.row];
    
    if (_delegate) {
        NSLog(@"Send selected recipe: %@ to: %@",selectedRecipe.recipeName , _delegate);
        [_delegate didSelectRecipe:selectedRecipe];
    }
    */
    /*
    NSLog(@"Crash?");
    UINavigationController *detailedNavController = [self.splitViewController viewControllers][1];
    DetailedRecipeViewController *recipeDetailController = (DetailedRecipeViewController*)[detailedNavController viewControllers][1];
    NSLog(@"1");
    [recipeDetailController selectedRecipe:selectedRecipe];
    
    NSLog(@"2");
    
    //Save the index of the touched object so that we can reload that row when coming back from detailed view
    indexOfSelectedObject = indexPath;
    */
    
    
    //Perform segue to detailed recipe view
    [self performSegueWithIdentifier:@"showRecipeSegue" sender:[self.tableView cellForRowAtIndexPath:indexPath]];
    
    
    //Not in use right now
    //IAP
    /*
    Recipe* selRecipe = (Recipe*)[self.recipes objectAtIndex:indexPath.row];
    if ([selRecipe isRecipeUnlocked]) {
        //Move to screen that shows the recipe
        [self performSegueWithIdentifier:@"showRecipeSegue" sender:[self.tableView cellForRowAtIndexPath:indexPath]];
    } else if (![selRecipe isRecipeUnlocked]) {
        //Move to screen for in app purchases
        
        [self performSegueWithIdentifier:@"InAppPurchaseSegue" sender:[self.tableView cellForRowAtIndexPath:indexPath]];
    }
    */
}

#pragma mark - Table view sorting

- (void) sortAndReloadTable {
    
    //No need for sorting as this is done in the recipe master
    [self.tableView reloadData];
}

#pragma mark - Parallax effect for recipe image

- (void) updateParallaxEffectForCell: (RecipeTableViewCell*) cellToDisplay {
    
    //CGRect cellFrameInTable = [self.tableView convertRect:cellToDisplay.frame toView:self.tableView.superview];
    
    
    //Offset of the current position in table view
    float offsetY = self.tableView.contentOffset.y;
    
    //Only the Y position matters since only vertical scrolling
    float x = cellToDisplay.recipeImage.frame.origin.x;
    float w = cellToDisplay.recipeImage.frame.size.width;
    float h = cellToDisplay.recipeImage.frame.size.height;
    
    //Check where the cell is and split for height and add the parallax factor. Got this from "the internet"...
    float y = ((offsetY - cellToDisplay.frame.origin.y) / h) * imageParallaxEffectFactor;
    cellToDisplay.recipeImage.frame = CGRectMake(x, y, w, h);
    
    
    
    
    /*
    CGRect cellFrame = cellToDisplay.frame;
    CGRect cellFrameInTable = [self.tableView convertRect:cellFrame toView:self.tableView.superview];
    float cellOffset = cellFrameInTable.origin.y + cellFrameInTable.size.height;
    float tableHeight = self.tableView.bounds.size.height + cellFrameInTable.size.height;
    float cellOffsetFactor = cellOffset / tableHeight;
    
    [cellToDisplay setBackgroundOffset:cellOffsetFactor];
    */
}

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
        
        NSLog(@"Segue to detailed controller");
        DetailedRecipeViewController *vcToPushTo = (DetailedRecipeViewController*)segue.destinationViewController;
        vcToPushTo.selectedRecipe = [self.recipes objectAtIndex:indexPath.row];
    
    }
    
    
}




@end
