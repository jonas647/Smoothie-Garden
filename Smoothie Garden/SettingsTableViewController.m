//
//  SettingsTableViewController.m
//  Smoothie Garden
//
//  Created by Jonas C Björkell on 2015-10-13.
//  Copyright © 2015 Jonas C Björkell. All rights reserved.
//

#define MEASUREMENT_METRIC 1001
#define MEASUREMENT_US_CUSTOMARY_UNITS 1002

#import "SettingsTableViewController.h"
#import "SWRevealViewController.h"
#import "SBIAPHelper.h"
#import "SBActivityIndicatorView.h"
#import "SBGoogleAnalyticsHelper.h"
#import "Ingredient.h"
#import "RecipeManager.h"

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
    
    //Update switch buttons
    
    /*
     //Not currently in use, user can't switch of basic analytics
    if ([SBGoogleAnalyticsHelper isAnalyticsEnabled]) {
        [_analyticsSwitch setOn:YES];
    } else {
        [_analyticsSwitch setOn:NO];
    }
     */
    
    if ([Ingredient usedMeasure] == MEASUREMENT_METRIC) {
        
        self.measurementSegmentControl.selectedSegmentIndex = 0;
        self.measurementButton.selected = NO;
        
    } else if ([Ingredient usedMeasure] == MEASUREMENT_US_CUSTOMARY_UNITS) {
        
        self.measurementSegmentControl.selectedSegmentIndex = 1;
        self.measurementButton.selected = YES;
    }
    
    
    //Report to Analytics
    [SBGoogleAnalyticsHelper reportScreenToAnalyticsWithName:@"Settings Screen"];
}

- (void)viewDidAppear:(BOOL)animated {
    
    //Remove the selection of the previously selected table cell. Make the deselection here to show the user the previously selected cell with a short "blink".
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    
    UITableViewHeaderFooterView *v = (UITableViewHeaderFooterView *)view;
    v.backgroundView.backgroundColor = [UIColor clearColor];
}

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

/*
- (void) purchaseRestored: (NSNotification*) notification {
    //Not used right now since IAP isn't in place
    
    NSString * productIdentifier = notification.object;
    
    //Use the In app helper object singleton to store the unlocked IAP
    [[SBIAPHelper sharedInstance] unlockIAP:productIdentifier];
}
*/
- (IBAction)resetLikedRecipes:(id)sender {
    
    [self showAlertForResetLikes];
    
}

- (IBAction)changeMeasurement:(id)sender {
  
    UISegmentedControl *segmentControl = (UISegmentedControl*)sender;
    
    if (segmentControl.selectedSegmentIndex == 0) {
        [Ingredient useMeasurementMethod:MEASUREMENT_METRIC];
    } else if (segmentControl.selectedSegmentIndex == 1) {
        [Ingredient useMeasurementMethod:MEASUREMENT_US_CUSTOMARY_UNITS];
    }
    
}

/*
- (IBAction)restorePurchases:(id)sender {
    //Not used right now since IAP isn't in place
    
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
 */

-(void)iapHasBeenLoaded {
    [loadingIndicator stopAnimating];
    
}
/*
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
 */

/*
- (IBAction)changeLanguage:(id)sender {
    
    //Not used right now
    UISegmentedControl *segmentControl = (UISegmentedControl*)sender;
    
    NSString *language;
    
    switch (segmentControl.selectedSegmentIndex) {
        case 0:
            language = @"en";
            break;
        case 1:
            language = @"sv";
            break;
        case 2:
            language = nil;
            break;
        default:
            break;
    }
    
    if (language != nil) {
        [[NSUserDefaults standardUserDefaults]setObject:language forKey:@"selectedLanguage"];
    }
    
}
*/
- (void) showAlertForResetLikes {
    //Show an alert to the user asking to review the app
    
    NSString *alertTitle = NSLocalizedString(@"LOCALIZE_Reset likes", @"Do you want to reset all liked recipes?");
    //NSString *alertText; //Add if you want to add a body text to the alert
    NSString *cancelText = NSLocalizedString(@"LOCALIZE_No", nil);
    NSString *acceptText = NSLocalizedString(@"LOCALIZE_Yes", nil);
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:alertTitle message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *acceptAction = [UIAlertAction actionWithTitle:acceptText style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
       
        //Remove all liked recipes
        [[RecipeManager sharedInstance]removeAllFavorites];
    
        //Register with Google Analytics
        [SBGoogleAnalyticsHelper reportEventWithCategory:@"Reset All" andAction:@"Like Recipe" andLabel:@"YES" andValue:nil];
        
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelText style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
        
        //Register with Google Analytics
        [SBGoogleAnalyticsHelper reportEventWithCategory:@"Reset All" andAction:@"Like Recipe" andLabel:@"NO" andValue:nil];
        
    }];
    
    [alert addAction:acceptAction];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

@end
