//
//  DetoxViewController.h
//  Smoothie Box
//
//  Created by Jonas C Björkell on 2016-01-14.
//  Copyright © 2016 Jonas C Björkell. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetoxViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>


@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *introductionText;

@property (weak, nonatomic) IBOutlet UIView *day1View;
@property (weak, nonatomic) IBOutlet UIView *day2View;
@property (weak, nonatomic) IBOutlet UIView *day3View;


- (IBAction)changeDay:(id)sender;

@end
