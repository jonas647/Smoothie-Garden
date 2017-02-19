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
#import <UIKit/UIKit.h>

@implementation RecipeManager {
    
    NSArray *recipeMaster;
    NSDictionary *thumbnailImagesForRecipes;
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
        
        //Check if the persistent store should be updated
        if ([self shouldUpdateRecipePersistentStore]) {
            
            //Save the recipes to persistent store (NSUserDefault for now)
            [self saveRecipesToPersistentStore];
            
        }
        
        //Save the recipe master from the persistent store
        recipeMaster = [self sortRecipesInArray:[self allRecipesFromPersistentStore]];
    
        //Setup the thumbnail images
        NSMutableDictionary *tempThumbnailImagesForRecipes = [[NSMutableDictionary alloc]init];
        for (Recipe *r in recipeMaster) {
            
            
            //TODO check if file exist instead
            if (r.imageName != nil) {
              
                UIImage *tempImage = [self createThumbnailForImageWithName:r.imageName];
                
                [tempThumbnailImagesForRecipes setObject:tempImage forKey:r.recipeName];
              
            } else {
                NSLog(@"Name missing for %@", r);
            }
            
            
        }
        
        thumbnailImagesForRecipes = [NSDictionary dictionaryWithDictionary:tempThumbnailImagesForRecipes];
        
    }
    return self;
}

- (NSArray*) recipesMaster {
    
    return recipeMaster;
}


#pragma mark - Thumbnail images
- (NSDictionary*) thumbnailImages {
    
    return thumbnailImagesForRecipes;
}

- (UIImage*) createThumbnailForImageWithName:(NSString *)sourceName {
    
    UIImage* sourceImage = [UIImage imageNamed:sourceName];
    if (!sourceImage) {
        //...
        NSLog(@"Source image is missing: %@", sourceName);
    }
    
    //Size dependent sizing of the thumbnail to make the loading on older devicer quicker
    CGSize thumbnailSize = CGSizeMake([[UIScreen mainScreen]bounds].size.width, [[UIScreen mainScreen]bounds].size.width*0.8);
    
    UIGraphicsBeginImageContext(thumbnailSize);
    [sourceImage drawInRect:CGRectMake(0,0,thumbnailSize.width,thumbnailSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

#pragma mark - Persistent Store

- (BOOL) shouldUpdateRecipePersistentStore {
    
    //If the version has never been saved then load recipes
    if(![[[[NSUserDefaults standardUserDefaults] dictionaryRepresentation] allKeys] containsObject:@"RecipeVersion"]){

        return YES;
    } else {
        //Check what version of the recipes that are saved
        NSDictionary *recipeDictionary = [self recipeDictionaryFromPlist];
        
        if (recipeDictionary) {
            
            int versionOfRecipeList = [[recipeDictionary objectForKey:@"Version"]intValue];
            int currentVersion = (int)[[NSUserDefaults standardUserDefaults]integerForKey:@"RecipeVersion"];
            
            //Check what language that the saved recipes has and the current language
            NSString *recipeLanguage = [[NSUserDefaults standardUserDefaults]objectForKey:@"RecipeLanguage"];
            NSString *userLanguage = [self currentLanguage];
            
            //If the user language is another than the recipe language. Then load the recipes
            //If the version is lower than the last updated plist then load the recipes
            if (![userLanguage isEqualToString:recipeLanguage]) {
                
                return YES;
            } else if (currentVersion < versionOfRecipeList) {
                
                return YES;
            } else {
                
                return NO;
            }
        } else {
            NSLog(@"Recipe plist file doesn't exist");
            return NO;
        }
        
    }
}

- (void) updateRecipesInPersistentStore {
    
    //Load the recipe dictionary just to get the version number
    NSDictionary *recipeDictionary = [self recipeDictionaryFromPlist];
    int version = [[recipeDictionary objectForKey:@"Version"]intValue];
    
    [self saveToPersistentStore:self.recipesMaster withVersion:version];
}

- (void) saveRecipesToPersistentStore {
    
    //Get the plist with all the recipe information that's not localized
    NSDictionary *recipeDictionary = [self recipeDictionaryFromPlist];
    
    //Load all the recipes into array and add the localized information
    NSArray *recipes = [self allRecipesFromDictionary:recipeDictionary];
    
    //Load the version number
    int version;
    if ([recipeDictionary objectForKey:@"Version"]) {
        version = [[recipeDictionary objectForKey:@"Version"]intValue];
    } else {
        NSLog(@"No version information in plist");
    }
    
    [self saveToPersistentStore:recipes withVersion:version];
}

- (void) saveToPersistentStore: (NSArray*) recipeToSave withVersion: (int) version {
    
    //Save to NSUserDefault
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:recipeToSave];
    [defaults setObject:data forKey:@"SavedRecipes"];
    [defaults setObject:[NSNumber numberWithInt:version] forKey:@"RecipeVersion"];
    [defaults setObject:[self currentLanguage] forKey:@"RecipeLanguage"]; //Save the current language
    [defaults synchronize];
    
}

- (NSArray*) allRecipesFromPersistentStore {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [defaults objectForKey:@"SavedRecipes"];
    NSArray *recipeArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    [defaults synchronize];
    
    return recipeArray;
}

- (NSDictionary*) recipeDictionaryFromPlist {
    
    //The plist with the recipe directory
    NSString *filepathToRecipeMaster = [[NSBundle mainBundle] pathForResource:@"Recipes" ofType:@"plist"];
    NSDictionary *recipeDictionary = [NSDictionary dictionaryWithContentsOfFile:filepathToRecipeMaster];
    
    return recipeDictionary;
}

#pragma mark - Dictionary

- (NSArray*) allRecipesFromDictionary: (NSDictionary*) recipeDictionary {
    
    //The plist with the recipe translation depending on the language of the device
    NSDictionary *localizedRecipeDescriptions = [self localizedRecipeDescriptions];
    
    NSLog(@"LocalizedRecipeDescriptions");
    
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
            
            //Update the recipe attributes from the localized file
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
            
            //Sort the array with ingredients by sorting order
            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"sorting" ascending:YES];
            NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
            
            //Store the ingredients for the recipe
            NSArray *sortedIngredients = [tempIngredients sortedArrayUsingDescriptors:sortDescriptors];
            newRecipe.ingredients = sortedIngredients;
            
            [newRecipe setupAllNutrientInformationForRecipe];
            
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
    
    NSLog(@"Prefix: %@", [self currentLanguage]);
    
    if ([currentLanguage hasPrefix:@"sv"]) {
        recipeDescriptionPath = @"Swedish_recipeTexts";
    } else if ([currentLanguage hasPrefix:@"en"]) {
        recipeDescriptionPath = @"English_recipeTexts";
    } /*else if ([currentLanguage hasPrefix:@"da"]) {
       Not using danish yet
       
        recipeDescriptionPath = @"Danish_recipeTexts";
    } */else {
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
        
        return [[[NSLocale preferredLanguages] objectAtIndex:0]substringToIndex:2];
    }
    
}

#pragma mark - Favorites

- (NSArray*) favoriteRecipesFromPersistentStore {
    
    if (!recipeMaster) {
        recipeMaster = [self allRecipesFromPersistentStore];
    }
    
    NSMutableArray *tempFavorites = [[NSMutableArray alloc]init];
    for (Recipe *tempRecipe in recipeMaster) {
        if (tempRecipe.favorite == YES) {
            [tempFavorites addObject:tempRecipe];
        }
    }
    
    return tempFavorites;
    
}

- (void) removeRecipeFromFavorites:(Recipe*) recipeToRemove {
    
    recipeToRemove.favorite = NO;
    
    //Need to save the updated recipes to persistent store
    [self updateRecipesInPersistentStore];
}

- (void) removeAllFavorites {
    
    //[self setNewFavoriteRecipes:nil];

    //Loop all recipes and remove the favorite flag
    for (Recipe *r in self.recipesMaster) {
        if (r.favorite) {
            [r setFavorite:NO];
        }
    }
    
    //Need to save the updated recipes to persistent store
    [self updateRecipesInPersistentStore];
}

- (void) addRecipeToFavorites: (Recipe*) recipeToSave {
    
    
    recipeToSave.favorite = YES;
    
    //Need to save the updated recipes to persistent store
    [self updateRecipesInPersistentStore];
    
}

- (BOOL) isRecipeFavorite: (Recipe*) favorite {
    
    return favorite.favorite;

}

#pragma mark - Sorting

- (NSArray*) sortRecipesInArray: (NSArray*) recipeArray {
    
    //Sort the recipes by favorites and sorting order
    // Set ascending:NO so that "YES" would appear ahead of "NO"
    //Commenting out for now as we don't want to order by favorite recipes
    //NSSortDescriptor *boolDescr = [[NSSortDescriptor alloc] initWithKey:@"favorite" ascending:NO];
    // Sorted in 1,2,3 (ascending order)
    NSSortDescriptor *intDescr = [[NSSortDescriptor alloc] initWithKey:@"sorting" ascending:YES];
    // Combine the two
    NSArray *sortDescriptors = @[intDescr];
    
    return [recipeArray sortedArrayUsingDescriptors:sortDescriptors];
    
}


@end
