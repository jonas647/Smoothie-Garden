//
//  NutrientTableViewController.h
//  Smoothie Box
//
//  Created by Jonas C Björkell on 2015-12-29.
//  Copyright © 2015 Jonas C Björkell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Recipe.h"

@interface NutrientTableViewController : UITableViewController

@property (nonatomic,strong) Recipe *selectedRecipe;

@end
