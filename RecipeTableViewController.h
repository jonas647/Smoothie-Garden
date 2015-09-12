//
//  RecipeTableViewController.h
//  Smoothie Garden
//
//  Created by Jonas C Björkell on 2015-08-06.
//  Copyright (c) 2015 Jonas C Björkell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecipeTableViewCell.h"

@interface RecipeTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sideBarButton;

@end
