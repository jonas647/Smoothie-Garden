//
//  SidebarDetailedTableViewController.h
//  Smoothie Garden
//
//  Created by Jonas C Björkell on 2015-10-12.
//  Copyright © 2015 Jonas C Björkell. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SidebarDetailedTableViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet UIButton *measurementButton;
@property (weak, nonatomic) IBOutlet UIButton *changeMeasurement;
@property (weak, nonatomic) IBOutlet UIButton *restorePurchases;
@property (weak, nonatomic) IBOutlet UIButton *resetLikedRecipes;

@end
