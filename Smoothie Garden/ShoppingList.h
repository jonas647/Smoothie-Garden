//
//  ShoppingList.h
//  Smoothie Box
//
//  Created by Jonas C Björkell on 2016-07-21.
//  Copyright © 2016 Jonas C Björkell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Ingredient.h"

@interface ShoppingList : NSObject

+ (ShoppingList*)sharedInstance;
//- (void) addShoppingListItemWithIngredient: (Ingredient*) i andQuantity: (float) q;
- (NSArray*) currentShoppingList;
- (void) addShoppingListItems: (NSArray*) ingredients;
- (void) removeShoppingListItemAtIndex:(NSUInteger)index;
- (void) clearShoppingList;

@end
