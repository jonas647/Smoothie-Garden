//
//  NutritionPageContentViewController.m
//  
//
//  Created by Jonas C Björkell on 2015-12-27.
//
//

#define VIEW_TITLELABEL 101
#define VIEW_VOLUMELABEL 102
#define VIEW_PERCENTLABEL 103

#define NUTRITION_CALORIES @"Energy"
#define NUTRITION_FAT @"Protein"
#define NUTRITION_PROTEIN @"Fat"
#define NUTRITION_CARBOHYDRATE @"Carbohydrate"

#import "NutritionPageContentViewController.h"
#import "NutrientTableViewController.h"

@interface NutritionPageContentViewController ()

@end

@implementation NutritionPageContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //Make the calories view a circle
    //Make like view hidden until the recipe is liked
    //_caloriesView.layer.cornerRadius = _caloriesView.bounds.size.width/2;
    //_caloriesView.layer.masksToBounds = YES;
    
    //Make the views like a rectangle
    float borderWidth = 2.0f;
    CGColorRef borderColor = [UIColor whiteColor].CGColor;
    
    _caloriesView.layer.borderWidth = borderWidth;
    _caloriesView.layer.borderColor = borderColor;
    
    _carbsView.layer.borderWidth = borderWidth;
    _carbsView.layer.borderColor = borderColor;
    
    _proteinView.layer.borderWidth = borderWidth;
    _proteinView.layer.borderColor = borderColor;
    
    _fatView.layer.borderWidth = borderWidth;
    _fatView.layer.borderColor = borderColor;
    
    //Get all the labels thru the tags on storyboard
    UILabel *carbsTitle = [_carbsView viewWithTag:VIEW_TITLELABEL];
    UILabel *carbsVolume = [_carbsView viewWithTag:VIEW_VOLUMELABEL];
    UILabel *proteinTitle = [_proteinView viewWithTag:VIEW_TITLELABEL];
    UILabel *proteinVolume = [_proteinView viewWithTag:VIEW_VOLUMELABEL];
    UILabel *fatTitle = [_fatView viewWithTag:VIEW_TITLELABEL];
    UILabel *fatVolume = [_fatView viewWithTag:VIEW_VOLUMELABEL];
    UILabel *caloriesTitle = [_caloriesView viewWithTag:VIEW_TITLELABEL];
    UILabel *caloriesVolume = [_caloriesView viewWithTag:VIEW_VOLUMELABEL];
    
    //The title for the nutrients is obvious
    carbsTitle.text = @"Carbs"; //Carbs is shorter and looks nicer than Carbohydrates
    proteinTitle.text = NUTRITION_PROTEIN;
    fatTitle.text = NUTRITION_FAT;
    caloriesTitle.text = NUTRITION_CALORIES;
    
    //Get the information of nutrients volume from the recipe
    
    carbsVolume.text = [_selectedRecipe volumeStringForNutrient:NUTRITION_CARBOHYDRATE];
    proteinVolume.text = [_selectedRecipe volumeStringForNutrient:NUTRITION_PROTEIN];
    fatVolume.text = [_selectedRecipe volumeStringForNutrient:NUTRITION_FAT];
    caloriesVolume.text = [_selectedRecipe volumeStringForNutrient:NUTRITION_CALORIES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    //Set the recipe to show nutrients for in the nutrition view controller
    NSString * segueName = segue.identifier;
    if ([segueName isEqualToString: @"DetailNutrientsSegue"]) {
        NutrientTableViewController *newVC = (NutrientTableViewController*)[segue destinationViewController];
        newVC.selectedRecipe = self.selectedRecipe;
        
    }
}

@end
