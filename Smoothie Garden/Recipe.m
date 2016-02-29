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
#import "SBIAPHelper.h"

@implementation Recipe

#pragma mark - Load Recipes
/*
+ (NSArray*) recipeMaster {
    
    if ([self shouldUpdateRecipePersistentStore]) {
        
        [self saveRecipesToPersistentStore];
    }
    
    return [self allRecipesFromPersistentStore];
}

+ (BOOL) shouldUpdateRecipePersistentStore {
    
    //If the version has never been saved then load recipes
    if(![[[[NSUserDefaults standardUserDefaults] dictionaryRepresentation] allKeys] containsObject:@"RecipeVersion"]){
        return YES;
    } else {
        //Check what version of the recipes that are saved
        
        NSString *filepathToRecipeMaster = [[NSBundle mainBundle] pathForResource:@"Recipes" ofType:@"plist"];
        NSDictionary *recipeDictionary = [NSDictionary dictionaryWithContentsOfFile:filepathToRecipeMaster];
        
        int versionOfRecipeList = [[recipeDictionary objectForKey:@"Version"]intValue];
        int currentVersion = (int)[[NSUserDefaults standardUserDefaults]integerForKey:@"RecipeVersion"];
        
        //Get the language of the recipes and verify vs language on the phone
        NSString *recipeLanguage = [recipeDictionary objectForKey:@"Language"];
        NSString *userLanguage = [self currentLanguage];
        
        //If the version is lower than the last updated plist then load the recipes
        //If the user language is another than the recipe language. Then load the recipes
        if (currentVersion < versionOfRecipeList) {
            
            return YES;
        } else if (![userLanguage isEqualToString:recipeLanguage]) {
            return YES;
        } else {
            return NO;
        }
    }
}

+ (void) saveRecipesToPersistentStore {
    
    //The plist with the recipe directory
    NSString *filepathToRecipeMaster = [[NSBundle mainBundle] pathForResource:@"Recipes" ofType:@"plist"];
    NSDictionary *recipeDictionary = [NSDictionary dictionaryWithContentsOfFile:filepathToRecipeMaster];
    
    //Load all the recipes into array
    NSArray *recipes = [self allRecipesFromDictionary:recipeDictionary];
    
    //Load the version number
    int version;
    if ([recipeDictionary objectForKey:@"Version"]) {
        version = [[recipeDictionary objectForKey:@"Version"]intValue];
    } else {
        NSLog(@"No version information in plist");
    }
    
    //Save to NSUserDefault
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:recipes];
    [defaults setObject:data forKey:@"SavedRecipes"];
    [defaults setObject:[NSNumber numberWithInt:version] forKey:@"RecipeVersion"];
    [defaults synchronize];

}

+ (NSArray*) allRecipesFromPersistentStore {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [defaults objectForKey:@"SavedRecipes"];
    NSArray *recipeArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    [defaults synchronize];
    
    return recipeArray;
}

+ (NSArray*) allRecipesFromDictionary: (NSDictionary*) recipeDictionary {

    //The plist with the recipe translation depending on the language of the device
    NSDictionary *localizedRecipeDescriptions = [Recipe localizedRecipeDescriptions];
    
    NSMutableArray *tempRecipes = [[NSMutableArray alloc] init];
    
    for (NSString *name in recipeDictionary) {
        
        Recipe *newRecipe = [[Recipe alloc]init];
        
        //Need to check if it's a nsdictionary as the version is saved in the dictionary as well
        if ([[recipeDictionary objectForKey:name]isKindOfClass:[NSDictionary class]]) {
            NSDictionary *tempRecipeDictionary = [recipeDictionary objectForKey:name];
            
            //Update the recipe attributes from the global plist
            if ([tempRecipeDictionary objectForKey:@"RecipeType"]) {
                [newRecipe setRecipeType:[[tempRecipeDictionary objectForKey:@"RecipeType"]intValue]];
            } else {
                NSLog(@"Recipe type missing for %@", name);
            }
            if ([tempRecipeDictionary objectForKey:@"RecipeCategory"]) {
                [newRecipe setRecipeCategory:[[tempRecipeDictionary objectForKey:@"RecipeCategory"]intValue]];
            } else {
                NSLog(@"Recipe category missing for %@", name);
            }
            if ([tempRecipeDictionary objectForKey:@"ImageName"]) {
                [newRecipe setImageName:[tempRecipeDictionary objectForKey:@"ImageName"]];
            } else {
                NSLog(@"Image name missing for %@", name);
            }
            if ([tempRecipeDictionary objectForKey:@"Sorting"]) {
                [newRecipe setSorting:[[tempRecipeDictionary objectForKey:@"Sorting"]intValue]];
            } else {
                NSLog(@"Sorting missing for %@", name);
            }
            
            //Update the recipe attribtues from the localized file
            NSDictionary *localizedDescriptionsForNewRecipe = [localizedRecipeDescriptions objectForKey:name];
            
            if ([localizedDescriptionsForNewRecipe objectForKey:@"RecipeName"]) {
                [newRecipe setRecipeName:[localizedDescriptionsForNewRecipe objectForKey:@"RecipeName"]];
            } else {
                NSLog(@"Localized name missing for %@", name);
            }
            if ([localizedDescriptionsForNewRecipe objectForKey:@"ShortDescription"]) {
                
                [newRecipe setShortDescription:[localizedDescriptionsForNewRecipe objectForKey:@"ShortDescription"]];
            } else {
                NSLog(@"Localized short desc missing for %@", name);
            }
            if ([localizedDescriptionsForNewRecipe objectForKey:@"LongDescription"]) {
                [newRecipe setLongDescription:[NSArray arrayWithArray:[localizedDescriptionsForNewRecipe objectForKey:@"LongDescription"]]];
            } else {
                NSLog(@"Localized long desc missing for %@", name);
            }
            if ([localizedDescriptionsForNewRecipe objectForKey:@"Instructions"]) {
                newRecipe.instructions = [NSArray arrayWithArray:[localizedDescriptionsForNewRecipe objectForKey:@"Instructions"]];
            } else {
                NSLog(@"Localized instructions missing for %@", name);
            }
            
            //Loop all the ingredient names for the recipe from the plist and add the ingredient to the recipe
            NSMutableArray *tempIngredients = [[NSMutableArray alloc]init];
            NSDictionary *ingredientDictionary;
            
            if ([[recipeDictionary objectForKey:name]objectForKey:@"Ingredients"]) {
                ingredientDictionary = [[recipeDictionary objectForKey:name]objectForKey:@"Ingredients"];
            }
            
            for (NSDictionary *dic in ingredientDictionary) {
                
                BOOL isOptional;
                if ([[ingredientDictionary objectForKey:dic]objectForKey:@"Optional"]) {
                    isOptional =[[[ingredientDictionary objectForKey:dic]objectForKey:@"Optional"]boolValue];
                } else {
                    NSLog(@"Optional flag not set for: %@", dic);
                }
                float quantity;
                if ([[ingredientDictionary objectForKey:dic]objectForKey:@"Quantity"]) {
                    quantity = [[[ingredientDictionary objectForKey:dic]objectForKey:@"Quantity"]floatValue];
                } else {
                    NSLog(@"Quantity not set for: %@", dic);
                }
                
                NSString *ingredientType;
                if ([[ingredientDictionary objectForKey:dic]objectForKey:@"Type"]) {
                    ingredientType = [[ingredientDictionary objectForKey:dic]objectForKey:@"Type"];
                } else {
                    NSLog(@"Type not set for: %@", dic);
                }
                
                NSString *measurement;
                if ([[ingredientDictionary objectForKey:dic]objectForKey:@"Measurement"]) {
                    measurement = [[ingredientDictionary objectForKey:dic]objectForKey:@"Measurement"];
                } else {
                    NSLog(@"Measurement not set for: %@", dic);
                }
                
                int sorting;
                if ([[ingredientDictionary objectForKey:dic]objectForKey:@"Sorting"]) {
                    sorting = [[[ingredientDictionary objectForKey:dic]objectForKey:@"Sorting"]intValue];
                } else {
                    NSLog(@"Sorting sequence not set for: %@", dic);
                }
                
                
                Ingredient *newIngredient = [[Ingredient alloc]initWithQuantity:quantity andType:ingredientType andMeasure:measurement andOptional:isOptional andSorting:sorting];
                
                
                [tempIngredients addObject:newIngredient];
                
            }
            
            //Sort the array by sorting order
            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"sorting" ascending:YES];
            NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
            
            //Store the ingredients for the recipe
            NSArray *sortedIngredients = [tempIngredients sortedArrayUsingDescriptors:sortDescriptors];
            newRecipe.ingredients = sortedIngredients;
            
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
            
            if (newRecipe != nil) {
                [tempRecipes addObject:newRecipe];
            } else {
                NSLog(@"Can't add recipe to db");
            }
        }
    }
    
    return tempRecipes;
    
}

+ (NSDictionary*) localizedRecipeDescriptions{
    
    //Identify the language of the device
    NSString *currentLanguage = [self currentLanguage];
    
    //Recipe description path depending on localization
    NSString *recipeDescriptionPath;
    
    if ([currentLanguage hasPrefix:@"sv"]) {
        recipeDescriptionPath = @"Swedish_recipeTexts";
    } else if ([currentLanguage hasPrefix:@"en"]) {
        recipeDescriptionPath = @"English_recipeTexts";
    } else {
        //English if any other language is the default
        recipeDescriptionPath = @"English_recipeTexts";
    }
    
    NSString *filepathToRecipeTranslation = [[NSBundle mainBundle] pathForResource:recipeDescriptionPath ofType:@"plist"];
    return [NSDictionary dictionaryWithContentsOfFile:filepathToRecipeTranslation];
    
}

+ (NSString*) currentLanguage {
    
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"selectedLanguage"]!= nil) {
        return [[NSUserDefaults standardUserDefaults]objectForKey:@"selectedLanguage"];
    } else {
        return [[NSLocale preferredLanguages] objectAtIndex:0];
    }
    
}

#pragma mark - Favorites

+ (NSArray*) favoriteRecipes {
    
    return [[NSUserDefaults standardUserDefaults]arrayForKey:@"FavoriteRecipes"];
    
}

+ (void) setNewFavoriteRecipes: (NSArray*) newRecipes {
    
    if (newRecipes) {
        [[NSUserDefaults standardUserDefaults]setObject:newRecipes forKey:@"FavoriteRecipes"];
    } else {
        NSLog(@"Issues in saving favorite recipes");
    }
    
    
}

*/

/*
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
    
    //TODO change this, it's awful! But I do this in order to save the favorites to memory.
    //Favorites are saved in an own NSUserDefault array that is verified when all recipes are created
    [Recipe saveRecipesToPersistentStore];
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
    
    //TODO change this, it's awful! But I do this in order to save the favorites to memory.
    //Favorites are saved in an own NSUserDefault array that is verified when all recipes are created
    [Recipe saveRecipesToPersistentStore];
    
    
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
 */

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
