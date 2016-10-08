//
//  NutrientFactPageViewRootViewController.h
//  Smoothie Box
//
//  Created by Jonas C Björkell on 2015-12-19.
//  Copyright © 2015 Jonas C Björkell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBPageViewRootViewController.h"
#import "Recipe.h"

@interface NutrientFactPageViewRootViewController : SBPageViewRootViewController <UIPageViewControllerDataSource>

//@property (nonatomic,strong) UIPageViewController *pageViewController;
@property (nonatomic,strong) Recipe *selectedRecipe;
@property (weak, nonatomic) IBOutlet UIImageView *recipeImage;

- (void) refreshUI;

@end
