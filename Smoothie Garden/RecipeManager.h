//
//  RecipeManager.h
//  Smoothie Box
//
//  Created by Jonas C Björkell on 2016-02-29.
//  Copyright © 2016 Jonas C Björkell. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Recipe;

@interface RecipeManager : NSObject

+ (RecipeManager*)sharedInstance;
- (NSArray*) recipesMaster;

#pragma mark - Favorites
- (NSArray*) favoritesMaster;
- (BOOL) isRecipeFavorite: (Recipe*) favorite;
- (void) addRecipeToFavorites: (Recipe*) recipeToSave;
- (void) removeRecipeFromFavorites:(Recipe*) recipeToRemove;
- (void) removeAllFavorites;

@end
