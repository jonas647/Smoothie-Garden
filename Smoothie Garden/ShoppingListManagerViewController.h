//
//  ShoppingListManagerViewController.h
//  Smoothie Box
//
//  Created by Jonas C Björkell on 2016-07-23.
//  Copyright © 2016 Jonas C Björkell. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShoppingListManagerViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet UITableView *shoppingListTableView;
- (IBAction)clearShoppingList:(id)sender;

@end
