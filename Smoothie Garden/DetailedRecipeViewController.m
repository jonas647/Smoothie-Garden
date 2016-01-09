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
#import "UIFont+FontSizeBasedOnScreenSize.h"
#import "NutrientFactPageViewRootViewController.h"
@interface DetailedRecipeViewController ()

@end

@implementation DetailedRecipeViewController
{
    
    NSString *recipeName;
    NSArray  *recipeInstructions;
    NSArray *ingredients;
    float latestContentOffset;
    BOOL isLikeButtonTouchable;
    
}

- (void) awakeFromNib {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //Set all the properties with correct values, print log if it can't be found
    if ([self.selectedRecipe.recipeName isKindOfClass:[NSString class]]) {
        titleName.text = self.selectedRecipe.recipeName;
    } else {
        NSLog(@"Wrong class for %@", titleName);
    }
    if ([self.selectedRecipe.detailedRecipedescription isKindOfClass:[NSString class]]) {
        //recipeDescriptionView.text = self.selectedRecipe.detailedRecipedescription;
    } else {
        //NSLog(@"Wrong class for %@", recipeDescriptionView);
    }
    if ([self.selectedRecipe.ingredients isKindOfClass:[NSArray class]]) {
        ingredients = self.selectedRecipe.ingredients;
    } else if ([self.selectedRecipe.detailedRecipedescription isKindOfClass:[NSArray class]]) {
        recipeInstructions = self.selectedRecipe.detailedRecipedescription;
    } else {
        NSLog(@"Wrong class for %@", ingredients);
    }
    
    //TODO why isn't this working above in the IF statement?
    recipeInstructions = [NSArray arrayWithArray:self.selectedRecipe.detailedRecipedescription];
    
    //Uncomment to Remove the navigation bar background for the detailed items
    /*
     [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    */
    
    recipeDescription.text = [self.selectedRecipe.recipeDescription objectAtIndex:0];
    
    //If the recipe is one of the favorites, then make the like button selected
    if ([self.selectedRecipe isRecipeFavorite]) {
        likeButton.selected = YES;
    } else
        NSLog(@"%@ not liked", self.selectedRecipe.recipeName);
    
    //Update the frame for the different UITextviews
    ingredientsTableView.frame =     [self newFrameForUIView:ingredientsTableView];
    recipeTableView.frame = [self newFrameForUIView:recipeTableView];
    
    recipeDescription.frame = [self newFrameForUIView:recipeDescription];
    
    //Update the height constraints to adjust the height to the new frames
    [ingredientsHeightConstraint setConstant:ingredientsTableView.frame.size.height];
    
    //Remove the title text from the back button (in the Detailed nutrient table view controller)
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
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
    
    
}


- (void) viewDidLayoutSubviews {
    
    
    likeView.layer.cornerRadius = likeView.bounds.size.width/2;//Make like view a circle
    likeView.alpha = 0.0;//Make like view hidden until the recipe is liked
    likeView.layer.masksToBounds = YES;
    
    //TODO
    //Fix the height of the recipe table view
    float totalTableHeight;
    for (int i = 0; i<recipeInstructions.count; i++) {
        totalTableHeight += [self tableView:recipeTableView heightForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
    }
    
    [recipeTableViewHeightConstraint setConstant:totalTableHeight];
    
    //Change font size based on screen size
    UILabel *by = [self.view viewWithTag:400];
    UILabel *smoothieBox = [self.view viewWithTag:401];
    
    [by setFont:[by.font fontSizeBasedOnScreenSize_fontBasedOnScreenSizeForFont:by.font withSize:LABEL_SIZE_TINY]];
    [smoothieBox setFont:[smoothieBox.font fontSizeBasedOnScreenSize_fontBasedOnScreenSizeForFont:smoothieBox.font withSize:LABEL_SIZE_TINY]];
    [titleName setFont:[titleName.font fontSizeBasedOnScreenSize_fontBasedOnScreenSizeForFont:titleName.font withSize:LABEL_SIZE_LARGE]];
    
    //Get the total height for the Blank background and the content view
    
    float heightForBlankBckgr = titleBackground.frame.size.height + ingredientsHeightConstraint.constant + recipeTableViewHeightConstraint.constant + titleName.frame.size.height;
    
    //Add 15% to make some space at bottom
    float heightForContentView = heightForBlankBckgr + recipeImageView.frame.size.height + 1.15;
    
    //TODO
    //Change the height so that it works with height constraints based on the views on screen
    
    //[blankBackgroundHeightConstraint setConstant:heightForBlankBckgr];
    //[contentViewHeightConstraint setConstant:heightForContentView];
    
    /*
    NSLog(@"Calculated height for Blank: %f", heightForBlankBckgr);
    NSLog(@"Caluclated height for Content: %f", heightForContentView);
    NSLog(@"Height for Blank: %f", blankBackgroundHeightConstraint.constant);
    NSLog(@"Height for Content: %f", contentViewHeightConstraint.constant);
     */
     
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Scrollview Delegates
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    /*
    //The limit for when the background should be non transparent
    float offsetLimit = recipeImage.frame.size.height;
    
    if(scrollView.contentOffset.y >= 0 && scrollView.contentOffset.y <= offsetLimit) {
        float percent = (scrollView.contentOffset.y / offsetLimit);
        whiteBackground.alpha = percent;
        
        //If the title background intersects the recipe image. Then it's scrolling up.
        //Make the recipe page view unscrollable by changing the z order
        //[self.view bringSubviewToFront:recipeScrollView];
        
    } else if (scrollView.contentOffset.y > offsetLimit){
        whiteBackground.alpha = 1;
        
    } else if (scrollView.contentOffset.y < 0) {
        // do other ... ;
        
    } else {
        //If the title is below the recipe image, then it should be possible to swipe the page view
        //[self.view bringSubviewToFront:recipeImageView];
    }
    
    //Never allow an alpha level of lower than 0.6
    if (whiteBackground.alpha < 0.60f) {
        whiteBackground.alpha = 0.60f;
    }
    
    //Check if the title background is at the top of screen. Then change alpha to make sure all other stuff scrolls under
    
    if (CGRectIntersectsRect(titleBackground.frame, topViewArea.frame)) {
        titleBackground.backgroundColor = [UIColor whiteColor];
    } else {
        titleBackground.backgroundColor = [UIColor clearColor];
    }
     
     */
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
    
        Ingredient *ingredientForRow = [ingredients objectAtIndex:indexPath.row];
    
        recipeQtyMeasure.text = [ingredientForRow stringWithQuantityAndMeasure];
        [recipeQtyMeasure.font fontSizeBasedOnScreenSize_fontBasedOnScreenSizeForFont:recipeQtyMeasure.font withSize:LABEL_SIZE_SMALL];
        
        recipeIngredientText.text = [ingredientForRow stringWithIngredientText];
        [recipeIngredientText.font fontSizeBasedOnScreenSize_fontBasedOnScreenSizeForFont:recipeIngredientText.font withSize:LABEL_SIZE_SMALL];
        
        
    } else if ([tmpTableView isEqual:recipeTableView]) {
    
        UILabel *recipeText = (UILabel*)[cell viewWithTag:300];
        recipeText.text = [recipeInstructions objectAtIndex:indexPath.row];
        [recipeText.font fontSizeBasedOnScreenSize_fontBasedOnScreenSizeForFont:recipeText.font withSize:LABEL_SIZE_SMALL];
    }
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = (UITableViewCell *)[self tableView:(tableView) cellForRowAtIndexPath:indexPath];
    
    if ([tableView isEqual:recipeTableView]) {
        //Check the height of the label that populates the cell and resize the cell height after that
        
        UILabel *resizableLabel = (UILabel*)[cell viewWithTag:300];
        
        //Add margins to the cell height
        float cellMargin = cell.frame.size.height;
        
        
        return [self labelHeightFor:resizableLabel andScreenSize:LABEL_SIZE_LARGE] + cellMargin;
        
    
    } else if ([tableView isEqual:ingredientsTableView]) {
        //Return the size of the cell. All cells are the same height
        
        int ingredientText = 200;
        int volumeText = 201;
        
        UILabel *ingredientLabel = (UILabel*)[cell viewWithTag:ingredientText];
        UILabel *volumeLabel = (UILabel*)[cell viewWithTag:volumeText];
        
        float heightForIngredientLabel = [self labelHeightFor:ingredientLabel andScreenSize:LABEL_SIZE_SMALL];
        float heightForVolumeLabel = [self labelHeightFor:volumeLabel andScreenSize:LABEL_SIZE_SMALL];
        
        float highestLabel = MAX(heightForIngredientLabel, heightForVolumeLabel);
        return highestLabel;
    } else
        return 0;
    
}

- (float) labelHeightFor: (UILabel*) label andScreenSize: (int) screenSize{
    
    //Need to split the width of the label to get a proper height. Not sure why...
    UILabel *newLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, label.frame.size.width/2, CGFLOAT_MAX)];
    newLabel.numberOfLines = 0;
    newLabel.lineBreakMode = NSLineBreakByWordWrapping;
    newLabel.text = label.text;
    [newLabel.font fontSizeBasedOnScreenSize_fontBasedOnScreenSizeForFont:label.font withSize:screenSize];
    [newLabel sizeToFit];
    
    return newLabel.frame.size.height;
    
}

#pragma mark - Handle Recipe Favorites

- (IBAction)likeRecipe:(id)sender {
    
    if (!isLikeButtonTouchable) {
        //If the like button isn't touchable, then don't do anything
        return;
    }
    
    if (!likeButton.selected) {
        
        //Add recipe to the favorites
        [self.selectedRecipe addRecipeToFavorites];
        
        //Change the like button to selected
        likeButton.selected = YES;
        
        //Report the event to analytics
        [SBGoogleAnalyticsHelper userLikedRecipeName:_selectedRecipe.recipeName];
        
    } else if (likeButton.selected){
        //Remove recipe from favorites
        [Recipe removeRecipeFromFavoritesUsingRecipeName:self.selectedRecipe.recipeName];
        
        //Change the like button to unselected
        likeButton.selected = NO;
        
        //Report to analytics
        [SBGoogleAnalyticsHelper userDislikedRecipeName:_selectedRecipe.recipeName];
    }
    
    //Animate like if the like button is selected
    [self animateLike:likeButton.selected];
    
    //Set the like button to not touchable to make the user not press it to often, causing animation to mess up
    isLikeButtonTouchable = NO;
}

- (IBAction)nutritionFacts:(id)sender {
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
    
    NSString *alertTitle = @"Please rate Smoothie Box";
    NSString *alertText = @"If you like Smoothie Box, please give your feedback and rate us";
    NSString *cancelText = @"No, please don't ask again";
    NSString *laterText = @"Later";
    NSString *acceptText = @"Rate";
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:alertTitle message:alertText preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *acceptAction = [UIAlertAction actionWithTitle:acceptText style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        //Open the AppStore link for the user
        NSURL *appStoreUrl = [NSURL URLWithString:@"itms-apps://itunes.apple.com/app/1057010706"];
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
        
    }
}

@end
