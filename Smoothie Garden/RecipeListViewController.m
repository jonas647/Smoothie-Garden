//
//  RecipeListViewController.m
//  Smoothie Box
//
//  Created by Jonas C Björkell on 2016-10-08.
//  Copyright © 2016 Jonas C Björkell. All rights reserved.
//

#import "RecipeListViewController.h"
#import "RecipeManager.h"
#import "RecipeCollectionViewCell.h"
#import "Recipe.h"
#import "DetailedRecipeViewController.h"
#import "SWRevealViewController.h"

@interface RecipeListViewController () {
    
    NSArray *recipes;
    NSArray *allRecipes;
    NSDictionary *thumbnailImages;
    
}

@end

@implementation RecipeListViewController

static NSString * const reuseIdentifier = @"RecipeCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Present center image in the navigation bar
    UIImage *image = [UIImage imageNamed:@"SmoothieBox"];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:image];
    
    //Set the recipe array that will be presented in the collection view
    [self setupRecipesFromRecipeMaster];
    
    //Create thumbnail images to display in tableview
    thumbnailImages = [[RecipeManager sharedInstance]thumbnailImages];
    
    //Setup the collection view
    [self setupCollectionView];
    
    //Setup the search bar
    [self setupSearchController];
    
    //Change background color
    self.recipeCollectionView.backgroundColor = [UIColor whiteColor];
    
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
    
    //Remove the title text from the back button (in the Detailed recipe table view controller)
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.searchController.searchBar sizeToFit];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Managing of recipes

- (void) setupRecipesFromRecipeMaster {
    //Set the table view array
    recipes = [[RecipeManager sharedInstance] recipesMaster];
    
    allRecipes = recipes;
    
}

#pragma mark - Collection view setup

- (void) setupCollectionView {
    //UICollectionview flow layout
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
    
    float itemWidth = [self widthForItem];
    float itemHeight = itemWidth * 0.8;
    
    flow.itemSize = CGSizeMake(itemWidth, itemHeight);
    flow.scrollDirection = UICollectionViewScrollDirectionVertical;
    flow.minimumInteritemSpacing = 1;
    flow.minimumLineSpacing = 1;
    
    [self.recipeCollectionView reloadData];
    self.recipeCollectionView.collectionViewLayout = flow;
}

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
    
    self.definesPresentationContext = YES;
    
    [_searchbarBackground addSubview:self.searchController.searchBar];
    
    //[_searchbarBackground setFrame:CGRectMake(0, 0, _searchbarBackground.frame.size.width, _searchbarBackground.frame.size.height)];
    
    
}

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
    [self.recipeCollectionView performBatchUpdates:nil completion:nil];
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
    
    [self.recipeCollectionView reloadData];
}



#pragma mark - Navigation

 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 
     if ([segue.destinationViewController isKindOfClass:[DetailedRecipeViewController class]]) {
         //NSIndexPath *indexPath = (NSIndexPath*)sender;
 
         NSIndexPath *indexPath = [self.recipeCollectionView indexPathForCell:sender];
 
         DetailedRecipeViewController *vcToPushTo = (DetailedRecipeViewController*)segue.destinationViewController;
         vcToPushTo.selectedRecipe = [recipes objectAtIndex:indexPath.row];
     }
 }

@end
