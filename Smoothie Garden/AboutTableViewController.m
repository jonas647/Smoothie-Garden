//
//  AboutTableViewController.m
//  Smoothie Garden
//
//  Created by Jonas C Björkell on 2015-10-12.
//  Copyright © 2015 Jonas C Björkell. All rights reserved.
//

#import "AboutTableViewController.h"
#import "SWRevealViewController.h"
#import "SBGoogleAnalyticsHelper.h"

@interface AboutTableViewController ()
{
    float fontSize;
}

@end

@implementation AboutTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    if (self.revealViewController != nil) {
        
        [self.view addGestureRecognizer:[self.revealViewController panGestureRecognizer]];
        
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector( revealToggle:)];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
        
    }
    
    //Report to analytics
    [SBGoogleAnalyticsHelper reportScreenToAnalyticsWithName:@"About Screen"];

}

- (void)viewWillAppear:(BOOL)animated {
    //Remove the selection of the previously selected table cell. Make the deselection here to show the user the previously selected cell with a short "blink".
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    //TODO
    //Implement handling of all buttons
    
    if ([indexPath isEqual:[tableView indexPathForCell:self.instagramCell]])
    {
        // Move the user to the instagram page or open safari if instagram not installed
        NSURL *instagramURL = [NSURL URLWithString:@"instagram://user?username=smoothie_box"];
        if ([[UIApplication sharedApplication] canOpenURL:instagramURL]) {
            [[UIApplication sharedApplication] openURL:instagramURL];
        } else {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://instagram.com/smoothie_box/"]];
        }
        
    } else if ([indexPath isEqual:[tableView indexPathForCell:self.facebookPageCell]] ||
               [indexPath isEqual:[tableView indexPathForCell:self.facebookLikeCell]]) {
        
        //Move the user to Facebook page
        NSURL *fbURL = [NSURL URLWithString:@"fb://profile/140319949657893"];
        if ([[UIApplication sharedApplication] canOpenURL:fbURL]){
            [[UIApplication sharedApplication] openURL:fbURL];
        }
        else {
            //Open the url as usual
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.facebook.com/smoothieboxapp/"]];
        }
        
    } else if ([indexPath isEqual:[tableView indexPathForCell:self.emailCell]]) {
        
        //Open email template
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mailto:contact@smoothiebox.eu?subject=Smoothie%20Box%20Feedback"]];
        
    } else if ([indexPath isEqual:[tableView indexPathForCell:self.reviewCell]]) {
        
        //Open AppStore
        NSURL *appStoreUrl = [NSURL URLWithString:@"https://itunes.apple.com/us/app/smoothie-box-recipes-detox/id1057010706?l=sv&ls=1&mt=8"];
        if ([[UIApplication sharedApplication]canOpenURL:appStoreUrl]) {
            [[UIApplication sharedApplication]openURL:appStoreUrl];
        }
        
    }
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

@end
