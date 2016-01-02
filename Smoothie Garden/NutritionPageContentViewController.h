//
//  NutritionPageContentViewController.h
//  
//
//  Created by Jonas C Björkell on 2015-12-27.
//
//

#import <UIKit/UIKit.h>
#import "Recipe.h"

@interface NutritionPageContentViewController : UIViewController <UIScrollViewDelegate>

@property (nonatomic, strong) Recipe *selectedRecipe;

@property (weak, nonatomic) IBOutlet UIView *caloriesView;
@property (weak, nonatomic) IBOutlet UIView *carbsView;
@property (weak, nonatomic) IBOutlet UIView *proteinView;
@property (weak, nonatomic) IBOutlet UIView *fatView;

@end
