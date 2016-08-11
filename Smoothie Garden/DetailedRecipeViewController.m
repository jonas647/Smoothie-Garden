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

#import "DetailedRecipeViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "SBGoogleAnalyticsHelper.h"
#import "AppReviewHelper.h"
#import "Ingredient.h"
#import "RecipeManager.h"
#import "NutrientFactPageViewRootViewController.h"
#import "RecipeShoppingListViewController.h"
#import "DeviceHelper.h"

@interface DetailedRecipeViewController ()

@end

@implementation DetailedRecipeViewController
{
    
    NSString *recipeName;
    NSArray  *recipeInstructions;
    NSArray *recipeDescriptions;
    NSArray *ingredients;
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

- (void)viewWillLayoutSubviews {
    
    // Call super class to make the views layout. Needed for the in-call status bar to get correct position vs. UIViews
    [super viewWillLayoutSubviews];
}


- (void)viewDidLoad {
    [super viewDidLoad];
   
    
    ingredients = self.selectedRecipe.ingredients;
    recipeInstructions = self.selectedRecipe.instructions;
    recipeDescriptions = self.selectedRecipe.longDescription;
    
    //If the recipe is one of the favorites, then make the like button selected
    if ([[RecipeManager sharedInstance]isRecipeFavorite:self.selectedRecipe]) {
        [rightBarButton setSelected:YES];
    }
    
    //Remove the title text from the back button (in the Detailed nutrient table view controller)
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    
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
    
    
    //Hide the navigation bar
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc]init];
    UIImage *tempImage = [[UIImage alloc]init];
    [self.navigationController.navigationBar setBackgroundImage:tempImage forBarMetrics:UIBarMetricsDefault];
    
    //The like button needs to be touchable to start with
    isLikeButtonTouchable = YES;
    
    //Report to analytics
    [SBGoogleAnalyticsHelper reportScreenToAnalyticsWithName:[NSString stringWithFormat:@"Recipe %@", _selectedRecipe.recipeName]];
    
    //Ask for review
    if ([AppReviewHelper shouldShowReviewAlert]) {
        
        [self performSelector:@selector(showReviewAlertToUser) withObject:nil afterDelay:0.5f];
        
    }
    
    //Hide the servings view if almond milk is shown since this is for one liter
    if ([self.selectedRecipe.recipeName isEqualToString:@"Almond milk"]) {
        servingView.hidden = YES;
    }
    
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
        
    } else if ([[DeviceHelper sharedInstance] isDeviceSimulator]) {
        
        //Just to test on simulator
        sizeForByText = 11;
        sizeForSmoothieBoxText = 14;
        sizeForTitleText = 26;
        sizeForRecipeDescriptions = 21;
        sizeForShoppingListText = 15;
        marginBetweenTextCells = 35;
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
    longDescriptionTable.rowHeight = UITableViewAutomaticDimension;;
    
}


- (void) viewDidLayoutSubviews {
    
    //Update the height constraints to fit the contents
    ingredientsHeightConstraint.constant = ingredientsTableView.contentSize.height;
    recipeTableViewHeightConstraint.constant = recipeTableView.contentSize.height;
    longDescriptionTableHeightConstraint.constant = longDescriptionTable.contentSize.height;
    
    [ingredientsTableView layoutIfNeeded];
    [recipeTableView layoutIfNeeded];
    [longDescriptionTable layoutIfNeeded];
    
    //Set the likeview attributes (shows when a recipe is liked)
    likeView.layer.cornerRadius = likeView.bounds.size.width/2;//Make like view a circle
    likeView.alpha = 0.0;//Make like view hidden until the recipe is liked
    likeView.layer.masksToBounds = YES;
    
    //The title of the view should be the recipe title
    titleName.text = self.selectedRecipe.recipeName;
    
    //Change font size based on screen size. If another screen, then just go with what the storyboard says
    UILabel *by = [self.view viewWithTag:400];
    UILabel *smoothieBox = [self.view viewWithTag:401];
    
    [self setFontSizeForLabel:by size:sizeForByText];
    [self setFontSizeForLabel:smoothieBox size:sizeForSmoothieBoxText];
    [self setFontSizeForLabel:titleName size:sizeForTitleText];
    [self setFontSizeForLabel:shoppingListButton.titleLabel size:sizeForShoppingListText];
    
    //Set the height constraint of where the title should begin. Below the image.
    [blankBackgroundToTop setConstant:0.8*[UIScreen mainScreen].bounds.size.height];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    //Set the recipe to show nutrients for in the nutrition view controller
    NSString * segueName = segue.identifier;
    if ([segueName isEqualToString: @"embedNutritionSegue"]) {
        NutrientFactPageViewRootViewController *newVC = (NutrientFactPageViewRootViewController*)[segue destinationViewController];
        newVC.selectedRecipe = self.selectedRecipe;
        
    } else if ([segueName isEqualToString: @"shoppingListSegue"]) {
        RecipeShoppingListViewController *newVC = (RecipeShoppingListViewController*) [segue destinationViewController];
        newVC.selectedRecipe = self.selectedRecipe;
    }
}

@end
