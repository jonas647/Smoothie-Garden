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

@interface NutritionPageContentViewController : UIViewController

@property (nonatomic, strong) Recipe *selectedRecipe;

@property (weak, nonatomic) IBOutlet UILabel *caloriesLabel;
@property (weak, nonatomic) IBOutlet NutritionDetailView *nutritionFactA;
@property (weak, nonatomic) IBOutlet NutritionDetailView *nutritionFactB;
@property (weak, nonatomic) IBOutlet NutritionDetailView *nutritionFactC;
@property (weak, nonatomic) IBOutlet NutritionDetailView *nutritionFactD;
@property (weak, nonatomic) IBOutlet NutritionDetailView *nutritionFactE;
@property (weak, nonatomic) IBOutlet NutritionDetailView *nutritionFactF;
@property (weak, nonatomic) IBOutlet NutritionDetailView *nutritionFactG;
@property (weak, nonatomic) IBOutlet NutritionDetailView *nutritionFactH;
@property (weak, nonatomic) IBOutlet NutritionDetailView *nutritionFactI;


- (IBAction)moreNutritionFacts:(id)sender;

@end
