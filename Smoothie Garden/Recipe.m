//
//  Recipe.m
//  Smoothie Garden
//
//  Created by Jonas C Björkell on 2015-08-09.
//  Copyright (c) 2015 Jonas C Björkell. All rights reserved.
//



#define TAB_BAR_ALL 1000
#define TAB_BAR_FAV 1001

#import "Recipe.h"
#import "Ingredient.h"
#import "SBIAPHelper.h"

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

    NSString *filepath = [[NSBundle mainBundle] pathForResource:@"Recipes" ofType:@"plist"];
    NSDictionary *recipeDictionary = [NSDictionary dictionaryWithContentsOfFile:filepath];
    
    NSMutableArray *tempRecipes = [[NSMutableArray alloc] init];
    
    for (NSString *name in recipeDictionary) {
        Recipe *newRecipe = [[Recipe alloc]init];
        
        [newRecipe setRecipeType:[[[recipeDictionary objectForKey:name] objectForKey:@"RecipeType"]intValue]];
        [newRecipe setRecipeCategory:[[[recipeDictionary objectForKey:name] objectForKey:@"RecipeCategory"]intValue]];
        [newRecipe setRecipeName:[[recipeDictionary objectForKey:name] objectForKey:@"RecipeName"]];
        [newRecipe setImageName:[[recipeDictionary objectForKey:name] objectForKey:@"ImageName"]];
        [newRecipe setRecipeOverviewDescription:[[recipeDictionary objectForKey:name] objectForKey:@"RecipeOverviewDescription"]];
        [newRecipe setRecipeDescription:[[recipeDictionary objectForKey:name] objectForKey:@"RecipeDescription"]];
        [newRecipe setDetailedRecipedescription:[[recipeDictionary objectForKey:name] objectForKey:@"DetailedRecipeDescription"]];
        //[newRecipe setBoosterDescription:[[recipeDictionary objectForKey:name] objectForKey:@"BoosterDescription"]];
        
        
        newRecipe.detailedRecipedescription = [Recipe arrayForObject:name withArrayKey:@"DetailedRecipeDescription" inDictionary:recipeDictionary];
        newRecipe.recipeDescription = [Recipe arrayForObject:name withArrayKey:@"RecipeDescription" inDictionary:recipeDictionary];
        
        NSMutableArray *tempIngredients = [[NSMutableArray alloc]init];
        for (NSDictionary *dic in [[recipeDictionary objectForKey:name]objectForKey:@"Ingredients"]) {

            BOOL isOptional;
            if ([dic objectForKey:@"Optional"] != nil) {
                isOptional = [dic objectForKey:@"Optional"];
            } else {
                isOptional = NO;
            }
            
            Ingredient *newIngredient = [[Ingredient alloc]initWithQuantity:[dic objectForKey:@"Quantity"]
                                                                 andMeasure:[dic objectForKey:@"Measurement"]
                                                                    andText:[dic objectForKey:@"Text"]
                                                                andOptional:isOptional];
            [tempIngredients addObject:newIngredient];
        }
        
        
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



@end
