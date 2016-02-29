//
//  RecipeManager.m
//  Smoothie Box
//
//  Created by Jonas C Björkell on 2016-02-29.
//  Copyright © 2016 Jonas C Björkell. All rights reserved.
//

#import "RecipeManager.h"
#import "Recipe.h"
#import "Ingredient.h"

@implementation RecipeManager {
    
    NSArray *recipeMaster;
    NSArray *favoriteMaster;
}

+ (RecipeManager*)sharedInstance {
    static dispatch_once_t once;
    static RecipeManager * sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (id)init {
    
    if ((self = [super init])) {
        
        if ([self shouldUpdateRecipePersistentStore]) {
            
            [self saveRecipesToPersistentStore];
        }
        
        recipeMaster = [self allRecipesFromPersistentStore];
        
        favoriteMaster = [self favoriteRecipesFromPersistentStore];
        
    }
    return self;
}

- (NSArray*) recipesMaster {
    
    return recipeMaster;
}

- (NSArray*) favoritesMaster {
    return favoriteMaster;
}

#pragma mark - Persistent Store

- (BOOL) shouldUpdateRecipePersistentStore {
    
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

- (void) saveRecipesToPersistentStore {
    
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

- (NSArray*) allRecipesFromPersistentStore {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [defaults objectForKey:@"SavedRecipes"];
    NSArray *recipeArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    [defaults synchronize];
    
    return recipeArray;
}

#pragma mark - Dictionary

- (NSArray*) allRecipesFromDictionary: (NSDictionary*) recipeDictionary {
    
    //The plist with the recipe translation depending on the language of the device
    NSDictionary *localizedRecipeDescriptions = [self localizedRecipeDescriptions];
    
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
            for (NSString *recipeTitle in [self favoritesMaster]) {
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

- (NSDictionary*) localizedRecipeDescriptions{
    
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

- (NSString*) currentLanguage {
    
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"selectedLanguage"]!= nil) {
        return [[NSUserDefaults standardUserDefaults]objectForKey:@"selectedLanguage"];
    } else {
        return [[NSLocale preferredLanguages] objectAtIndex:0];
    }
    
}

#pragma mark - Favorites

- (NSArray*) favoriteRecipesFromPersistentStore {
    
    return [[NSUserDefaults standardUserDefaults]arrayForKey:@"FavoriteRecipes"];
    
}

- (void) setNewFavoriteRecipes: (NSArray*) newRecipes {
    
    [[NSUserDefaults standardUserDefaults]setObject:newRecipes forKey:@"FavoriteRecipes"];
    favoriteMaster = newRecipes;
    
}

- (void) removeRecipeFromFavorites:(Recipe*) recipeToRemove {
    
    NSMutableArray *tempDeleteRecipe = [[NSMutableArray alloc]init];
    
    NSArray *favoriteRecipes = [self favoritesMaster];
    
    for (NSString *recipe in favoriteRecipes) {
        if ([recipeToRemove.recipeName isEqualToString:recipe]) {
            [tempDeleteRecipe addObject:recipe];
        }
    }
    
    NSMutableArray *tempFavoriteRecipes = [NSMutableArray arrayWithArray:favoriteRecipes];
    if (tempDeleteRecipe.count>0) {
        [tempFavoriteRecipes removeObjectsInArray:tempDeleteRecipe];
    }
    
    //Set the new favorite recipes
    [self setNewFavoriteRecipes:[NSArray arrayWithArray:tempFavoriteRecipes]];
    
    //TODO change this, it's awful! But I do this in order to save the favorites to memory.
    //Favorites are saved in an own NSUserDefault array that is verified when all recipes are created
    [self saveRecipesToPersistentStore];
}

- (void) removeAllFavorites {
    
    [self setNewFavoriteRecipes:nil];

}

- (void) addRecipeToFavorites: (Recipe*) recipeToSave {
    
    //Load the favorite recipes array
    NSMutableArray *tempFavoriteRecipes;
    if ([self favoritesMaster].count>0) {
        tempFavoriteRecipes = [[NSMutableArray alloc]initWithArray:[self favoritesMaster]];
    } else {
        tempFavoriteRecipes = [[NSMutableArray alloc]init];
    }
    
    //Check if the array already hold this recipe, if not then add it
    if (![tempFavoriteRecipes containsObject:recipeToSave.recipeName]) {
        [tempFavoriteRecipes addObject:recipeToSave.recipeName];
    }
    
    NSArray *newFavoriteRecipes = [tempFavoriteRecipes copy];
    
    //Set the new favorite recipes
    [self setNewFavoriteRecipes:newFavoriteRecipes];
    
    //TODO change this, it's awful! But I do this in order to save the favorites to memory.
    //Favorites are saved in an own NSUserDefault array that is verified when all recipes are created
    [self saveRecipesToPersistentStore];
}

- (BOOL) isRecipeFavorite: (Recipe*) favorite {
    
    //Iterate all the favorite recipe and match for title
    //All recipes are saved as titles in the favorite array
    for (NSString *recipeTitle in [self favoritesMaster]) {
        if ([favorite.recipeName isEqualToString:recipeTitle]) {
            return YES;
        }
    }
    
    //If no recipe title found then it isn't a favorite
    return NO;
    
}

@end
