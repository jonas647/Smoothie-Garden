//
//  DetoxViewController.m
//  Smoothie Box
//
//  Created by Jonas C Björkell on 2016-01-14.
//  Copyright © 2016 Jonas C Björkell. All rights reserved.
//

#define LABEL_SIZE_LARGE 1
#define LABEL_SIZE_SMALL 2

#define NINE_AM_SMOOTHIE @"LOCALIZE_9 AM"
#define TWELVE_AM_SMOOTHIE @"LOCALIZE_12 AM"
#define FOUR_PM_SMOOTHIE @"LOCALIZE_4 PM"
#define SEVEN_PM_SMOOTHIE @"LOCALIZE_7 PM"

#import "DetoxViewController.h"
#import "Recipe.h"
#import "RecipeManager.h"
#import "DetoxTableViewCell.h"
#import "SBGoogleAnalyticsHelper.h"
#import "SWRevealViewController.h"
#import "DetailedRecipeViewController.h"
#import "TraitCollectionOverrideViewController.h"
#import "DeviceHelper.h"

@interface DetoxViewController ()
{
    Recipe *nineAM;
    Recipe *twelveAM;
    Recipe *fourPM;
    Recipe *sevenPM;
    
    NSArray *allRecipes;
    NSDictionary *thumbnailImages;
    NSArray *sectionCategories;
    
    UIView *viewForSelectedButton;
    
    float titleFontSize;
    float descriptionFontSize;
}

@end

@implementation DetoxViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Needed not to show the navigation bar as black for a second when returning from recipe
    self.navigationController.view.backgroundColor = [UIColor whiteColor];
    
    //Load here to show user view before recipes are fully loaded
    allRecipes = [[RecipeManager sharedInstance]recipesMaster];
    
    sectionCategories = @[NINE_AM_SMOOTHIE,TWELVE_AM_SMOOTHIE,FOUR_PM_SMOOTHIE,SEVEN_PM_SMOOTHIE];
    
    thumbnailImages = [[RecipeManager sharedInstance]thumbnailImages];
    
    [self setupDetoxDayFor:@"Day1"];
    
    //CGRect tempFrame = [self newFrameForUIView:_tableView];
    //[_tableViewHeightConstraint setConstant:tempFrame.size.height + 100];
    
    if (self.revealViewController != nil) {
        
        [self.view addGestureRecognizer:[self.revealViewController panGestureRecognizer]];
        
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
        
    }
    
    //Report to Analytics
    [SBGoogleAnalyticsHelper reportScreenToAnalyticsWithName:@"Detox Screen"];
    
    //Remove the title text from the back button (in the Detailed recipe table view controller)
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    //Need to change the backgroundcolor here. If changed in the appdelegate it's also added to the transparent navigation bars
    //UIColor *mainColor = [UIColor colorWithRed:248.0f/255.0f green:248.0f/255.0f blue:245.0f/255.0f alpha:1.0f];
    //[self.navigationController.navigationBar setBackgroundColor:mainColor];
    
    //Set the text sizes depending on device
    if ([[DeviceHelper sharedInstance] isDeviceIphone4] || [[DeviceHelper sharedInstance] isDeviceIphone5]) {
        
        titleFontSize = 16;
        descriptionFontSize = 13;
        
    } else if ([[DeviceHelper sharedInstance] isDeviceIphone6]) {
        
        titleFontSize = 20;
        descriptionFontSize = 18;
        
    } else if ([[DeviceHelper sharedInstance] isDeviceIphone6plus]) {
        
        titleFontSize = 24;
        descriptionFontSize = 21;
        
    } else if ([[DeviceHelper sharedInstance] isDeviceIpad]) {
        
        //Just to test on simulator
        titleFontSize = 25;
        descriptionFontSize = 24;
        
    } else if ([[DeviceHelper sharedInstance] isDeviceSimulator]) {
        
        //Just to test on simulator
        titleFontSize = 24;
        descriptionFontSize = 21;
        
    }  else {
        
        // If a new device is released before the app is updated
        titleFontSize = 14;
        descriptionFontSize = 10;
    }
    
    //Update table view height dynamically
    self.tableView.estimatedRowHeight = 180;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    [self.tableView reloadData];
    [self.tableView layoutIfNeeded];
    
    self.tableViewHeightConstraint.constant = self.tableView.contentSize.height + 250;
    
}

- (void) viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    //Set the introduction text font based on device
    self.introductionText.font = [UIFont fontWithName:self.introductionText.font.fontName size:titleFontSize+2];
    //[self.introductionText sizeToFit];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
    //Reset the navigation bar, set back to being shown
    //Is hidden in the detailed recipe view
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = NO;
    
    
    
    //Remove the selection of the previously selected table cell. Make the deselection here to show the user the previously selected cell with a short "blink".
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    //[_tableView reloadData];
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

    
    //Update the background color of the previous view
    [currentView setBackgroundColor:[UIColor clearColor]];
    
    //Update color of the next view
    [nextView setBackgroundColor:backgroundColor];
    
    //Keep track of the new selected button/view
    viewForSelectedButton = nextView;
    
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString* selectedCategory = [sectionCategories objectAtIndex: indexPath.section];
    Recipe *selectedRecipe = [self recipeForCategory:selectedCategory];
    [self performSegueWithIdentifier:@"showDetoxRecipeSegue" sender:selectedRecipe];
    
    /*
     Not in use now since IAP not active
    NSString* selectedCategory = [sectionCategories objectAtIndex: indexPath.section];
    Recipe *selectedRecipe = [self recipeForCategory:selectedCategory];

    if ([selectedRecipe isRecipeUnlocked]) {
        //Move to screen that shows the recipe
        [self performSegueWithIdentifier:@"showDetoxRecipeSegue" sender:selectedRecipe];
    } else if (![selectedRecipe isRecipeUnlocked]) {
        //Move to screen for in app purchases
        [self performSegueWithIdentifier:@"InAppPurchaseDetoxSegue" sender:nil];
    }
    
    */
}

- (Recipe*) recipeWithRecipeName: (NSString*) name {
    
    for (Recipe *rec in allRecipes) {
        if ([rec.recipeName isEqualToString:name]) {
            return rec;
        }
    }
    
    return nil;
    
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
    //Return the localized string with the time of the day
    return NSLocalizedString([sectionCategories objectAtIndex:section], @"Time of day");
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
    Recipe *recipeToShow = [self recipeForCategory:category];
    
    
    // Configure the cell...
    cell.selectedRecipe = recipeToShow;
    
    cell.recipeTitle.text = recipeToShow.recipeName;
    cell.recipeDescription.text = recipeToShow.shortDescription;
    
    cell.recipeTitle.font = [UIFont fontWithName:cell.recipeTitle.font.fontName size:titleFontSize];
    cell.recipeDescription.font = [UIFont fontWithName:cell.recipeDescription.font.fontName size:descriptionFontSize];
    
    //Get the UIImage from memory, stored in a NSDictionary
    cell.recipeImage.image = [thumbnailImages objectForKey:recipeToShow.recipeName];
    
    return cell;
}

- (Recipe*) recipeForCategory: (NSString*) category {
    
    Recipe *recipeToReturn;
    
    if ([category isEqualToString:NINE_AM_SMOOTHIE]) {
        recipeToReturn = nineAM;
    } else if ([category isEqualToString:TWELVE_AM_SMOOTHIE]) {
        recipeToReturn = twelveAM;
    } else if ([category isEqualToString:FOUR_PM_SMOOTHIE]) {
        recipeToReturn = fourPM;
    } else if ([category isEqualToString:SEVEN_PM_SMOOTHIE]) {
        recipeToReturn = sevenPM;
    }
    return recipeToReturn;
    
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
    
    //Reload table in order to set correct frames for all views
    [self.tableView setNeedsLayout];
    [self.tableView layoutIfNeeded];
    [self.tableView reloadData];
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    
    if ([segue.destinationViewController isKindOfClass:[TraitCollectionOverrideViewController class]]) {
        
        TraitCollectionOverrideViewController *vcToPushTo = (TraitCollectionOverrideViewController*)segue.destinationViewController;
        
        vcToPushTo.selectedRecipe = (Recipe*)sender;
        
    } 
    
}


@end
