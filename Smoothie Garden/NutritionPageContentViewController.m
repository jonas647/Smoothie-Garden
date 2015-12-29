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
#import "NutrientTableViewController.h"

@interface NutritionPageContentViewController ()

@end

@implementation NutritionPageContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //Make the calories view a circle
    //Make like view hidden until the recipe is liked
    _caloriesView.layer.cornerRadius = _caloriesView.bounds.size.width/2;
    _caloriesView.layer.masksToBounds = YES;
    
    //Get all the labels thru the tags on storyboard
    UILabel *carbsTitle = [_carbsView.nutritionTitle viewWithTag:VIEW_TITLELABEL];
    UILabel *carbsVolume = [_carbsView.nutritionVolume viewWithTag:VIEW_VOLUMELABEL];
    UILabel *proteinTitle = [_proteinView.nutritionTitle viewWithTag:VIEW_TITLELABEL];
    UILabel *proteinVolume = [_proteinView.nutritionVolume viewWithTag:VIEW_VOLUMELABEL];
    UILabel *fatTitle = [_fatView.nutritionTitle viewWithTag:VIEW_TITLELABEL];
    UILabel *fatVolume = [_fatView.nutritionVolume viewWithTag:VIEW_VOLUMELABEL];
    
    //The title for the nutrients is obvious
    carbsTitle.text = NUTRITION_CARBOHYDRATE;
    proteinTitle.text = NUTRITION_PROTEIN;
    fatTitle.text = NUTRITION_FAT;
    
    //Get the information of nutrients volume from the recipe
    
     carbsVolume.text = [_selectedRecipe volumeStringForNutrient:NUTRITION_CARBOHYDRATE];
    proteinVolume.text = [_selectedRecipe volumeStringForNutrient:NUTRITION_PROTEIN];
    fatVolume.text = [_selectedRecipe volumeStringForNutrient:NUTRITION_FAT];
    _caloriesLabel.text = [_selectedRecipe volumeStringForNutrient:NUTRITION_CALORIES];
    
    
    //TODO
    //Loop all nutritions to find the ones with the highest values for daily intakes
    
    //Loop all children in the nutrient grid to populate with the nutrients
    
    
    //For now, just populate with  a few too see that it works
    
    /*
    UILabel *titleLabelA = [self.nutritionFactA viewWithTag:VIEW_TITLELABEL];
    //UILabel *percentLabel = [self.nutritionFactA viewWithTag:VIEW_PERCENTLABEL];
    UILabel *volumeLabelA = [self.nutritionFactA viewWithTag:VIEW_VOLUMELABEL];
    
    titleLabelA.text = NUTRITION_PROTEIN;
    volumeLabelA.text = [self.selectedRecipe volumeStringForNutrient:NUTRITION_PROTEIN];
    
    UILabel *titleLabelB = [self.nutritionFactB viewWithTag:VIEW_TITLELABEL];
    //UILabel *percentLabel = [self.nutritionFactB viewWithTag:VIEW_PERCENTLABEL];
    UILabel *volumeLabelB = [self.nutritionFactB viewWithTag:VIEW_VOLUMELABEL];
    
    titleLabelB.text = NUTRITION_FAT;
    volumeLabelB.text = [self.selectedRecipe volumeStringForNutrient:NUTRITION_FAT];
    
    if (!UIAccessibilityIsReduceTransparencyEnabled()) {
        self.nutritionGrid.backgroundColor = [UIColor clearColor];
        
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
        UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        blurEffectView.frame = self.view.bounds;
        blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        [self.nutritionGrid addSubview:blurEffectView];
    }
    else {
        self.nutritionGrid.backgroundColor = [UIColor whiteColor];
        self.nutritionGrid.alpha = 0.75;
    }
 */   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Scrollview Delegates
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
 
    NSLog(@"scrolling");
    
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
