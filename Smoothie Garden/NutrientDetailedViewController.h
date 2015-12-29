//
//  NutrientDetailedViewController.h
//  Smoothie Box
//
//  Created by Jonas C Björkell on 2015-12-29.
//  Copyright © 2015 Jonas C Björkell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Recipe.h"

@interface NutrientDetailedViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic,strong) Recipe *selectedRecipe;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
