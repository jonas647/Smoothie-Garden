//
//  ArchivingObject.h
//  Smoothie Garden
//
//  Created by Jonas C Björkell on 2015-09-25.
//  Copyright © 2015 Jonas C Björkell. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Recipe;

@interface ArchivingObject : NSObject

- (void) addRecipeToFavorites:(Recipe*) newRecipe;
- (void) removeRecipeFromFavorites: (Recipe*) recipeToRemove;
- (void) setNewFavoriteRecipes: (NSArray*) newRecipes;
- (BOOL) isRecipeFavorite: (Recipe*) favoriteRecipe;
- (NSArray*) favoriteRecipes;

@end
