//
//  SidebarTableViewController.m
//  Smoothie Garden
//
//  Created by Jonas C Björkell on 2015-08-23.
//  Copyright (c) 2015 Jonas C Björkell. All rights reserved.
//

#import "SidebarTableViewController.h"
#import "SmoothieTabBarViewController.h"


#define CELL_HEIGHT 276

@interface SidebarTableViewController ()

@end

@implementation SidebarTableViewController
{
    NSArray *menuItems;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    menuItems = [NSArray arrayWithObjects:@"Add recipes", @"Other apps", @"Settings", @"About", nil];
    
    self.tableView.sectionHeaderHeight = 0.0;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.revealViewController.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section.
    return [menuItems count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Configure the cell...
    static NSString *cellIdentifier = @"mainCell";
    UITableViewCell *newCell =   [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (nil == newCell) {
        newCell    =   [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    newCell.textLabel.text = [NSString stringWithFormat:@"%@", [menuItems objectAtIndex:indexPath.row]];
    newCell.backgroundColor = [UIColor clearColor];
    newCell.textLabel.textColor = [UIColor whiteColor];
    
    return newCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //UIViewController *tempViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"About"];
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if (revealViewController)
    {
        //[self performSegueWithIdentifier:@"AboutSegue" sender:self];
        //[revealViewController.frontViewController addChildViewController:tempViewController];
        //[self presentViewController:tempViewController animated:YES completion:nil];
        SmoothieTabBarViewController *tempcontroller = (SmoothieTabBarViewController*)revealViewController.frontViewController;
        [tempcontroller showPopupViewController:@"About"];
        [revealViewController revealToggleAnimated:YES];
    }
}
#pragma mark - SWRevealViewController Delegate Methods

- (void)revealController:(SWRevealViewController *)revealController willMoveToPosition:(FrontViewPosition)position
{
    NSLog(@"Moving to: %ld", (long)position);
    
    if (position == FrontViewPositionLeftSideMost) {
        /*
        // Menu will get revealed
        self.tapGestureRecognizer.enabled = YES;                 // Enable the tap gesture Recognizer
        self.interactivePopGestureRecognizer.enabled = NO;        // Prevents the iOS7's pan gesture
        self.topViewController.view.userInteractionEnabled = NO;       // Disable the topViewController's interaction
        */
        revealController.frontViewController.view.userInteractionEnabled = NO;
        NSLog(@"Front disabled");
    }
    else if (position == FrontViewPositionLeft){      // Menu will close
        
        /*
        self.tapGestureRecognizer.enabled = NO;
        self.interactivePopGestureRecognizer.enabled = YES;
        self.topViewController.view.userInteractionEnabled = YES;*/
        NSLog(@"Front enabled");
        revealController.frontViewController.view.userInteractionEnabled = YES;
    }
}



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
