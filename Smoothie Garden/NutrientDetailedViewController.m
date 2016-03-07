//
//  NutrientDetailedViewController.m
//  Smoothie Box
//
//  Created by Jonas C Björkell on 2015-12-29.
//  Copyright © 2015 Jonas C Björkell. All rights reserved.
//

#define NUMBER_OF_STATIC_CELLS_AT_TOP 0
#define NUMBER_OF_STATIC_CELLS_AT_BOTTOM 1

#import "NutrientDetailedViewController.h"
#import "SBGoogleAnalyticsHelper.h"

@interface NutrientDetailedViewController ()

@end

@implementation NutrientDetailedViewController
{
    NSArray *dictionaryKeys;
    NSArray *localizedKeys;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.recipeImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@", self.selectedRecipe.imageName]];
    
    self.caloriesLabel.text = [NSString stringWithFormat:@"%@: %@",NSLocalizedString(@"LOCALIZE_Energy", @"Energy"), [self.selectedRecipe volumeStringForNutrient:@"Energy"]];
    
    //Remove energy as that's shown at the top as "Kcal"
    NSMutableArray *tempKeys = [NSMutableArray arrayWithArray:[self.selectedRecipe allNutrientKeys]];
    [tempKeys removeObject:@"Energy"];
    
    //Handle localization for nutrients if english isn't used on the phone
    if (![[self currentLanguage] isEqualToString: @"en"] ) {
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
        NSMutableArray *tempLocalizedKeys = [[NSMutableArray alloc]init];
        for (NSString *tempNutrientKey in tempKeys) {
            
            NSLog(@"Setting up localized keys");
            //Set an object that's the master key for the localized key
            NSString *localizedKey = [self localizedNameIn:[self currentLanguage] forNutrient:tempNutrientKey];
            if (localizedKey != nil) {
                [dic setObject:tempNutrientKey forKey:localizedKey];
                
            } else {
                NSLog(@"Localized key not available for: %@", tempNutrientKey);
                [dic setObject:tempNutrientKey forKey:tempNutrientKey];
            }
            //Add the localized key
            [tempLocalizedKeys addObject:localizedKey];
            
        }
        
        //Create the localized sorted array
        localizedKeys = [tempLocalizedKeys sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
        
        //Sort the master key in the same order as localized key
        NSMutableArray *tempMasterKeys = [[NSMutableArray alloc]init];
        for (NSString *localizedKey in localizedKeys) {
            
            NSString *masterKey = [dic objectForKey:localizedKey];
            [tempMasterKeys addObject:masterKey];
        }
        
        dictionaryKeys = [NSArray arrayWithArray:tempMasterKeys];
    } else {
     
        //Sort the array of keys alphabetically
        dictionaryKeys = [tempKeys sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    }
    
    //Report to analytics
    [SBGoogleAnalyticsHelper reportScreenToAnalyticsWithName:[NSString stringWithFormat:@"Nutrient Facts"]];
    [SBGoogleAnalyticsHelper reportEventWithCategory:@"Nutrient Fact" andAction:@"Watching" andLabel:[NSString stringWithFormat:@"%@", self.selectedRecipe.recipeName] andValue:nil];
    
}

- (NSString*) localizedNameIn: (NSString*) language forNutrient: (NSString*) nutrientName {
    
    //Get the plist that has all the nutrient names
    NSString *filepathToNutrients = [[NSBundle mainBundle] pathForResource:@"NutritionTranslation" ofType:@"plist"];
    NSDictionary *nutrientTextDictionary = [NSDictionary dictionaryWithContentsOfFile:filepathToNutrients];
    
    //Dictionary of the specific nutrient
    NSDictionary *thisNutrient = [nutrientTextDictionary objectForKey:nutrientName];
    
    if ([thisNutrient objectForKey:language]) {
        return [thisNutrient objectForKey:language];
    } else {
        NSLog(@"No translation for %@", nutrientName);
        return nutrientName;
    }
}

- (NSString*) currentLanguage {
    
    //Identify the language of the device
    NSString *currentLanguage = [[NSLocale preferredLanguages] objectAtIndex:0];
    
    //Return the two first characters, ie. "en"
    return [currentLanguage substringToIndex:2];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return dictionaryKeys.count + NUMBER_OF_STATIC_CELLS_AT_TOP + NUMBER_OF_STATIC_CELLS_AT_BOTTOM;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellIdentifier;
    if (indexPath.row < NUMBER_OF_STATIC_CELLS_AT_TOP) {
        cellIdentifier = @"nutrientHeaderCell";
    } else if (indexPath.row < dictionaryKeys.count + NUMBER_OF_STATIC_CELLS_AT_TOP) {
        cellIdentifier = @"nutrientCell";
        
    } else {
        cellIdentifier = @"DisclaimerCell";
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    if ([cellIdentifier isEqualToString:@"nutrientCell"]) {
        UILabel *nutrientTitle = (UILabel*)[cell viewWithTag:101];
        UILabel *nutrientVolume = (UILabel*)[cell viewWithTag:102];
        UILabel *nutrientDailyIntake = (UILabel*)[cell viewWithTag:103];
        
        NSString *nutrient = [dictionaryKeys objectAtIndex:indexPath.row];
        
        //If there's a localized key then show that, otherwise go for the english
        if ([localizedKeys objectAtIndex:indexPath.row]) {
            nutrientTitle.text = [localizedKeys objectAtIndex:indexPath.row];
        } else {
            nutrientTitle.text = [dictionaryKeys objectAtIndex:indexPath.row];
        }
        
        
        nutrientVolume.text = [self.selectedRecipe volumeStringForNutrient:nutrient];
        nutrientDailyIntake.text = [self.selectedRecipe percentOfDailyIntakeFor:nutrient];
    }
    
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
