//
//  SettingsTableViewController.h
//  Smoothie Garden
//
//  Created by Jonas C Björkell on 2015-10-13.
//  Copyright © 2015 Jonas C Björkell. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsTableViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet UIButton *measurementButton;

@property (weak, nonatomic) IBOutlet UISegmentedControl *measurementSegmentControl;

- (IBAction)resetLikedRecipes:(id)sender;
- (IBAction)changeMeasurement:(id)sender;

//Not currently in use
//@property (weak, nonatomic) IBOutlet UIButton *restorePurchasesButton;
//@property (weak, nonatomic) IBOutlet UIButton *resetLikesButton;
//@property (weak, nonatomic) IBOutlet UISwitch *analyticsSwitch;
//- (IBAction)restorePurchases: (id)sender;
//- (IBAction)sendAnalytics:    (id)sender;
//- (IBAction)changeLanguage:(id)sender;




@end
