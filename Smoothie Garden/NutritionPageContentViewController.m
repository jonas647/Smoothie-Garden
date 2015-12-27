//
//  NutritionPageContentViewController.m
//  
//
//  Created by Jonas C Björkell on 2015-12-27.
//
//

#define VIEW_TITLELABEL 101
#define VIEW_PERCENTLABEL 102
#define VIEW_VOLUMELABEL 103

#define NUTRITION_CALORIES @"Energy"
#define NUTRITION_FAT @"Protein"
#define NUTRITION_PROTEIN @"Fat"
#define NUTRITION_CARBOHYDRATE @"Carbohydrate"

#import "NutritionPageContentViewController.h"

@interface NutritionPageContentViewController ()

@end

@implementation NutritionPageContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //TODO
    //Loop all nutritions to find the ones with the highest values for daily intakes
    
    //Loop all children in the nutrient grid to populate with the nutrients
    
    
    //For now, just populate with  a few too see that it works
    
    UILabel *titleLabelA = [self.nutritionFactA viewWithTag:VIEW_TITLELABEL];
    //UILabel *percentLabel = [self.nutritionFactA viewWithTag:VIEW_PERCENTLABEL];
    UILabel *volumeLabelA = [self.nutritionFactA viewWithTag:VIEW_VOLUMELABEL];
    
    titleLabelA.text = NUTRITION_PROTEIN;
    volumeLabelA.text = [self.selectedRecipe volumeForNutrient:NUTRITION_PROTEIN];
    
    UILabel *titleLabelB = [self.nutritionFactB viewWithTag:VIEW_TITLELABEL];
    //UILabel *percentLabel = [self.nutritionFactB viewWithTag:VIEW_PERCENTLABEL];
    UILabel *volumeLabelB = [self.nutritionFactB viewWithTag:VIEW_VOLUMELABEL];
    
    titleLabelB.text = NUTRITION_FAT;
    volumeLabelB.text = [self.selectedRecipe volumeForNutrient:NUTRITION_FAT];
    
    NSLog(@"Page content init with recipe: %@", _selectedRecipe);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)moreNutritionFacts:(id)sender {
}
@end
