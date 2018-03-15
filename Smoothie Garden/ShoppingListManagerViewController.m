//
//  ShoppingListManagerViewController.m
//  Smoothie Box
//
//  Created by Jonas C Björkell on 2016-07-23.
//  Copyright © 2016 Jonas C Björkell. All rights reserved.
//

#import "ShoppingListManagerViewController.h"
#import "ShoppingList.h"
#import "ShoppingListItem.h"
#import "SWRevealViewController.h"

@interface ShoppingListManagerViewController ()

@end

@implementation ShoppingListManagerViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.revealViewController != nil) {
        
        [self.view addGestureRecognizer:[self.revealViewController panGestureRecognizer]];
        
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector( revealToggle:)];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[ShoppingList sharedInstance]currentShoppingList].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellIdentifier = @"ingredientCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    if ([cellIdentifier isEqualToString:@"ingredientCell"]) {
        UILabel *ingredientTitle = (UILabel*)[cell viewWithTag:101];
        UILabel *ingredientVolume = (UILabel*)[cell viewWithTag:102];
        
        UIButton *removeIngredientButton = (UIButton*)[cell viewWithTag:103];
        removeIngredientButton.tag=indexPath.row;
        [removeIngredientButton addTarget:self
                                   action:@selector(removeIngredientFromShoppingList:) forControlEvents:UIControlEventTouchUpInside];

        
        ShoppingListItem *item = [[[ShoppingList sharedInstance]currentShoppingList] objectAtIndex:indexPath.row];
        
        ingredientTitle.text = [[item ingredientForItem] stringWithIngredientText];
        ingredientVolume.text = [[item ingredientForItem] stringWithQuantityAndMeasure];
        
        UIView *buttonView = [cell viewWithTag:104];
        UIView *circleView = [buttonView viewWithTag:1001];
        
        //Set the attributes for the remove button
        circleView.layer.cornerRadius = circleView.bounds.size.width/2;//Make like view a circle
        circleView.layer.masksToBounds = YES;
        
    }
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code here for when you hit delete
        [[ShoppingList sharedInstance] removeShoppingListItemAtIndex:indexPath.row];
        [_shoppingListTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
    }
}

- (IBAction)clearShoppingList:(id)sender {
    
    //Present alert for the user if he/she really wants to reset the shopping list
    NSString *alertTitle = NSLocalizedString(@"LOCALIZE_Clean Shopping List - title", nil);
    NSString *alertText = NSLocalizedString(@"LOCALIZE_Clean Shopping List - text", nil);
    NSString *cancelText = NSLocalizedString(@"LOCALIZE_No", nil);
    NSString *acceptText = NSLocalizedString(@"LOCALIZE_Yes", nil);
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:alertTitle message:alertText preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *acceptAction = [UIAlertAction actionWithTitle:acceptText style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        
        [self clearShoppingList];
        
        
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelText style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
        
        
    }];
    
    [alert addAction:acceptAction];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
    
    
    
}

- (void) clearShoppingList {
    [[ShoppingList sharedInstance] clearShoppingList];
    
    [_shoppingListTableView reloadData];
}

- (void) removeIngredientFromShoppingList:(id)sender {
    
    CGPoint hitPoint = [sender convertPoint:CGPointZero toView:_shoppingListTableView];
    NSIndexPath *hitIndex = [_shoppingListTableView indexPathForRowAtPoint:hitPoint];
    
    //Update table
    
    [[ShoppingList sharedInstance]removeShoppingListItemAtIndex:hitIndex.row];
    [_shoppingListTableView reloadData];
}
@end
