//
//  DetailedRecipeViewController.m
//  Smoothie Garden
//
//  Created by Jonas C Björkell on 2015-08-09.
//  Copyright (c) 2015 Jonas C Björkell. All rights reserved.
//

#define LABEL_SIZE_LARGE 1
#define LABEL_SIZE_SMALL 2
#define LABEL_SIZE_TINY 3

#define NUTRITION_CALORIES @"Energy"
#define NUTRITION_FAT @"Fat"
#define NUTRITION_PROTEIN @"Protein"
#define NUTRITION_CARBOHYDRATE @"Carbohydrate"
#define NUTRITION_FIBER @"Fiber"

#import "DetailedRecipeViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "SBGoogleAnalyticsHelper.h"
#import "AppReviewHelper.h"
#import "Ingredient.h"
#import "RecipeManager.h"
#import "RecipeShoppingListViewController.h"
#import "DeviceHelper.h"
#import "NutrientCollectionViewCell.h"
#import "RecipeImageViewController.h"




@interface DetailedRecipeViewController ()

@end

@implementation DetailedRecipeViewController
{
    
    NSString *recipeName;
    NSArray  *recipeInstructions;
    NSArray *recipeDescriptions;
    NSArray *ingredients;
    NSArray *nutrientTypes;
    float latestContentOffset;
    BOOL isLikeButtonTouchable;
    
    UIButton *rightBarButton;
    
    float marginBetweenTextCells;
    float sizeForByText;
    float sizeForSmoothieBoxText;
    float sizeForTitleText;
    float sizeForRecipeDescriptions;
    float sizeForShoppingListText;
    
}

static NSString * const reuseIdentifier = @"NutrientCollectionViewCell";

/*
- (void)viewWillLayoutSubviews {
    
    // Call super class to make the views layout. Needed for the in-call status bar to get correct position vs. UIViews
    [super viewWillLayoutSubviews];
}
*/

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //No recipe will be shown on startup when having the split view controller so no need for populating any values.
    [self refreshUI];
    
    //Remove the title text from the back button (in the Detailed nutrient table view controller)
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    //Hide the navigation bar
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc]init];
    UIImage *tempImage = [[UIImage alloc]init];
    [self.navigationController.navigationBar setBackgroundImage:tempImage forBarMetrics:UIBarMetricsDefault];
    
    //The like button needs to be touchable to start with
    isLikeButtonTouchable = YES;
    
    //Set the text sizes depending on device
    if ([[DeviceHelper sharedInstance] isDeviceIphone4] || [[DeviceHelper sharedInstance] isDeviceIphone5]) {
        
        sizeForByText = 9;
        sizeForSmoothieBoxText = 11;
        sizeForTitleText = 20;
        sizeForRecipeDescriptions = 17;
        sizeForShoppingListText = 12;
        marginBetweenTextCells = 20;
        
    } else if ([[DeviceHelper sharedInstance] isDeviceIphone6]) {
        
        sizeForByText = 10;
        sizeForSmoothieBoxText = 13;
        sizeForTitleText = 21;
        sizeForRecipeDescriptions = 18;
        sizeForShoppingListText = 15;
        marginBetweenTextCells = 30;
        
    } else if ([[DeviceHelper sharedInstance] isDeviceIphone6plus]) {
        
        sizeForByText = 11;
        sizeForSmoothieBoxText = 14;
        sizeForTitleText = 26;
        sizeForRecipeDescriptions = 21;
        sizeForShoppingListText = 17;
        marginBetweenTextCells = 35;
        
    } else if ([[DeviceHelper sharedInstance] isDeviceIpad]) {
        
        sizeForByText = 13;
        sizeForSmoothieBoxText = 16;
        sizeForTitleText = 38;
        sizeForRecipeDescriptions = 30;
        sizeForShoppingListText = 17;
        marginBetweenTextCells = 40;
        
    } else if ([[DeviceHelper sharedInstance] isDeviceSimulator]) {
        
        sizeForByText = 13;
        sizeForSmoothieBoxText = 16;
        sizeForTitleText = 28;
        sizeForRecipeDescriptions = 24;
        sizeForShoppingListText = 17;
        marginBetweenTextCells = 80;
    } else {
        // If a new device is released before the app is updated
        sizeForByText = 9;
        sizeForSmoothieBoxText = 11;
        sizeForTitleText = 18;
        sizeForRecipeDescriptions = 18;
        sizeForShoppingListText = 12;
        marginBetweenTextCells = 20;
    }
    
    ingredientsTableView.estimatedRowHeight = 40;
    recipeTableView.estimatedRowHeight = 120;
    longDescriptionTable.estimatedRowHeight = 120;
    
    ingredientsTableView.rowHeight = UITableViewAutomaticDimension;
    recipeTableView.rowHeight = UITableViewAutomaticDimension;
    longDescriptionTable.rowHeight = UITableViewAutomaticDimension;
    
    caloriesText.text = [NSString stringWithFormat:@"Total Energy: %@",[_selectedRecipe volumeStringForNutrient:NUTRITION_CALORIES]];
    
    
    //Setup an array with the objects that will be populated manually to be first objects in nutrient objects
    
    NSArray *manualNutrientFacts = @[NUTRITION_FAT, NUTRITION_FIBER, NUTRITION_PROTEIN, NUTRITION_CARBOHYDRATE, NUTRITION_CALORIES];
    
    //Set the nutrient values to be shown
    NSMutableArray *tempNutrients = [[NSMutableArray alloc]init];
    for (NSString *nutrient in self.selectedRecipe.allNutrientKeys) {
        if (![manualNutrientFacts containsObject:nutrient]) {
            [tempNutrients addObject:nutrient];
        }
    }
    
    nutrientTypes = [NSArray arrayWithArray:tempNutrients];
    
}

/*
- (void) viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/

- (void) viewDidLayoutSubviews {
    
    //Update the height constraints to fit the contents
    ingredientsHeightConstraint.constant = ingredientsTableView.contentSize.height;
    recipeTableViewHeightConstraint.constant = recipeTableView.contentSize.height;
    longDescriptionTableHeightConstraint.constant = longDescriptionTable.contentSize.height;
    
    [ingredientsTableView layoutIfNeeded];
    [recipeTableView layoutIfNeeded];
    [longDescriptionTable layoutIfNeeded];
    
    [nutrientCollectionViewHeightConstraint setConstant:nutrientCollectionView.collectionViewLayout.collectionViewContentSize.height];
    
    //Set the likeview attributes (shows when a recipe is liked)
    likeView.layer.cornerRadius = likeView.bounds.size.width/2;//Make like view a circle
    likeView.alpha = 0.0;//Make like view hidden until the recipe is liked
    likeView.layer.masksToBounds = YES;
    
    //The title of the view should be the recipe title
    titleName.text = self.selectedRecipe.recipeName;
    
    //Change font size based on screen size. If another screen, then just go with what the storyboard says
    
    [self setFontSizeForLabel:byText size:sizeForByText];
    [self setFontSizeForLabel:smoothieBoxText size:sizeForSmoothieBoxText];
    [self setFontSizeForLabel:titleName size:sizeForTitleText];
    
    [self setFontSizeForLabel:byCopy size:sizeForByText];
    [self setFontSizeForLabel:smoothieBoxCopy size:sizeForSmoothieBoxText];
    [self setFontSizeForLabel:titleCopy size:sizeForTitleText];
    
    [self setFontSizeForLabel:shoppingListButton.titleLabel size:sizeForShoppingListText];
    
    //Set the height constraint of where the title should begin. Below the image.
    [titleToTop setConstant:0.75*[UIScreen mainScreen].bounds.size.width];
    [servingsViewToTop setConstant:titleToTop.constant + titleBackground.frame.size.height*1.1];
    
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
    
    //Check so that it's the scrollview and not the collection view showing the nutrients
    
    if (![scrollView isKindOfClass:[UICollectionView class]] ) {
        //When the title background leaves screen show the hidden title background
        if (scrollView.contentOffset.y >= titleBackground.frame.origin.y) {
            
            [titleBackgroundCopy setHidden:NO];
        } else if (scrollView.contentOffset.y <= titleBackground.frame.origin.y) {
            [titleBackgroundCopy setHidden:YES];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) refreshUI {
        
    ingredients = self.selectedRecipe.ingredients;
    recipeInstructions = self.selectedRecipe.instructions;
    recipeDescriptions = self.selectedRecipe.longDescription;
    //Setup right bar button with custom image
    UIButton *customButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    rightBarButton = customButton;
    
    UIImage *buttonImage = [UIImage imageNamed:@"Heart Outline"];
    UIImage *selectedButtonImage = [UIImage imageNamed:@"Heart Filled"];
    [customButton setBackgroundImage:buttonImage  forState:UIControlStateNormal];
    [customButton setBackgroundImage:selectedButtonImage  forState:UIControlStateSelected];
    [customButton addTarget:self action:@selector(likeRecipe) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView: customButton];
    
    self.navigationItem.rightBarButtonItem = barButtonItem;
    
    //If the recipe is liked then make the like button selected
    if (self.selectedRecipe.favorite) {
        [customButton setSelected:YES];
    }
    
    //If the recipe is one of the favorites, then make the like button selected
    if ([[RecipeManager sharedInstance]isRecipeFavorite:self.selectedRecipe]) {
        [rightBarButton setSelected:YES];
    }
    
    //Hide the servings view if almond milk is shown since this is for one liter
    if ([self.selectedRecipe.recipeName isEqualToString:@"Almond milk"]) {
        servingView.hidden = YES;
    }
    
    //Report to analytics
    [SBGoogleAnalyticsHelper reportScreenToAnalyticsWithName:[NSString stringWithFormat:@"Recipe %@", _selectedRecipe.recipeName]];
    
    //Ask for review
    if ([AppReviewHelper shouldShowReviewAlert]) {
        
        [self performSelector:@selector(showReviewAlertToUser) withObject:nil afterDelay:0.5f];
        
    }
    
    //ADDITIONS
    //The title of the view should be the recipe title
    titleName.text = self.selectedRecipe.recipeName;
    titleCopy.text = self.selectedRecipe.recipeName;
    
}

#pragma mark - Update font sizes

- (void) setFontSizeForLabel: (UILabel*) label size: (float) size {
    
    [label setFont:[UIFont fontWithName:label.font.fontName size:size]];
    
}

#pragma mark - Updating frames

- (CGRect) newFrameForUIView: (UIView* ) view {

    //Change the height of the UIView
    CGFloat fixedWidth = view.frame.size.width;
    CGSize newSize = [view sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = view.frame;
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);

    return newFrame;
}

- (CGRect)zoomRectForImageView:(UIImageView *)imageView withScale:(float)scale withCenter:(CGPoint)center {
    
    CGRect zoomRect;
    
    // The zoom rect is in the content view's coordinates.
    // At a zoom scale of 1.0, it would be the size of the
    // imageScrollView's bounds.
    // As the zoom scale decreases, so more content is visible,
    // the size of the rect grows.
    zoomRect.size.height = imageView.frame.size.height / scale;
    zoomRect.size.width  = imageView.frame.size.width  / scale;
    
    // choose an origin so as to get the right center.
    zoomRect.origin.x = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0);
    
    return zoomRect;
}


#pragma mark - Table View Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if ([tableView isEqual:ingredientsTableView] && ingredients.count>0) {
        return [ingredients count];
    } else if ([tableView isEqual:recipeTableView] && recipeInstructions.count>0) {
        return [recipeInstructions count];
    } else if ([tableView isEqual:longDescriptionTable] && recipeDescriptions.count >0) {
        return [recipeDescriptions count];
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
        
        UILabel *recipeQtyMeasure = (UILabel*)[cell viewWithTag:200];
        UILabel *recipeIngredientText = (UILabel*)[cell viewWithTag:201];
        UILabel *separator = (UILabel*)[cell viewWithTag:202];
    
        Ingredient *ingredientForRow = [ingredients objectAtIndex:indexPath.row];
    
        recipeQtyMeasure.text = [ingredientForRow stringWithQuantityAndMeasure];
        recipeQtyMeasure.font = [UIFont fontWithName:recipeQtyMeasure.font.fontName size:sizeForRecipeDescriptions];
        
        recipeIngredientText.text = [ingredientForRow stringWithIngredientText];
        recipeIngredientText.font = [UIFont fontWithName:recipeQtyMeasure.font.fontName size:sizeForRecipeDescriptions];
        
        //If it's a blank ingredient then make the separator transparent
        if ([recipeIngredientText.text isEqualToString:@""]) {
            
            [separator setText:@"x"];
            [separator setFont:[UIFont fontWithName:separator.font.fontName size:10]];
        }
        
        
    } else if ([tmpTableView isEqual:recipeTableView]) {
    
        UILabel *recipeText = (UILabel*)[cell viewWithTag:300];
        recipeText.text = [recipeInstructions objectAtIndex:indexPath.row];
        recipeText.font = [UIFont fontWithName:recipeText.font.fontName size:sizeForRecipeDescriptions];
    } else if ([tmpTableView isEqual:longDescriptionTable]) {
        
        UILabel *descriptionText = (UILabel*)[cell viewWithTag:101];
        descriptionText.text = [recipeDescriptions objectAtIndex:indexPath.row];
        descriptionText.font = [UIFont fontWithName:descriptionText.font.fontName size:sizeForRecipeDescriptions];
        
    }
    
    return cell;
}

#pragma mark - Handle Recipe Favorites

- (void) likeRecipe {
  
    
    if (!isLikeButtonTouchable) {
        //If the like button isn't touchable, then don't do anything
        return;
    }
    
    if (!rightBarButton.selected) {
        
        //Add recipe to the favorites. Run in background thread
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [[RecipeManager sharedInstance]addRecipeToFavorites:self.selectedRecipe];
            
        });
        
        //Change the like button to selected
        rightBarButton.selected = YES;
        
        //Report the event to analytics
        [SBGoogleAnalyticsHelper userLikedRecipeName:_selectedRecipe.recipeName];
        
    } else if (rightBarButton.selected){
        //Remove recipe from favorites in background thread
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [[RecipeManager sharedInstance]removeRecipeFromFavorites:self.selectedRecipe];
            
        });
        
        //Change the like button to unselected
        rightBarButton.selected = NO;
        
        //Report to analytics
        [SBGoogleAnalyticsHelper userDislikedRecipeName:_selectedRecipe.recipeName];
    }
    
    //Set the like button to not touchable to make the user not press it to often, causing animation to mess up
    isLikeButtonTouchable = NO;
    
    //Animate like if the like button is selected
    [self animateLike:rightBarButton.selected];
    
}

- (void) animateLike: (BOOL) like {
    
    //Save the original rect to use later
    CGRect originalRect = likeView.frame;
    
    [UIView animateWithDuration:0.7
                          delay:0.1
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^
     {
         
         //only animate if the recipe is liked
         if (like) {
             //Increase the alpha of the likeView
             likeView.alpha = 0.75;
         }
     }
                     completion:^(BOOL finished)
     {

         [UIView animateWithDuration:0.7
                               delay:0.1
                             options: UIViewAnimationOptionTransitionCrossDissolve
                          animations:^ {
             
             //If the recipe is liked, then make animation and move it to bottom center of screen
             if (like) {
                 [likeView setFrame:CGRectMake((self.view.frame.size.width / 2) - likeView.frame.size.width/2, self.view.frame.size.height, likeView.frame.size.width, likeView.frame.size.height)];
                 
                 //Decrease the alpha to 0
                 likeView.alpha = 0.0;
             }
        
         } completion:^(BOOL finished)
          {
            //Move back the likeView to the starting position for the next time the animation is used
              likeView.frame = originalRect;
              isLikeButtonTouchable = YES; //Set back to yes to be able to toggle like button
          }];
     }];
    
}

#pragma mark - Review

- (void) showReviewAlertToUser {
    
    //Show an alert to the user asking to review the app
    
    NSString *alertTitle = NSLocalizedString(@"LOCALIZE_Please rate", nil);
    NSString *alertText = NSLocalizedString(@"LOCALIZE_Give Feedback", nil);
    NSString *cancelText = NSLocalizedString(@"LOCALIZE_No, please don't ask again", nil); 
    NSString *laterText = NSLocalizedString(@"LOCALIZE_Later", nil);
    NSString *acceptText = NSLocalizedString(@"LOCALIZE_Rate", nil);
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:alertTitle message:alertText preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *acceptAction = [UIAlertAction actionWithTitle:acceptText style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        //Open the AppStore link for the user
        NSURL *appStoreUrl = [NSURL URLWithString:@"itms-apps://itunes.apple.com/us/app/smoothie-box-recipes-detox/id1057010706?l=sv&ls=1&mt=8"];
        if ([[UIApplication sharedApplication]canOpenURL:appStoreUrl]) {
            [[UIApplication sharedApplication]openURL:appStoreUrl];
        }
    
        //Update the NSUserDefault to show that the user has given review
        [AppReviewHelper dontShowAnyMoreReviewAlerts];
        
        //Register with Google Analytics
        [SBGoogleAnalyticsHelper reportEventWithCategory:@"Review" andAction:@"Rate the app" andLabel:@"YES" andValue:nil];
        
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelText style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
        //Update the NSUserDefault so that no more alerts are shown
        [AppReviewHelper dontShowAnyMoreReviewAlerts];
        
        //Register with Google Analytics
        [SBGoogleAnalyticsHelper reportEventWithCategory:@"Review" andAction:@"Rate the app" andLabel:@"NO" andValue:nil];
    
    }];
    
    UIAlertAction *laterAction = [UIAlertAction actionWithTitle:laterText style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){}];
    
    [alert addAction:acceptAction];
    [alert addAction:laterAction];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

#pragma mark - Selected recipe delegate

-(void)selectedRecipe:(Recipe *)newRecipe {
    
    [self setSelectedRecipe:newRecipe];
    [self viewDidLoad];
    
    NSLog(@"Changing selected recipe to: %@", newRecipe.recipeName);
    
    /*
    if (_selectedRecipe != newRecipe) {
        [self refreshUI];
        
        [self viewDidLoad];
        
    }
    
    */
    
}

#pragma mark - Detailed recipe view delegate

-(void)didSelectRecipe:(Recipe *)selectedRecipe {
    
    if (selectedRecipe != self.selectedRecipe) {
    
        [self setSelectedRecipe:selectedRecipe];
        
        NSLog(@"Selected recipe in detail view is now: %@", selectedRecipe.recipeName);
        [self refreshUI];
    
    }
    
}

/*
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
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return nutrientTypes.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NutrientCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    }
    
    //Present the most interesting nutrients facts
    
    switch (indexPath.row) {
        case 0:
            cell.nutrientType.text = NSLocalizedString(NUTRITION_CARBOHYDRATE, nil);
            //cell.nutrientValue.text = [_selectedRecipe volumeForNutrient:NUTRITION_CARBOHYDRATE asRoundedValue:YES];
            break;
        case 1:
            cell.nutrientType.text = NSLocalizedString(NUTRITION_FAT, nil);
            //cell.nutrientValue.text = [_selectedRecipe volumeStringForNutrient:NUTRITION_FAT];
            break;
        case 2:
            cell.nutrientType.text = NSLocalizedString(NUTRITION_PROTEIN, nil);
            //cell.nutrientValue.text = [_selectedRecipe volumeStringForNutrient:NUTRITION_PROTEIN];
            break;
        case 3:
            cell.nutrientType.text = NSLocalizedString(NUTRITION_FIBER, nil);
            //cell.nutrientValue.text = [_selectedRecipe volumeStringForNutrient:NUTRITION_FIBER];
            break;
        default:
            //After the manual nutrient facts start picking the ones that are in the array for nutrients to show
            cell.nutrientType.text = [nutrientTypes objectAtIndex:indexPath.row - 4];
            break;
    }
    
    
    cell.nutrientValue.text = [self.selectedRecipe volumeStringForNutrient:cell.nutrientType.text];
    cell.percentOfDailyIntake.text = [self.selectedRecipe percentOfDailyIntakeFor:cell.nutrientType.text];
    
    return cell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    float itemWidth;
    
    if (self.view.frame.size.width <= 375) {
        itemWidth = 100;
    } else if (self.view.frame.size.width <= 414) {
        itemWidth = self.view.frame.size.width / 4.5;
    } else {
        itemWidth = self.view.frame.size.width / 6.5;
    }
    
    return CGSizeMake(itemWidth, nutrientCollectionView.frame.size.height*0.85);
}
/*
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self.recipeCollectionView performBatchUpdates:nil completion:nil];
}
 
 
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



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    //Set the recipe to show nutrients for in the nutrition view controller
    //Also sets the recipe image
    NSString * segueName = segue.identifier;
    if ([segueName isEqualToString: @"recipeImage"]) {
        RecipeImageViewController *newVC = (RecipeImageViewController*)[segue destinationViewController];
        newVC.selectedRecipe = self.selectedRecipe;
        
    } else if ([segueName isEqualToString: @"shoppingListSegue"]) {
        RecipeShoppingListViewController *newVC = (RecipeShoppingListViewController*) [segue destinationViewController];
        newVC.selectedRecipe = self.selectedRecipe;
    }
}

@end
