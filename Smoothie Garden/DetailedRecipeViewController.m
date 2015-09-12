//
//  DetailedRecipeViewController.m
//  Smoothie Garden
//
//  Created by Jonas C Björkell on 2015-08-09.
//  Copyright (c) 2015 Jonas C Björkell. All rights reserved.
//

#import "DetailedRecipeViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface DetailedRecipeViewController ()

@end

@implementation DetailedRecipeViewController
{
    
    NSString *recipeName;
    NSArray  *recipeInstructions;
    NSArray *ingredients;
    
}

- (void) awakeFromNib {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //Get the size (primarily the height) by checking the size of the content view that holds all the subviews
    //scrollView.contentSize=CGSizeMake(contentView.frame.size.width,contentView.frame.size.height);
    
    recipeImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", self.selectedRecipe.imageName]];
    titleName.text = self.selectedRecipe.recipeName;
    recipeDescriptionView.text = self.selectedRecipe.detailedRecipedescription;
    ingredients = self.selectedRecipe.ingredients;
                            
    //Adjust the UITextViews to the size of the text to be presented
    ingredientsTableView.frame =     [self newFrameForUIView:ingredientsTableView];
    recipeDescriptionView.frame =    [self newFrameForUIView:recipeDescriptionView];
    
    [ingredientsHeightConstraint setConstant:ingredientsTableView.frame.size.height];
    [recipeDescriptionHeightConstraint setConstant:recipeDescriptionView.frame.size.height];
    
    
    //Uncomment to Remove the navigation bar background for the detailed items
    /*
     [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    */
    
    //If the recipe is one of the favorites, then make the like button selected
    if ([[self favoriteRecipes]containsObject:self.selectedRecipe.recipeName]) {
        likeButton.selected = YES;
    }
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGRect) newFrameForUIView: (UIView* ) view {

    //Change the height of the UITextViews
    CGFloat fixedWidth = view.frame.size.width;
    CGSize newSize = [view sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = view.frame;
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);

    return newFrame;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Table View Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if ([tableView isEqual:ingredientsTableView]) {
        return [ingredients count];
    }
    
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tmpTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier         =   @"DetailedRecipeTableCell";
    UITableViewCell *cell               =   [tmpTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (nil == cell) {
        cell    =   [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    
    if ([tmpTableView isEqual:ingredientsTableView]) {
        
        UILabel *recipeIngredient = (UILabel*)[cell viewWithTag:100];
        recipeIngredient.text = [ingredients objectAtIndex:indexPath.row];
    }
    
    
    
    
    return cell;
}

- (IBAction)likeRecipe:(id)sender {
    
    [self addRecipeToFavorites:self.selectedRecipe];
    
}

- (NSArray*) favoriteRecipes {
    
    return [[NSUserDefaults standardUserDefaults]arrayForKey:@"FavoriteRecipes"];
    
}

- (void) addRecipeToFavorites:(Recipe*) newRecipe {
    
    //Load the favorite recipes array
    NSMutableArray *tempFavoriteRecipes;
    if ([self favoriteRecipes].count>0) {
        tempFavoriteRecipes = [[NSMutableArray alloc]initWithArray:[self favoriteRecipes]];
    } else {
        tempFavoriteRecipes = [[NSMutableArray alloc]init];
    }
    
    //Check if the array already hold this recipe, if not then add it
    if (![tempFavoriteRecipes containsObject:newRecipe.recipeName]) {
        [tempFavoriteRecipes addObject:newRecipe.recipeName];
    }
    
    NSArray *newFavoriteRecipes = [tempFavoriteRecipes copy];
    
    NSLog(@"Recipe to save: %@", newRecipe.recipeName);
    NSLog(@"Saved recipes: %@", newFavoriteRecipes);
    //Set the new favorite recipes
    [[NSUserDefaults standardUserDefaults]setObject:newFavoriteRecipes forKey:@"FavoriteRecipes"];
    
    //Change the like button to selected
    likeButton.selected = YES;
}
     
@end
