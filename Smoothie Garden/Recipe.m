//
//  Recipe.m
//  Smoothie Garden
//
//  Created by Jonas C Björkell on 2015-08-09.
//  Copyright (c) 2015 Jonas C Björkell. All rights reserved.
//


//Define the nutrients
#define NUTRIENT_ENERGY @"Energy"

//NSCoding macros
#define NSCoding_RecipeType @"rType"
#define NSCoding_RecipeCategory @"rCategory"
#define NSCoding_Favorite @"rFavorite"
#define NSCoding_Sorting @"rSorting"
#define NSCoding_RecipeName @"rName"
#define NSCoding_ShortDescription @"rShortDescription"
#define NSCoding_LongDescription @"rLongDescription"
#define NSCoding_Instructions @"rInstructions"
#define NSCoding_Ingredients @"rIngredients"
#define NSCoding_ImageName @"rImageName"
#define NSCoding_TotalNutrients @"rTotalNutrients"

#import "Recipe.h"
#import "Ingredient.h"

@implementation Recipe

#pragma mark - Load Recipes

#pragma mark - In app Purchases


//Not currently in use
/*
- (BOOL) isRecipeUnlocked {
    
    //If the recipe category is 0 then it's free from start in the app. No need for IAP check
    //IAP "basicRecipes_01 unlocks the recipes with category 1. It's the only IAP available right now
    if (self.recipeCategory == 0) {
        return YES;
    } else if (self.recipeCategory == 1) {
        return [[SBIAPHelper sharedInstance]isIAPUnlocked:@"basicRecipes_01"];
    } else {
        NSLog(@"No IAP for recipe category: %i", (int)self.recipeCategory);
        return NO;
    }
}
*/
#pragma mark - Search

- (NSString*)stringWithIngredients {
    
    //Function will put all the ingredients texts in one long string. To make it easier for the search function.
    
    //Start by adding all ingredients to the same NSString
    NSString *aggregatedIngredients = @"";
    for (Ingredient *ingredient in self.ingredients) {
    
        aggregatedIngredients = [aggregatedIngredients stringByAppendingString:[NSString stringWithFormat:@",%@", ingredient.searchString]];
       
    }

    return aggregatedIngredients;
    
}

#pragma mark - Nutrient Information

- (NSArray*) allNutrientKeys {
    
    return [NSArray arrayWithArray:[self.totalNutrients allKeys]];
}

- (int) numberOfNutrients {
    
    if (self.totalNutrients) {
        return (int)[self.totalNutrients count];
    } else
        return 0;
    
}

- (NSString*) volumeStringForNutrient: (NSString*) nutrient {
    //Returns the volume with unit
    float qty = [[self volumeForNutrient:nutrient asRoundedValue:YES]floatValue];
    
    return [NSString stringWithFormat:@"%@%@", [self roundedValueFrom:qty], [self unitForNutrient:nutrient]];
}

- (NSString*) volumeForNutrient: (NSString*) nutrient asRoundedValue: (BOOL) rounded {
    
    if ([[self.totalNutrients objectForKey:nutrient]objectForKey:@"Measure"]) {
        
        float floatValueForVolume = [[[self.totalNutrients objectForKey:nutrient]objectForKey:@"Measure"]floatValue];
        
        if (rounded == YES) {
            NSString *roundedValue = [self roundedValueFrom:floatValueForVolume];
            
            return roundedValue;
        } else {
            return [[self.totalNutrients objectForKey:nutrient]objectForKey:@"Measure"];
        }
        
    } else
        return [NSString stringWithFormat:@"No object %@", nutrient];
    
    
}

- (NSString*) roundedValueFrom: (float) value {

    NSString *quantityOneDecimal;
    if (value == (int)value) {
        //Qty has integer value without decimals
        quantityOneDecimal  = [NSString stringWithFormat:@"%.f", value];
    } else {
        quantityOneDecimal = [NSString stringWithFormat:@"%.01f", value];
    }
    
    return quantityOneDecimal;
    
}

- (NSString*) unitForNutrient: (NSString*) nutrient {
    
    if ([[self.totalNutrients objectForKey:nutrient]objectForKey:@"Unit"]) {
        return [[self.totalNutrients objectForKey:nutrient]objectForKey:@"Unit"];
    } else
        return [NSString stringWithFormat:@"No 'Unit' for %@", nutrient];
    
    
}

- (NSString*) typeForNutrient: (NSString*) nutrient {
    
    if ([[self.totalNutrients objectForKey:nutrient]objectForKey:@"Type"]) {
        return [[self.totalNutrients objectForKey:nutrient]objectForKey:@"Type"];
    } else
        return [NSString stringWithFormat:@"No 'Type' for %@", nutrient];
    
}

- (NSString*) percentOfDailyIntakeFor:(NSString *)nutrient {
    
    //If the daily recommendation doesn't exist, then just put a "-"
    if (![[self.totalNutrients objectForKey:nutrient]objectForKey:@"DailyRecommendation"]) {
        return @"n/a";
    }
    
    //Get the total nutrient in the recipe as a float
    NSString *totalVolumeOfNutrientInRecipe = [self volumeForNutrient:nutrient asRoundedValue:NO];
    float totalVolume = [totalVolumeOfNutrientInRecipe floatValue];
    
    //Get the daily intake recommendation
    float dailyRecommendedIntakeForNutrient = [[[self.totalNutrients objectForKey:nutrient]objectForKey:@"DailyRecommendation"]floatValue];
    
    //Return percent of the daily intake. And round it to 0 decimals
    float percentOfDailyIntake = totalVolume / dailyRecommendedIntakeForNutrient;
    int roundedPercentValue = percentOfDailyIntake *100;
    
    //If the Daily intake is smaller than 1% and the total volume is bigger than 0 show that a value exist for the user
    if (roundedPercentValue<1 && totalVolume>0) {
        return @"<1%";
    } else {
        //Return with an added %
        return [NSString stringWithFormat:@"%i%%", roundedPercentValue];
    }
    
}

- (void) setupAllNutrientInformationForRecipe {
    
    //Get the nutrient dictionary from the first ingredient. Just to get all the different types.
    //IMPORTANT that the first ingredient exist in the nutrient dictionary. So need to add all the ingredients there even if it's 0 on everything (water, ice)
    Ingredient *tempIngredient = (Ingredient*) [self.ingredients objectAtIndex:0];
    NSDictionary *tempNutrientDictionary = [tempIngredient nutrientCatalogWithNoValueForMeasure];
    
    NSMutableDictionary *newNutrientParentDictionary = [[NSMutableDictionary alloc]initWithCapacity:tempNutrientDictionary.count];
   
    //Loop the dictionary loaded from plist. To update the total volume
    for (NSMutableDictionary *dic in tempNutrientDictionary) {
        //Dictionary to hold the unit, type, measure and recommended daily intake
        NSMutableDictionary *newNutrientChildDictionary = [[NSMutableDictionary alloc]initWithCapacity:4];
        
        //For each nutrient. Get the nutrient value from the ingredient
        float volumeForNutrient = 0;
        for (Ingredient *i in self.ingredients) {
            volumeForNutrient += [[i totalVolumeForNutrient:[NSString stringWithFormat:@"%@", dic]] floatValue];
        }
        
        //For every nutrient add the volume/measure to the recipe nutrient dictionary
        [newNutrientChildDictionary setObject:[NSString stringWithFormat:@"%f", volumeForNutrient] forKey:@"Measure"];
        
        //Also add the unit and type objects
        NSString *unitString = [[tempNutrientDictionary objectForKey:dic]objectForKey:@"Unit"];
        NSString *typeString = [[tempNutrientDictionary objectForKey:dic]objectForKey:@"Type"];
        if (unitString) {
            [newNutrientChildDictionary setObject:unitString forKey:@"Unit"];
        } else {
            NSLog(@"Unit string for %@ doesn't exist", dic);
        }
        if (typeString) {
            [newNutrientChildDictionary setObject:typeString forKey:@"Type"];
        } else {
            NSLog(@"Type string for %@ doesn't exist", dic);
        }
        
        //Add the nutrient fact that's fetched from another plist
        NSString *filepathToDailyRecommendedIntake = [[NSBundle mainBundle] pathForResource:@"RecommendedDailyIntake" ofType:@"plist"];
        NSDictionary *dailyIntakeDictionaryFromPlist = [NSDictionary dictionaryWithContentsOfFile:filepathToDailyRecommendedIntake];
        
        if ([[dailyIntakeDictionaryFromPlist objectForKey:dic]objectForKey:@"DailyRecommendation"]) {
            NSString *recommendedDailyIntake = [[dailyIntakeDictionaryFromPlist objectForKey:dic]objectForKey:@"DailyRecommendation"];
            [newNutrientChildDictionary setObject:recommendedDailyIntake forKey:@"DailyRecommendation"];
        }
        
        if (newNutrientChildDictionary) {
            [newNutrientParentDictionary setObject:newNutrientChildDictionary forKey:dic];
        } else {
            NSLog(@"No nutrient child dictionary could be setup for: %@", dic);
        }
        
        
    }
    
    self.totalNutrients = newNutrientParentDictionary;
    
}

- (id) initWithCoder:(NSCoder *)aDecoder {
    
    if(self = [super init]) {
        
        [self setRecipeType:[aDecoder decodeIntForKey:NSCoding_RecipeType]];
        [self setRecipeCategory:[aDecoder decodeIntForKey:NSCoding_RecipeCategory]];
        [self setFavorite:[aDecoder decodeBoolForKey:NSCoding_Favorite]];
        [self setSorting:[aDecoder decodeIntForKey:NSCoding_Sorting]];
        [self setRecipeName:[aDecoder decodeObjectForKey:NSCoding_RecipeName]];
        [self setShortDescription:[aDecoder decodeObjectForKey:NSCoding_ShortDescription]];
        [self setLongDescription:[aDecoder decodeObjectForKey:NSCoding_LongDescription]];
        [self setInstructions:[aDecoder decodeObjectForKey:NSCoding_Instructions]];
        [self setIngredients:[aDecoder decodeObjectForKey:NSCoding_Ingredients]];
        [self setImageName:[aDecoder decodeObjectForKey:NSCoding_ImageName]];
        [self setTotalNutrients:[aDecoder decodeObjectForKey:NSCoding_TotalNutrients]];
        
    }
    
    return self;
    
}
- (void) encodeWithCoder:(NSCoder *)aCoder {

    [aCoder encodeInt:self.recipeType forKey:NSCoding_RecipeType];
    [aCoder encodeInt:self.recipeCategory forKey:NSCoding_RecipeCategory];
    [aCoder encodeBool:self.favorite forKey:NSCoding_Favorite];
    [aCoder encodeInt:self.sorting forKey:NSCoding_Sorting];
    [aCoder encodeObject:self.recipeName forKey:NSCoding_RecipeName];
    [aCoder encodeObject:self.shortDescription forKey:NSCoding_ShortDescription];
    [aCoder encodeObject:self.longDescription forKey:NSCoding_LongDescription];
    [aCoder encodeObject:self.instructions forKey:NSCoding_Instructions];
    [aCoder encodeObject:self.ingredients forKey:NSCoding_Ingredients];
    [aCoder encodeObject:self.imageName forKey:NSCoding_ImageName];
    [aCoder encodeObject:self.totalNutrients forKey:NSCoding_TotalNutrients];

}

@end
