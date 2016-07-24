//
//  RecipeCollectionViewController.m
//  Smoothie Box
//
//  Created by Jonas C Björkell on 2016-06-04.
//  Copyright © 2016 Jonas C Björkell. All rights reserved.
//

#import "RecipeCollectionViewController.h"
#import "SBRecipeCollectionViewCell.h"
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
    flow.itemSize = CGSizeMake(self.view.frame.size.width/2 - 1, self.view.frame.size.height*0.33);
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
        //[self.sideBarButton setTarget: self.revealViewController];
        //[self.sideBarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }

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
    SBRecipeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];

    if (cell == nil) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    }
    Recipe *sRecipe = [recipes objectAtIndex:indexPath.row];
    
    // Configure the cell
    cell.recipeImage.image = [thumbnailImages objectForKey:sRecipe.recipeName];
    cell.recipeHeader.text = sRecipe.recipeName;
    cell.recipeDescription.text = sRecipe.shortDescription;
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"Show recipe segue");
    [self performSegueWithIdentifier:@"showRecipeSegue" sender:indexPath];
    
}

/*
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(self.view.frame.size.width/2.04, self.view.frame.size.height*0.25);
    
}
 */

#pragma mark <UICollectionViewDelegate>

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
        NSIndexPath *indexPath = (NSIndexPath*)sender;
        
        DetailedRecipeViewController *vcToPushTo = (DetailedRecipeViewController*)segue.destinationViewController;
        vcToPushTo.selectedRecipe = [recipes objectAtIndex:indexPath.row];
        
    }
    
}

@end
