//
//  SettingsTableViewController.m
//  Smoothie Garden
//
//  Created by Jonas C Björkell on 2015-10-13.
//  Copyright © 2015 Jonas C Björkell. All rights reserved.
//

#import "SettingsTableViewController.h"
#import "SWRevealViewController.h"
#import "SBIAPHelper.h"
#import "ArchivingObject.h"
#import "SBActivityIndicatorView.h"
#import "SBGoogleAnalyticsHelper.h"


#import "Recipe.h"

@interface SettingsTableViewController ()

@end

@implementation SettingsTableViewController
{
    SBActivityIndicatorView *loadingIndicator;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    if (self.revealViewController != nil) {
        
        [self.view addGestureRecognizer:[self.revealViewController panGestureRecognizer]];
        
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
        
    }
    
    //Update switch button
    
    if ([SBGoogleAnalyticsHelper isAnalyticsEnabled]) {
        NSLog(@"Switch is on");
        [_analyticsSwitch setOn:YES];
    } else {
        [_analyticsSwitch setOn:NO];
        NSLog(@"Switch is off");
    }
    
    
    
    //Report to Analytics
    [SBGoogleAnalyticsHelper reportScreenToAnalyticsWithName:@"Settings Screen"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 0;
}
*/
/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void) purchaseRestored: (NSNotification*) notification {
    
    NSString * productIdentifier = notification.object;
    
    //Use the archiving object singleton to store the unlocked IAP
    ArchivingObject *archiver = [ArchivingObject sharedInstance];
    [archiver unlockIAP:productIdentifier];
}

- (IBAction)resetLikedRecipes:(id)sender {
    
    NSArray *allLikedRecipes = [ArchivingObject sharedInstance].favoriteRecipes;
    
    NSLog(@"Delete recipes in array: %@", allLikedRecipes);
    for (NSString *likedRecipe in allLikedRecipes) {
        
        NSLog(@"Recipe: %@", likedRecipe);
        
        [[ArchivingObject sharedInstance] removeRecipeFromFavorites:likedRecipe];
    }
    
}

- (IBAction)changeMeasurement:(id)sender {
    
    UIButton *tempButton = (UIButton*)sender;
    
    if (tempButton.selected) {
        tempButton.selected = NO;
    } else if (!tempButton.selected) {
        tempButton.selected = YES;
    }
    
}

- (IBAction)restorePurchases:(id)sender {
    
    [[SBIAPHelper sharedInstance]restoreCompletedTransactions];
    
    //Register for notifications from the IAPHelper to be able to unlock the recipes after IAP has been purchased
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(purchaseRestored:) name:IAPHelperProductPurchasedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(iapHasBeenLoaded) name:IAPHelperProductTransactionNotification object:nil];
    
    //Start the activity indicator
    loadingIndicator = [[SBActivityIndicatorView alloc]initWithFrame:CGRectMake(0,0, self.view.frame.size.width/5, self.view.frame.size.width/5)];
    [loadingIndicator setCenter:self.view.center];
    [self.view addSubview:loadingIndicator];
    [self.view bringSubviewToFront:loadingIndicator];
    [loadingIndicator startActivityIndicator];
    
}

-(void)iapHasBeenLoaded {
    [loadingIndicator stopAnimating];
    
}

- (IBAction)sendAnalytics:(id)sender {
    
    //This is not used currently as only regular Google Analytics data is sent and not
    //data with ad info
    if ([sender isOn]) {
        //If the switch isn't enabled then enable analytics
        [SBGoogleAnalyticsHelper userEnableAnalytics];
    } else if (![sender isOn]) {
        //If the switch is enabled then it should disable the analytics on touching the switch
        [SBGoogleAnalyticsHelper userDisablesAnalytics];
    }
}

@end
