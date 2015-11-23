//
//  Recipe.m
//  Smoothie Garden
//
//  Created by Jonas C Björkell on 2015-08-09.
//  Copyright (c) 2015 Jonas C Björkell. All rights reserved.
//

#define METRIC_deciliter @"dl"
#define METRIC_teaspoon @"teaspoon"
#define METRIC_tablespoon @"tablespoon"
#define USCUSTOMARY_cup @"cup"

#define TAB_BAR_ALL 1000
#define TAB_BAR_FAV 1001

#import "Recipe.h"
#import "Ingredient.h"
#import "ArchivingObject.h"

@implementation Recipe

#pragma mark - Selection of Recipes

+ (NSArray*) recipesFromPlistFor: (int) selection {
    
    switch (selection) {
        case TAB_BAR_ALL:
            //Show all recipes
            return [self allRecipesFromPlist];
            break;
        case TAB_BAR_FAV:
            //Show the favorite recipes
            return [self favoriteRecipes];
            break;
        default:
            break;
    }
    
    return nil;
}

#pragma mark - Load Recipes
+ (NSArray*) allRecipesFromPlist {
    
    NSLog(@"Getting all recipes from plist");
    
    
    
    NSString *filepath = [[NSBundle mainBundle] pathForResource:@"Recipes" ofType:@"plist"];
    NSDictionary *recipeDictionary = [NSDictionary dictionaryWithContentsOfFile:filepath];
    
    NSMutableArray *tempRecipes = [[NSMutableArray alloc] init];
    
    for (NSString *name in recipeDictionary) {
        Recipe *newRecipe = [[Recipe alloc]init];
        
        [newRecipe setRecipeType:[[[recipeDictionary objectForKey:name] objectForKey:@"RecipeType"]intValue]];
        [newRecipe setRecipeCategory:[[[recipeDictionary objectForKey:name] objectForKey:@"RecipeCategory"]intValue]];
        [newRecipe setRecipeName:[[recipeDictionary objectForKey:name] objectForKey:@"RecipeName"]];
        [newRecipe setImageName:[[recipeDictionary objectForKey:name] objectForKey:@"ImageName"]];
        [newRecipe setRecipeDescription:[[recipeDictionary objectForKey:name] objectForKey:@"RecipeDescription"]];
        [newRecipe setDetailedRecipedescription:[[recipeDictionary objectForKey:name] objectForKey:@"DetailedRecipeDescription"]];
        [newRecipe setBoosterDescription:[[recipeDictionary objectForKey:name] objectForKey:@"BoosterDescription"]];
        
        NSLog(@"Extracting the arrays");
        
        newRecipe.detailedRecipedescription = [Recipe arrayForObject:name withArrayKey:@"RecipeDescription" inDictionary:recipeDictionary];
        newRecipe.recipeDescription = [Recipe arrayForObject:name withArrayKey:@"RecipeDescription" inDictionary:recipeDictionary];
        
        NSLog(@"Just the ingredients left");
        NSMutableArray *tempIngredients = [[NSMutableArray alloc]init];
        for (NSDictionary *dic in [[recipeDictionary objectForKey:name]objectForKey:@"Ingredients"]) {
            
            Ingredient *newIngredient = [[Ingredient alloc]initWithQuantity:[dic objectForKey:@"Quantity"]
                                                                 andMeasure:[dic objectForKey:@"Measurement"]
                                                                    andText:[dic objectForKey:@"Text"]];
            [tempIngredients addObject:newIngredient];
        }
        
        NSLog(@"Recipe with ingredients: %@", newRecipe.ingredients);
        newRecipe.ingredients = [NSArray arrayWithArray:tempIngredients];
        
        [tempRecipes addObject:newRecipe];
    }
    
    return tempRecipes;
    
}

+ (NSArray*) arrayForObject: (NSString*) obj withArrayKey: (NSString*) key inDictionary: (NSDictionary*) dic {
    
    NSMutableArray *tempObjects = [[NSMutableArray alloc]init];
    for (NSString *textString in [[dic objectForKey:obj] objectForKey:key]) {
        [tempObjects addObject:textString];
    }
    return (NSArray*)tempObjects;
}

#pragma mark - Favorite Recipes

+ (NSArray*) favoriteRecipes {
    
    //Load the favorite recipes array
    NSArray *favoriteRecipes = [[ArchivingObject sharedInstance] favoriteRecipes];
    NSMutableArray *tempFavoriteRecipes = [[NSMutableArray alloc]init];
    
    //Iterate all recipes and match with the names saved as favorites to get all favorite recipes to a new array
    for (Recipe *tempRecipe in [self allRecipesFromPlist]) {
        
        for (NSString *tempName in favoriteRecipes) {
            if ([tempRecipe.recipeName isEqualToString:tempName]) {
                [tempFavoriteRecipes addObject:tempRecipe];
            }
        }
    }
    
    NSArray *favoritesToReturn = [NSArray arrayWithArray:tempFavoriteRecipes];
    return favoritesToReturn;
}

- (BOOL) isRecipeFavorite {
    
    return [[ArchivingObject sharedInstance]isRecipeFavorite:self];
}

- (void) removeRecipeFromFavorites {
    [[ArchivingObject sharedInstance]removeRecipeFromFavorites:self.recipeName];
}

#pragma mark - In app Purchases

- (BOOL) isRecipeUnlocked {
    
    //If the recipe category is 0 then it's free from start in the app. No need for IAP check
    //IAP "basicRecipes_01 unlocks the recipes with category 1. It's the only IAP available right now
    if (self.recipeCategory == 0) {
        return YES;
    } else if (self.recipeCategory == 1) {
        return [[ArchivingObject sharedInstance]isIAPUnlocked:@"basicRecipes_01"];
    } else {
        NSLog(@"No IAP for recipe category: %i", (int)self.recipeCategory);
        return NO;
    }
    
}



#pragma mark - Convertion of measurement

+ (NSString*) convertToUsUnitsFrom:(NSString *)metricText {
    
    NSArray *separatedString = [metricText componentsSeparatedByString:@","];
    
    if (separatedString.count>3) {
        NSLog(@"Separated string contains :%i strings", (int)separatedString.count);
    }
    
    //First object is the quantity
    NSString *quantity = [separatedString objectAtIndex:0];
    
    //Second object is the ingredient with a bunch of other text like "of", "and" etc.
    NSString *ingredient = [separatedString objectAtIndex:1];
    
    return [self usCustomaryUnitsFromMetricQuantity:[quantity floatValue] andIngredient:ingredient];
    
}


+ (NSString*) usCustomaryUnitsFromMetricQuantity: (float) qty andIngredient:(NSString*) type {
    
    NSString *measureType = [self measureTypeFromText:type];
    float usMeasure;
    if ([measureType isEqualToString:METRIC_deciliter]) {
        usMeasure = qty*0.42;
        
    } else if ([measureType isEqualToString:METRIC_tablespoon]) {
        usMeasure = qty; //1 tbsp equals 1 tbsp
        
    } else if ([measureType isEqualToString:METRIC_teaspoon]) {
        usMeasure = qty; //1 tsp equals 1 tsp
        
    } else
        NSLog(@"No US equivalent for %@", type);
    
    NSString *ingredientText = [type stringByReplacingOccurrencesOfString:METRIC_deciliter withString:USCUSTOMARY_cup];
    NSString *usCustomaryString = [NSString stringWithFormat:@"%@, %@", [self roundedNumberFrom:qty], ingredientText];
    
    return usCustomaryString;
    
}

+ (NSString*) measureTypeFromText: (NSString*) ingredientText {
    
    if ([ingredientText containsString:METRIC_deciliter]) {
        return METRIC_deciliter;
        
    } else if ([ingredientText containsString:METRIC_tablespoon]) {
        return METRIC_tablespoon;
        
    } else if ([ingredientText containsString:METRIC_teaspoon]) {
        return METRIC_teaspoon;
    }
    
    return ingredientText;
}

+ (NSString*) roundedNumberFrom: (float) number {
    float roundedValue = round(2.0f * number) / 2.0f;
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setMaximumFractionDigits:1];
    [formatter setRoundingMode: NSNumberFormatterRoundDown];
    
    return [formatter stringFromNumber:[NSNumber numberWithFloat:roundedValue]];
}

@end
