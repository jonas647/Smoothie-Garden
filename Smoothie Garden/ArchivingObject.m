//
//  ArchivingObject.m
//  Smoothie Garden
//
//  Created by Jonas C Björkell on 2015-09-25.
//  Copyright © 2015 Jonas C Björkell. All rights reserved.
//

#import "ArchivingObject.h"
#import "Recipe.h"

@implementation ArchivingObject

- (NSArray*) favoriteRecipes {
    
    return [[NSUserDefaults standardUserDefaults]arrayForKey:@"FavoriteRecipes"];
    
}

- (void) setNewFavoriteRecipes: (NSArray*) newRecipes {
    
    [[NSUserDefaults standardUserDefaults]setObject:newRecipes forKey:@"FavoriteRecipes"];
    
}

- (void) removeRecipeFromFavorites: (Recipe*) recipeToRemove {
    
    NSMutableArray *tempDeleteRecipe = [[NSMutableArray alloc]init];
    
    for (NSString *recipe in [self favoriteRecipes]) {
        if ([recipeToRemove.recipeName isEqualToString:recipe]) {
            [tempDeleteRecipe addObject:recipe];
        }
    }
    
    NSMutableArray *tempFavoriteRecipes = [NSMutableArray arrayWithArray:[self favoriteRecipes]];
    
    if (tempDeleteRecipe.count>0) {
        [tempFavoriteRecipes removeObjectsInArray:tempDeleteRecipe];
    }
    
    //Set the new favorite recipes
    [self setNewFavoriteRecipes:[NSArray arrayWithArray:tempFavoriteRecipes]];
}

- (void) addRecipeToFavorites:(Recipe*) newRecipe {
    
    //Load the favorite recipes array
    NSMutableArray *tempFavoriteRecipes;
    if ([self favoriteRecipes].count>0) {
        tempFavoriteRecipes = [[NSMutableArray alloc]initWithArray:[self favoriteRecipes]];
    } else {
        tempFavoriteRecipes = [[NSMutableArray alloc]init];
    }
    
    //Check if the array already hold this recipe, if not then add it
    if (![tempFavoriteRecipes containsObject:newRecipe.recipeName]) {
        [tempFavoriteRecipes addObject:newRecipe.recipeName];
    }
    
    NSArray *newFavoriteRecipes = [tempFavoriteRecipes copy];
    
    //Set the new favorite recipes
    [self setNewFavoriteRecipes:newFavoriteRecipes];
    
    NSLog(@"New favorites: %@", newFavoriteRecipes);
    
}


@end