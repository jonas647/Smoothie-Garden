//
//  Recipe.h
//  Smoothie Garden
//
//  Created by Jonas C Björkell on 2015-08-09.
//  Copyright (c) 2015 Jonas C Björkell. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - Recipe Types
#define RECIPE_TYPE_SMOOTHIE 1
#define RECIPE_TYPE_BOWL 2


@interface Recipe : NSObject

@property (nonatomic) int recipeType;
@property (nonatomic) int recipeCategory;
@property (nonatomic) BOOL favorite;
@property (nonatomic, strong) NSString *recipeName;
@property (nonatomic, strong) NSArray *recipeDescription;
@property (nonatomic, strong) NSArray *detailedRecipedescription;
@property (nonatomic, strong) NSArray *boosterDescription;
@property (nonatomic, strong) NSArray *ingredients;
@property (nonatomic, strong) NSString *imageName;


- (BOOL) isRecipeFavorite;
- (void) addRecipeToFavorites;
- (BOOL) isRecipeUnlocked;
- (NSString*) stringWithIngredients;
+ (void) setNewFavoriteRecipes: (NSArray*) newRecipes;
+ (NSArray*) favoriteRecipes;
+ (void) removeRecipeFromFavoritesUsingRecipeName: (NSString*) recipeName;
+ (NSArray*) allRecipesFromPlist;


@end
