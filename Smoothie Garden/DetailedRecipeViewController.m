//
//  DetailedRecipeViewController.m
//  Smoothie Garden
//
//  Created by Jonas C Björkell on 2015-08-09.
//  Copyright (c) 2015 Jonas C Björkell. All rights reserved.
//

#import "DetailedRecipeViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ArchivingObject.h"

@interface DetailedRecipeViewController ()

@end

@implementation DetailedRecipeViewController
{
    
    NSString *recipeName;
    NSArray  *recipeInstructions;
    NSArray *ingredients;
    ArchivingObject *archivingHelper;
    float latestContentOffset;
    
}

- (void) awakeFromNib {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //Set all the properties with correct values, print log if it can't be found
    if ([UIImage imageNamed:[NSString stringWithFormat:@"%@.png", self.selectedRecipe.imageName]]) {
        recipeImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", self.selectedRecipe.imageName]];
    } else {
        NSLog(@"Wrong class for %@", recipeImage);
    }
    if ([self.selectedRecipe.recipeName isKindOfClass:[NSString class]]) {
        titleName.text = self.selectedRecipe.recipeName;
    } else {
        NSLog(@"Wrong class for %@", titleName);
    }
    if ([self.selectedRecipe.detailedRecipedescription isKindOfClass:[NSString class]]) {
        recipeDescriptionView.text = self.selectedRecipe.detailedRecipedescription;;
    } else {
        NSLog(@"Wrong class for %@", recipeDescriptionView);
    }
    if ([self.selectedRecipe.boosterDescription isKindOfClass:[NSString class]]) {
        boosterDescriptionView.text = self.selectedRecipe.boosterDescription;
    } else {
        NSLog(@"Wrong class for %@", boosterDescriptionView);
    }
    if ([self.selectedRecipe.ingredients isKindOfClass:[NSArray class]]) {
        ingredients = self.selectedRecipe.ingredients;
    } else {
        NSLog(@"Wrong class for %@", ingredients);
    }
    
    //Uncomment to Remove the navigation bar background for the detailed items
    /*
     [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    */
    
    //If the recipe is one of the favorites, then make the like button selected
    if ([[archivingHelper favoriteRecipes]containsObject:self.selectedRecipe.recipeName]) {
        likeButton.selected = YES;
    }
    
    //Must do this for the UITextview to work with (1) resizing height, (2) have custom font
    [recipeDescriptionView sizeToFit];
    [recipeDescriptionView layoutIfNeeded];
    recipeDescriptionView.layoutManager.allowsNonContiguousLayout = false;
    
    [boosterDescriptionView sizeToFit];
    [boosterDescriptionView layoutIfNeeded];
    boosterDescriptionView.layoutManager.allowsNonContiguousLayout = false;
    
    recipeDescriptionView.scrollEnabled = NO;
    boosterDescriptionView.scrollEnabled = NO;
    
    //Update the frame for the different UITextviews
    ingredientsTableView.frame =     [self newFrameForUIView:ingredientsTableView];
    recipeDescriptionView.frame =    [self newFrameForUIView:recipeDescriptionView];
    boosterDescriptionView.frame =   [self newFrameForUIView:boosterDescriptionView];
    
    
    //Set the vertical spacing of the whitebackground to the height of the recipe image to make it positioned just under it
    //TODO change this to be dependent on the height of the image instead
    [whiteBackgroundVerticalPositioningConstraint setConstant:self.view.frame.size.width*0.8];
    
    //Update the height constraints to adjust the height to the new frames
    [ingredientsHeightConstraint setConstant:ingredientsTableView.frame.size.height];
    [recipeDescriptionHeightConstraint setConstant:recipeDescriptionView.frame.size.height];
    [boosterDescriptionHeightConstraint setConstant:boosterDescriptionView.frame.size.height];
    
    //Must have the view as selectable in storyboard to get the font working (Apple bug)
    recipeDescriptionView.selectable = NO;
    boosterDescriptionView.selectable = NO;
    
    //Setup the archiving object
    archivingHelper = [[ArchivingObject alloc]init];
    
    //[contentViewHeightConstraint setConstant:(ingredientsTableView.frame.size.height + recipeDescriptionView.frame.size.height +boosterDescriptionView.frame.size.height)];
    NSLog(@"Content view height: %f", contentViewHeightConstraint.constant);
    NSLog(@"White background height: %f", whiteBackgroundVerticalPositioningConstraint.constant);
    NSLog(@"Image height: %f", recipeImage.frame.size.height);
    
    //Hide the navigation bar
    /*
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
     */
    
    //Hide the navigation bar
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc]init];
    UIImage *tempImage = [[UIImage alloc]init];
    [self.navigationController.navigationBar setBackgroundImage:tempImage forBarMetrics:UIBarMetricsDefault];
    
    //Change status bar appearance
}

- (void) viewWillAppear:(BOOL)animated {
    
    
    
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

#pragma mark - Delegates
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    //TODO
    //Change this to be dependent on the image instead
    float offsetLimit = self.view.frame.size.width*0.75;
    
    if(scrollView.contentOffset.y >= 0 && scrollView.contentOffset.y <= offsetLimit) {
        float percent = (scrollView.contentOffset.y / offsetLimit);
        whiteBackground.alpha = percent;
        
    } else if (scrollView.contentOffset.y > offsetLimit){
        whiteBackground.alpha = 1;
        //float percent = (scrollView.contentOffset.y / 150.0);
        
    } else if (scrollView.contentOffset.y < 0) {
        // do other ... ;
    }
    
    //Never allow an alpha level of lower than 0.6
    if (whiteBackground.alpha<0.60f) {
        whiteBackground.alpha = 0.60f;
    }
    
}

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

#pragma mark - Handle Recipe Favorites

- (IBAction)likeRecipe:(id)sender {
    
    if (!likeButton.selected) {
        
        //Add recipe to the favorites
        [archivingHelper addRecipeToFavorites:self.selectedRecipe];
        
        //Change the like button to selected
        likeButton.selected = YES;
        
    } else if (likeButton.selected){
        //Remove recipe from favorites
        [archivingHelper removeRecipeFromFavorites:self.selectedRecipe];
        
        //Change the like button to unselected
        likeButton.selected = NO;
    }
    
    [self animateLikeButton];
}

- (void) animateLikeButton {
    
    CGRect likeButtonFrame = likeButton.frame;
    
    [UIView animateWithDuration:1.5
                          delay:0.1
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^
     {
         [likeButton setFrame:CGRectMake(likeButtonFrame.origin.x, likeButtonFrame.origin.y, likeButtonFrame.size.width*2, likeButtonFrame.size.height*2)];
     }
                     completion:^(BOOL finished)
     {
         //[likeButton setFrame:likeButtonFrame];
     }];
    
}




@end
