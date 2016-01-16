//
//  DetoxViewController.m
//  Smoothie Box
//
//  Created by Jonas C Björkell on 2016-01-14.
//  Copyright © 2016 Jonas C Björkell. All rights reserved.
//

#define LABEL_SIZE_LARGE 1
#define LABEL_SIZE_SMALL 2

#define NINE_AM_SMOOTHIE @"9 AM Smoothie"
#define TWELVE_AM_SMOOTHIE @"12 AM Smoothie"
#define FOUR_PM_SMOOTHIE @"4 PM Smoothie"
#define SEVEN_PM_SMOOTHIE @"7 PM Smoothie"


#import "DetoxViewController.h"
#import "Recipe.h"
#import "DetoxTableViewCell.h"
#import "UIFont+FontSizeBasedOnScreenSize.h"
#import "SBGoogleAnalyticsHelper.h"
#import "SWRevealViewController.h"

@interface DetoxViewController ()
{
    Recipe *nineAM;
    Recipe *twelveAM;
    Recipe *fourPM;
    Recipe *sevenPM;
    
    NSArray *allRecipes;
    NSMutableDictionary *thumbnailImages;
    NSArray *sectionCategories;
    
    UIView *viewForSelectedButton;
}

@end

@implementation DetoxViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (self.revealViewController != nil) {
        
        [self.view addGestureRecognizer:[self.revealViewController panGestureRecognizer]];
        
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
        
    }
    
    //Report to Analytics
    [SBGoogleAnalyticsHelper reportScreenToAnalyticsWithName:@"Detox Screen"];
    
    allRecipes = [Recipe allRecipesFromPlist];
    sectionCategories = @[NINE_AM_SMOOTHIE,TWELVE_AM_SMOOTHIE,FOUR_PM_SMOOTHIE,SEVEN_PM_SMOOTHIE];
    
    [self setupDetoxDayFor:@"Day1"];
    
    thumbnailImages = [[NSMutableDictionary alloc]init];
    for (Recipe *r in allRecipes) {
        UIImage *tempImage = [self createThumbnailForImageWithName:r.imageName];
        [thumbnailImages setObject:tempImage forKey:r.recipeName];
    }
}

- (void)setupDetoxDayFor:(NSString*) day {
    
    NSString *filepath = [[NSBundle mainBundle] pathForResource:@"Detox" ofType:@"plist"];
    NSDictionary *tempDetoxDictionary = [NSDictionary dictionaryWithContentsOfFile:filepath];
    
    for (NSDictionary *dic in tempDetoxDictionary) {
        
        NSString *dicString = [NSString stringWithFormat:@"%@", dic];
        if ([dicString isEqualToString:day]) {
            
            nineAM = [self recipeWithRecipeName:[[tempDetoxDictionary objectForKey:dic] objectForKey:@"9AM"]];
            twelveAM = [self recipeWithRecipeName:[[tempDetoxDictionary objectForKey:dic] objectForKey:@"12AM"]];
            fourPM = [self recipeWithRecipeName:[[tempDetoxDictionary objectForKey:dic] objectForKey:@"4PM"]];
            sevenPM = [self recipeWithRecipeName:[[tempDetoxDictionary objectForKey:dic] objectForKey:@"7PM"]];
            
        }
    }
    
    //Update the background colors for the parent view of the button
    [self changeBackgroundColorOfButtonWhenSelected:day];
    
    [_tableView reloadData];
}

- (void) changeBackgroundColorOfButtonWhenSelected: (NSString*) day {
    
    UIColor *backgroundColor = [UIColor groupTableViewBackgroundColor];
    UIView *currentView = viewForSelectedButton;
    UIView *nextView;
    
    //Get the next view to select, what button's selected
    if ([day isEqualToString:@"Day1"]) {
        nextView = _day1View;
    } else if ([day isEqualToString:@"Day2"]) {
        nextView = _day2View;
    } else if ([day isEqualToString:@"Day3"]) {
        nextView = _day3View;
    }
    
    //Update color of the next view
    [nextView setBackgroundColor:backgroundColor];
    
    
    //Make the previously selected button fade out and the new one fade in
    if (nextView != viewForSelectedButton) {
     
        [nextView setAlpha:0.0f];
    }
    [UIView animateWithDuration: 1.0 animations:^{
        [nextView setAlpha:1.0f];
        [currentView setAlpha:0.0f];
    }];
    
    
    //Update the background color of the previous view
    [currentView setBackgroundColor:[UIColor clearColor]];
    [currentView setAlpha:1.0f];
    
    //Keep track of the new selected button/view
    viewForSelectedButton = nextView;
    
}

- (Recipe*) recipeWithRecipeName: (NSString*) name {
    
    for (Recipe *rec in allRecipes) {
        if ([rec.recipeName isEqualToString:name]) {
            return rec;
        }
    }
    
    return nil;
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    _tableView.frame = [self newFrameForUIView:_tableView];
    [_tableViewHeightConstraint setConstant:_tableView.frame.size.height];
    
    //Reset the navigation bar, set back to being shown
    //Is hidden in the detailed recipe view
    [self.navigationController.navigationBar setBackgroundImage:nil
                                                  forBarMetrics:UIBarMetricsDefault];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGRect) newFrameForUIView: (UIView* ) view {
    
    //Change the height of the UIView
    CGFloat fixedWidth = view.frame.size.width;
    CGSize newSize = [view sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = view.frame;
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
    
    return newFrame;
}




#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return sectionCategories.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
        return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    return [sectionCategories objectAtIndex:section];
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    UITableViewHeaderFooterView *v = (UITableViewHeaderFooterView *)view;
    v.backgroundView.backgroundColor = [UIColor groupTableViewBackgroundColor];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *tableCellIdentifier = @"DetoxTableCell";
    
    DetoxTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableCellIdentifier];
    if (cell == nil)
    {
        cell = [[DetoxTableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:tableCellIdentifier];
    }
    
    NSString* category = [sectionCategories objectAtIndex: indexPath.section];
    Recipe *recipeToShow;
    if ([category isEqualToString:NINE_AM_SMOOTHIE]) {
        recipeToShow = nineAM;
    } else if ([category isEqualToString:TWELVE_AM_SMOOTHIE]) {
        recipeToShow = twelveAM;
    } else if ([category isEqualToString:FOUR_PM_SMOOTHIE]) {
        recipeToShow = fourPM;
    } else if ([category isEqualToString:SEVEN_PM_SMOOTHIE]) {
        recipeToShow = sevenPM;
    }
    
    
    return [self customCellForRecipe:recipeToShow inTableView:tableView withTableViewCellIdentifier:tableCellIdentifier];
    
}

- (DetoxTableViewCell*) customCellForRecipe: (Recipe*) sRecipe inTableView: (UITableView*) tableView withTableViewCellIdentifier: (NSString*) cellIdentifier {
    
    DetoxTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    // Configure the cell...
    
    if (cell == nil) {
        cell = [[DetoxTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.recipeTitle.text = sRecipe.recipeName;
    cell.recipeDescription.text = sRecipe.RecipeOverviewDescription;
    
    //[cell.recipeTitle setFont:[cell.recipeTitle.font fontSizeBasedOnScreenSize_fontBasedOnScreenSizeForFont:cell.recipeTitle.font withSize:LABEL_SIZE_LARGE]];
    //[cell.recipeDescription setFont:[cell.recipeDescription.font fontSizeBasedOnScreenSize_fontBasedOnScreenSizeForFont:cell.recipeDescription.font withSize:LABEL_SIZE_SMALL]];
    
    [cell.recipeTitle sizeToFit];
    [cell.recipeDescription sizeToFit];
    
    //Removed this since it's taking to long and not efficient for the app to create UIImage here
    //cell.recipeImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", recipeForRow.imageName]];
    
    //Instead get the UIImage from memory, stored in a NSDictionary
    cell.recipeImage.image = [thumbnailImages objectForKey:sRecipe.recipeName];
    
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

#pragma mark - Switch days

- (IBAction)changeDay:(id)sender {
    
    if ([sender tag] == 1) {
        [self setupDetoxDayFor:@"Day1"];
    } else if ([sender tag] == 2) {
        [self setupDetoxDayFor:@"Day2"];
    } else if ([sender tag] == 3) {
        [self setupDetoxDayFor:@"Day3"];
    }
}
@end
