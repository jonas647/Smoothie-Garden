//
//  RecipeCollectionViewController.m
//  Smoothie Box
//
//  Created by Jonas C Björkell on 2016-06-04.
//  Copyright © 2016 Jonas C Björkell. All rights reserved.
//

#import "RecipeCollectionViewController.h"
#import "RecipeCollectionViewCell.h"
#import "Recipe.h"
#import "SWRevealViewController.h"
#import "DetailedRecipeViewController.h"

@interface RecipeCollectionViewController () {
    
    NSArray *recipes;
    NSArray *allRecipes;
    NSDictionary *thumbnailImages;
}

@end

@implementation RecipeCollectionViewController

static NSString * const reuseIdentifier = @"RecipeCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage *image = [UIImage imageNamed:@"SmoothieBox"];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:image];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    //[self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    //Set the table view array
    [self setupRecipesFromRecipeMaster];
    
    //Create thumbnail images to display in tableview
    thumbnailImages = [[RecipeManager sharedInstance]thumbnailImages];
    
    //Change background color
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    //UICollectionview flow layout
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
    
    float itemWidth = [self widthForItem];
    float itemHeight = itemWidth * 0.8;
    
    flow.itemSize = CGSizeMake(itemWidth, itemHeight);
    flow.scrollDirection = UICollectionViewScrollDirectionVertical;
    flow.minimumInteritemSpacing = 1;
    flow.minimumLineSpacing = 1;
    
    [self.collectionView reloadData];
    self.collectionView.collectionViewLayout = flow;
    
    
    
    //This is needed for the reveal controller to work
    SWRevealViewController *revealController = [self revealViewController];
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    
    //Set the target for the main menu button
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController ) {
        [self.sideBarButton setTarget: self.revealViewController];
        [self.sideBarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }

    //Search bar
    _searchController.delegate = (id)self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Setup search controller

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
    
    //self.tableView.tableHeaderView = self.searchController.searchBar;
    self.definesPresentationContext = YES;

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
        recipes = filteredRecipes;
    } else {
        recipes = allRecipes;
    }
    
    [self.collectionView reloadData];
}


#pragma mark - Managing of recipes

- (void) setupRecipesFromRecipeMaster {
    //Set the table view array
    recipes = [[RecipeManager sharedInstance] recipesMaster];
    
    allRecipes = recipes;
    
}

#pragma mark - calculate size for items in collection view

- (float) widthForItem {
    
    if (self.view.frame.size.width >= 1024) {
        return self.view.frame.size.width/4 - 3;
        
    } else if (self.view.frame.size.width >= 768) {
        return self.view.frame.size.width/3 - 2;
        
    } else if (self.view.frame.size.width >= 375) {
        return self.view.frame.size.width/2 -1;
        
    } else {
        return self.view.frame.size.width;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return recipes.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    RecipeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];

    if (cell == nil) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    }
    Recipe *sRecipe = [recipes objectAtIndex:indexPath.row];
    
    // Configure the cell
    cell.recipeImage.image = [thumbnailImages objectForKey:sRecipe.recipeName];
    cell.recipeHeader.text = sRecipe.recipeName;
    cell.recipeDescription.text = sRecipe.shortDescription;
    
    //If the recipe isn't liked, don't show the heart icon
    if (!sRecipe.favorite) {
        cell.likedRecipe.hidden = YES;
    }
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    float itemWidth = [self widthForItem];
    float itemHeight = itemWidth * 0.8;
    return CGSizeMake(itemWidth, itemHeight);
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self.collectionView performBatchUpdates:nil completion:nil];
}

/*
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(self.view.frame.size.width/2.04, self.view.frame.size.height*0.25);
    
}
 */

#pragma mark <UICollectionViewDelegate>

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {

        reusableview = [collectionView dequeueReusableCellWithReuseIdentifier:@"Header" forIndexPath:indexPath];
    }
    
    return reusableview;
}

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.destinationViewController isKindOfClass:[DetailedRecipeViewController class]]) {
        //NSIndexPath *indexPath = (NSIndexPath*)sender;
        
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:sender];
        
        DetailedRecipeViewController *vcToPushTo = (DetailedRecipeViewController*)segue.destinationViewController;
        vcToPushTo.selectedRecipe = [recipes objectAtIndex:indexPath.row];
        
        
    }
    
}

@end
