//
//  ShoppingListItem.h
//  Smoothie Box
//
//  Created by Jonas C Björkell on 2016-07-21.
//  Copyright © 2016 Jonas C Björkell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Ingredient.h"

@interface ShoppingListItem : NSObject <NSCoding>

@property (strong, nonatomic) Ingredient *ingredient;

- (id)initWithIngredient: (Ingredient*) i;
- (Ingredient*) ingredientForItem;
- (BOOL)isItemOfIngredientType: (Ingredient*) i;
- (void)addQuantityToItem: (float) q;

@end
