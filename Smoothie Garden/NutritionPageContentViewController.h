//
//  NutritionPageContentViewController.h
//  
//
//  Created by Jonas C Björkell on 2015-12-27.
//
//

#import <UIKit/UIKit.h>
#import "NutritionDetailView.h"
#import "Recipe.h"

@interface NutritionPageContentViewController : UIViewController <UIScrollViewDelegate>

@property (nonatomic, strong) Recipe *selectedRecipe;

@property (weak, nonatomic) IBOutlet UILabel *caloriesLabel;

@property (weak, nonatomic) IBOutlet UIView *caloriesView;
@property (weak, nonatomic) IBOutlet NutritionDetailView *carbsView;
@property (weak, nonatomic) IBOutlet NutritionDetailView *proteinView;
@property (weak, nonatomic) IBOutlet NutritionDetailView *fatView;

@end
