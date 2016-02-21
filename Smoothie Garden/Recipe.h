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


@interface Recipe : NSObject <NSCoding>

@property (nonatomic) int recipeType;
@property (nonatomic) int recipeCategory;
@property (nonatomic) BOOL favorite;
@property (nonatomic) int sorting; //Used to sort the recipe in the table
@property (nonatomic, strong) NSString *recipeName;
@property (nonatomic, strong) NSString *shortDescription;
@property (nonatomic, strong) NSArray *instructions;
@property (nonatomic, strong) NSArray *longDescription;
@property (nonatomic, strong) NSArray *ingredients;
@property (nonatomic, strong) NSString *imageName;
@property (nonatomic, strong) NSMutableDictionary *totalNutrients;

- (BOOL) isRecipeFavorite;
- (void) addRecipeToFavorites;
- (BOOL) isRecipeUnlocked;
- (NSString*) stringWithIngredients;
- (NSArray*) allNutrientKeys;
- (NSString*) volumeStringForNutrient: (NSString*) nutrient;
- (NSString*) volumeForNutrient: (NSString*) nutrient asRoundedValue: (BOOL) rounded ;
- (NSString*) unitForNutrient: (NSString*) nutrient;
- (NSString*) typeForNutrient: (NSString*) nutrient;
- (NSString*) percentOfDailyIntakeFor: (NSString*) nutrient;
- (int) numberOfNutrients;
//- (NSDictionary*) allNutrientInformationForRecipe;

+ (void) setNewFavoriteRecipes: (NSArray*) newRecipes;
+ (NSArray*) favoriteRecipes;
+ (void) removeRecipeFromFavoritesUsingRecipeName: (NSString*) recipeName;
+ (NSArray*) recipeMaster;




@end
