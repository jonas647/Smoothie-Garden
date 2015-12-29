//
//  NutrientTableViewController.m
//  Smoothie Box
//
//  Created by Jonas C Björkell on 2015-12-29.
//  Copyright © 2015 Jonas C Björkell. All rights reserved.
//

#define NUMBER_OF_STATIC_CELLS_AT_TOP 1
#define NUMBER_OF_STATIC_CELLS_AT_BOTTOM 1

#import "NutrientTableViewController.h"

@interface NutrientTableViewController ()

@end

@implementation NutrientTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    NSLog(@"Returning table view length");
    return [self.selectedRecipe numberOfNutrients] + NUMBER_OF_STATIC_CELLS_AT_TOP + NUMBER_OF_STATIC_CELLS_AT_BOTTOM;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionName = @"Nutrition Facts";
    return sectionName;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellIdentifier;
    if (indexPath.row < NUMBER_OF_STATIC_CELLS_AT_TOP) {
        // dequeue and configure my static cell for indexPath.row
        NSLog(@"Returning nutrient header");
        cellIdentifier = @"nutrientHeaderCell";
    } else if (indexPath.row < [self.selectedRecipe numberOfNutrients] + NUMBER_OF_STATIC_CELLS_AT_TOP) {
        // normal dynamic logic here
        NSLog(@"Returning nutrient cell");
        cellIdentifier = @"nutrientCell";
        
    } else {
        NSLog(@"Returning disclaimer cell");
        cellIdentifier = @"DisclaimerCell";
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    if ([cellIdentifier isEqualToString:@"nutrientCell"]) {
        UILabel *nutrientTitle = (UILabel*)[cell viewWithTag:101];
        UILabel *nutrientVolume = (UILabel*)[cell viewWithTag:102];
        UILabel *nutrientDailyIntake = (UILabel*)[cell viewWithTag:103];
        
        nutrientTitle.text = @"Nutrient";
        nutrientVolume.text = @"200mg";
        
        //nutrientTitle.text = [[self.selectedRecipe totalNutrients]objectForKey:@"Fat"];
        //nutrientVolume.text = [self.selectedRecipe volumeStringForNutrient:@"Fat"];
        nutrientDailyIntake.text = @"46%";
    }
    
    return cell;
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
