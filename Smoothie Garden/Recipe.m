//
//  Recipe.m
//  Smoothie Garden
//
//  Created by Jonas C Björkell on 2015-08-09.
//  Copyright (c) 2015 Jonas C Björkell. All rights reserved.
//


//Define the nutrients
#define NUTRIENT_ENERGY @"Energy"

#define TAB_BAR_ALL 1000
#define TAB_BAR_FAV 1001

#import "Recipe.h"
#import "Ingredient.h"
#import "SBIAPHelper.h"

@implementation Recipe

#pragma mark - Load Recipes
+ (NSArray*) allRecipesFromPlist {

    //The plist with the recipe directory
    NSString *filepathToRecipeMaster = [[NSBundle mainBundle] pathForResource:@"Recipes" ofType:@"plist"];
    NSDictionary *recipeDictionary = [NSDictionary dictionaryWithContentsOfFile:filepathToRecipeMaster];
    
    NSLog(@"Choosing language");
    //The plist with the recipe translation depending on the language of the device
    NSDictionary *localizedRecipeDescriptions = [Recipe localizedRecipeDescriptions];
    
    NSMutableArray *tempRecipes = [[NSMutableArray alloc] init];
    
    for (NSString *name in recipeDictionary) {
        Recipe *newRecipe = [[Recipe alloc]init];
        
        NSDictionary *tempRecipeDictionary = [recipeDictionary objectForKey:name];
        
        //Update the recipe attributes from the global plist
        [newRecipe setRecipeType:[[tempRecipeDictionary objectForKey:@"RecipeType"]intValue]];
        [newRecipe setRecipeCategory:[[tempRecipeDictionary objectForKey:@"RecipeCategory"]intValue]];
        [newRecipe setImageName:[tempRecipeDictionary objectForKey:@"ImageName"]];
        [newRecipe setSorting:[[tempRecipeDictionary objectForKey:@"Sorting"]intValue]];
        
        //Update the recipe attribtues from the localized file
        NSDictionary *localizedDescriptionsForNewRecipe = [localizedRecipeDescriptions objectForKey:name];
        
        [newRecipe setRecipeName:[localizedDescriptionsForNewRecipe objectForKey:@"RecipeName"]];
        [newRecipe setRecipeOverviewDescription:[localizedDescriptionsForNewRecipe objectForKey:@"RecipeOverviewDescription"]];
        [newRecipe setDetailedRecipedescription:[NSArray arrayWithArray:[localizedDescriptionsForNewRecipe objectForKey:@"DetailedRecipeDescription"]]];
        newRecipe.recipeDescription = [NSArray arrayWithArray:[localizedDescriptionsForNewRecipe objectForKey:@"RecipeDescription"]];
        
        //Loop all the ingredient names for the recipe from the plist and add the ingredient to the recipe
        NSMutableArray *tempIngredients = [[NSMutableArray alloc]init];
        for (NSDictionary *dic in [[recipeDictionary objectForKey:name]objectForKey:@"Ingredients"]) {

            BOOL isOptional;
            if ([dic objectForKey:@"Optional"] != nil) {
                isOptional = [[dic objectForKey:@"Optional"]boolValue];
            } else {
                isOptional = NO;
            }
            
            float quantity = [[dic objectForKey:@"Quantity"]floatValue];
            
            Ingredient *newIngredient = [[Ingredient alloc]initWithQuantity:quantity andType:[dic objectForKey:@"Type"] andMeasure:[dic objectForKey:@"Measurement"] andIngredientName:[dic objectForKey:@"Type"] andOptional:isOptional];
            
            [tempIngredients addObject:newIngredient];
            
        }
        
        newRecipe.ingredients = [NSArray arrayWithArray:tempIngredients];
        
        [newRecipe setupAllNutrientInformationForRecipe];
        
        //Flag the recipe as liked or not
        //TODO
        //Change the current handling of likes to something better... have a globally saved recipe list that's loaded into memory on start-up?
        newRecipe.favorite = NO;
        for (NSString *recipeTitle in [Recipe favoriteRecipes]) {
            if ([newRecipe.recipeName isEqualToString:recipeTitle]) {
                newRecipe.favorite = YES;
            }
        }
        
        if (newRecipe) {
            [tempRecipes addObject:newRecipe];
        }
        
    }
    
    return tempRecipes;
    
}

+ (NSDictionary*) localizedRecipeDescriptions{
    
    //Identify the language of the device
    NSString *currentLanguage = [[NSLocale preferredLanguages] objectAtIndex:0];
    
    //Recipe description path depending on localization
    NSString *recipeDescriptionPath;
    
    if ([currentLanguage hasPrefix:@"sv"]) {
        NSLog(@"Swedish");
        recipeDescriptionPath = @"Swedish_recipeTexts";
    } else if ([currentLanguage hasPrefix:@"en"]) {
        NSLog(@"English");
        recipeDescriptionPath = @"English_recipeTexts";
    } else {
        NSLog(@"Language: %@", currentLanguage);
        recipeDescriptionPath = @"English_recipeTexts";
    }
    
    NSLog(@"Text file: %@", recipeDescriptionPath);
    NSString *filepathToRecipeTranslation = [[NSBundle mainBundle] pathForResource:recipeDescriptionPath ofType:@"plist"];
    return [NSDictionary dictionaryWithContentsOfFile:filepathToRecipeTranslation];
    
}

#pragma mark - Favorites

+ (NSArray*) favoriteRecipes {
    
    return [[NSUserDefaults standardUserDefaults]arrayForKey:@"FavoriteRecipes"];
    
}

+ (void) setNewFavoriteRecipes: (NSArray*) newRecipes {
    
    [[NSUserDefaults standardUserDefaults]setObject:newRecipes forKey:@"FavoriteRecipes"];
    
}

+ (void) removeRecipeFromFavoritesUsingRecipeName: (NSString*) recipeName {
    
    NSMutableArray *tempDeleteRecipe = [[NSMutableArray alloc]init];
    
    for (NSString *recipe in [Recipe favoriteRecipes]) {
        if ([recipeName isEqualToString:recipe]) {
            [tempDeleteRecipe addObject:recipe];
        }
    }
    
    NSMutableArray *tempFavoriteRecipes = [NSMutableArray arrayWithArray:[Recipe favoriteRecipes]];
    
    if (tempDeleteRecipe.count>0) {
        [tempFavoriteRecipes removeObjectsInArray:tempDeleteRecipe];
    }
    
    //Set the new favorite recipes
    [Recipe setNewFavoriteRecipes:[NSArray arrayWithArray:tempFavoriteRecipes]];
}

- (void) addRecipeToFavorites {
    
    //Load the favorite recipes array
    NSMutableArray *tempFavoriteRecipes;
    if ([Recipe favoriteRecipes].count>0) {
        tempFavoriteRecipes = [[NSMutableArray alloc]initWithArray:[Recipe favoriteRecipes]];
    } else {
        tempFavoriteRecipes = [[NSMutableArray alloc]init];
    }
    
    //Check if the array already hold this recipe, if not then add it
    if (![tempFavoriteRecipes containsObject:self.recipeName]) {
        [tempFavoriteRecipes addObject:self.recipeName];
    }
    
    NSArray *newFavoriteRecipes = [tempFavoriteRecipes copy];
    
    //Set the new favorite recipes
    [Recipe setNewFavoriteRecipes:newFavoriteRecipes];
    
}

- (BOOL) isRecipeFavorite {
    
    //Iterate all the favorite recipe and match for title
    //All recipes are saved as titles in the favorite array
    for (NSString *recipeTitle in [Recipe favoriteRecipes]) {
        if ([self.recipeName isEqualToString:recipeTitle]) {
            return YES;
        }
    }
    
    //If no recipe title found then it isn't a favorite
    return NO;
}

#pragma mark - In app Purchases

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

#pragma mark - Search

- (NSString*)stringWithIngredients {
    
    //Function will put all the ingredients texts in one long string. To make it easier for the search function.
    
    //Start by adding all ingredients to the same NSString
    NSString *aggregatedIngredients = @"";
    for (Ingredient *ingredient in self.ingredients) {
    
        aggregatedIngredients = [aggregatedIngredients stringByAppendingString:[NSString stringWithFormat:@",%@", ingredient.text]];
        
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
        return @"-";
    }
    
    //Get the total nutrient in the recipe as a float
    NSString *totalVolumeOfNutrientInRecipe = [self volumeForNutrient:nutrient asRoundedValue:NO];
    float totalVolume = [totalVolumeOfNutrientInRecipe floatValue];
    
    //Get the daily intake recommendation
    float dailyRecommendedIntakeForNutrient = [[[self.totalNutrients objectForKey:nutrient]objectForKey:@"DailyRecommendation"]floatValue];
    
    //Return percent of the daily intake. And round it to 0 decimals
    float percentOfDailyIntake = totalVolume / dailyRecommendedIntakeForNutrient;
    int roundedPercentValue = percentOfDailyIntake *100;
    
    //Return with an added %
    return [NSString stringWithFormat:@"%i%%", roundedPercentValue];
    
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
        [newNutrientChildDictionary setObject:unitString forKey:@"Unit"];
        [newNutrientChildDictionary setObject:typeString forKey:@"Type"];
        
        //Add the nutrient fact that's fetched from another plist
        NSString *filepathToDailyRecommendedNIntake = [[NSBundle mainBundle] pathForResource:@"RecommendedDailyIntake" ofType:@"plist"];
        NSDictionary *dailyIntakeDictionaryFromPlist = [NSDictionary dictionaryWithContentsOfFile:filepathToDailyRecommendedNIntake];
        
        if ([[dailyIntakeDictionaryFromPlist objectForKey:dic]objectForKey:@"DailyRecommendation"]) {
            NSString *recommendedDailyIntake = [[dailyIntakeDictionaryFromPlist objectForKey:dic]objectForKey:@"DailyRecommendation"];
            [newNutrientChildDictionary setObject:recommendedDailyIntake forKey:@"DailyRecommendation"];
        }
        
        
        [newNutrientParentDictionary setObject:newNutrientChildDictionary forKey:dic];
        
    }
    
    self.totalNutrients = newNutrientParentDictionary;
    
}

@end
