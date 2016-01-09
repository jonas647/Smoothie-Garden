//
//  NutrientDetailedViewController.m
//  Smoothie Box
//
//  Created by Jonas C Björkell on 2015-12-29.
//  Copyright © 2015 Jonas C Björkell. All rights reserved.
//

#define NUMBER_OF_STATIC_CELLS_AT_TOP 0
#define NUMBER_OF_STATIC_CELLS_AT_BOTTOM 1

#import "NutrientDetailedViewController.h"

@interface NutrientDetailedViewController ()

@end

@implementation NutrientDetailedViewController
{
    NSArray *dictionaryKeys;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.titleLabel.text = [NSString stringWithFormat:@"Nutrient fact sheet for %@", self.selectedRecipe.recipeName];
    
    self.caloriesLabel.text = [NSString stringWithFormat:@"Energy: %@", [self.selectedRecipe volumeStringForNutrient:@"Energy"]];
    
    //Remove energy as that's shown at the top as "Kcal"
    NSMutableArray *tempKeys = [NSMutableArray arrayWithArray:[self.selectedRecipe allNutrientKeys]];
    [tempKeys removeObject:@"Energy"];
    
    //Sort array in alphabetical order and set that as the dictionary keys
    dictionaryKeys = [tempKeys sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
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
    return dictionaryKeys.count + NUMBER_OF_STATIC_CELLS_AT_TOP + NUMBER_OF_STATIC_CELLS_AT_BOTTOM;
}

/*
 
 //No title since we're using a view to present the column data
 
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionName = @"Nutrition Facts";
    return sectionName;
}
*/

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellIdentifier;
    if (indexPath.row < NUMBER_OF_STATIC_CELLS_AT_TOP) {
        cellIdentifier = @"nutrientHeaderCell";
    } else if (indexPath.row < dictionaryKeys.count + NUMBER_OF_STATIC_CELLS_AT_TOP) {
        cellIdentifier = @"nutrientCell";
        
    } else {
        cellIdentifier = @"DisclaimerCell";
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    if ([cellIdentifier isEqualToString:@"nutrientCell"]) {
        UILabel *nutrientTitle = (UILabel*)[cell viewWithTag:101];
        UILabel *nutrientVolume = (UILabel*)[cell viewWithTag:102];
        UILabel *nutrientDailyIntake = (UILabel*)[cell viewWithTag:103];
        
        NSString *nutrient = [dictionaryKeys objectAtIndex:indexPath.row];
        
        nutrientTitle.text = nutrient;
        nutrientVolume.text = [self.selectedRecipe volumeStringForNutrient:nutrient];
        nutrientDailyIntake.text = [self.selectedRecipe percentOfDailyIntakeFor:nutrient];
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
