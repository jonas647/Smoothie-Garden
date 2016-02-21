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
#import "DetoxTableViewCell.h"
#import "UIFont+FontSizeBasedOnScreenSize.h"
#import "SBGoogleAnalyticsHelper.h"
#import "SWRevealViewController.h"
#import "DetailedRecipeViewController.h"

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
    
    
    
    //Remove the title text from the back button (in the Detailed recipe table view controller)
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    //Need to change the backgroundcolor here. If changed in the appdelegate it's also added to the transparent navigation bars
    //UIColor *mainColor = [UIColor colorWithRed:248.0f/255.0f green:248.0f/255.0f blue:245.0f/255.0f alpha:1.0f];
    //[self.navigationController.navigationBar setBackgroundColor:mainColor];
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //Load here to show user view before recipes are fully loaded
    allRecipes = [Recipe recipeMaster];
    
    sectionCategories = @[NINE_AM_SMOOTHIE,TWELVE_AM_SMOOTHIE,FOUR_PM_SMOOTHIE,SEVEN_PM_SMOOTHIE];
    
    [self setupDetoxDayFor:@"Day1"];
    
    thumbnailImages = [[NSMutableDictionary alloc]init];
    for (Recipe *r in allRecipes) {
        UIImage *tempImage = [self createThumbnailForImageWithName:r.imageName];
        if (tempImage != nil) {
            [thumbnailImages setObject:tempImage forKey:r.recipeName];
        } else {
            NSLog(@"Recipe image is nil");
        }
        
    }
    
    _tableView.frame = [self newFrameForUIView:_tableView];
    [_tableViewHeightConstraint setConstant:_tableView.frame.size.height];
    
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

    if ([selectedRecipe isRecipeUnlocked]) {
        //Move to screen that shows the recipe
        [self performSegueWithIdentifier:@"showDetoxRecipeSegue" sender:selectedRecipe];
    } else if (![selectedRecipe isRecipeUnlocked]) {
        //Move to screen for in app purchases
        [self performSegueWithIdentifier:@"InAppPurchaseDetoxSegue" sender:nil];
    }
    
    
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
    
    
    return [self customCellForRecipe:recipeToShow inTableView:tableView withTableViewCellIdentifier:tableCellIdentifier];
    
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

- (DetoxTableViewCell*) customCellForRecipe: (Recipe*) sRecipe inTableView: (UITableView*) tableView withTableViewCellIdentifier: (NSString*) cellIdentifier {
    
    DetoxTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    // Configure the cell...
    
    if (cell == nil) {
        cell = [[DetoxTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.recipeTitle.text = sRecipe.recipeName;
    cell.recipeDescription.text = sRecipe.shortDescription;
    
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

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.destinationViewController isKindOfClass:[DetailedRecipeViewController class]]) {
        
        DetailedRecipeViewController *vcToPushTo = (DetailedRecipeViewController*)segue.destinationViewController;
        vcToPushTo.selectedRecipe = (Recipe*)sender;
        
    }
    
}


@end
