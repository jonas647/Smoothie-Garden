//
//  NutrientFactPageViewRootViewController.h
//  Smoothie Box
//
//  Created by Jonas C Björkell on 2015-12-19.
//  Copyright © 2015 Jonas C Björkell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NutritionCollectionViewController.h"

@interface NutrientFactPageViewRootViewController : UIViewController <UIPageViewControllerDataSource>

@property (nonatomic,strong) UIPageViewController *pageViewController;
@property (nonatomic,strong) Recipe *selectedRecipe;

@property (weak, nonatomic) IBOutlet UIImageView *recipeImage;

- (UIViewController *)viewControllerAtIndex:(NSUInteger)index;

@end
