//
//  ShoppingList.m
//  Smoothie Box
//
//  Created by Jonas C Björkell on 2016-07-21.
//  Copyright © 2016 Jonas C Björkell. All rights reserved.
//

#import "ShoppingList.h"
#import "ShoppingListItem.h"

@implementation ShoppingList
{
    NSMutableArray *currentShoppingList;
}

+ (ShoppingList*)sharedInstance {
    static dispatch_once_t once;
    static ShoppingList * sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (id)init{
    
    if ((self = [super init])) {
        
        if([[[[NSUserDefaults standardUserDefaults] dictionaryRepresentation] allKeys] containsObject:@"SavedShoppingList"]){
            currentShoppingList = [self loadShoppingListFromPersistentStore];
            
        } else {
            currentShoppingList = [[NSMutableArray alloc]init];
        }
        
    }
    
    return self;
}

/*
//Check if the persistent store should be updated
if ([self shouldUpdateRecipePersistentStore]) {
    
    //Save the recipes to persistent store (NSUserDefault for now)
    [self saveRecipesToPersistentStore];
    
}
 */

/*
- (void) addShoppingListItemWithIngredient:(Ingredient *)i andQuantity:(float)q {
    
    //First check if that ingredient already exists in the shopping list
    ShoppingListItem *existingIngredient;
    for (ShoppingListItem *item in currentShoppingList) {
        if ([item isItemOfIngredientType:i]) {
            existingIngredient = item;
        }
    }
    
    //If the ingredient exist then the quantity should be added to the existing ingredient object. Otherwise just add the new object
    if (existingIngredient) {
        [existingIngredient addQuantityToItem:q];
    } else {
        ShoppingListItem *newItem = [[ShoppingListItem alloc ]initWithIngredient:i];
        
        [currentShoppingList addObject:newItem];
    }
    
    
}*/


- (NSArray*) currentShoppingList {

    return currentShoppingList;
    
}

- (void) addShoppingListItems:(NSArray *)ingredients {
    
    for (Ingredient *i in ingredients) {
        
        if ([i isKindOfClass:[Ingredient class]]) {
            ShoppingListItem *existingIngredient;
            for (ShoppingListItem *item in currentShoppingList) {
                if ([item isItemOfIngredientType:i]) {
                    existingIngredient = item;
                }
            }
            
            //If the ingredient exist then the quantity should be added to the existing ingredient object. Otherwise just add the new object
            if (existingIngredient) {
                [existingIngredient addQuantityToItem:i.quantity];
            } else {
                ShoppingListItem *newItem = [[ShoppingListItem alloc ]initWithIngredient:i];
                
                [currentShoppingList addObject:newItem];
            }
        }
    }
    
    [self saveShoppingListToPersistentStore];

}

- (void) removeShoppingListItemAtIndex:(NSUInteger)index{
    
    if (currentShoppingList.count - 1 >= index) {
        [currentShoppingList removeObjectAtIndex:index];
        
        [self saveShoppingListToPersistentStore];
    }
    
}

- (void) clearShoppingList {
    
    [currentShoppingList removeAllObjects];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SavedShoppingList"];
}

- (void) saveShoppingListToPersistentStore {
    
    //Save to NSUserDefault
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:currentShoppingList];
    [defaults setObject:data forKey:@"SavedShoppingList"];
    [defaults synchronize];
    
}

- (NSMutableArray*) loadShoppingListFromPersistentStore {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [defaults objectForKey:@"SavedShoppingList"];
    NSMutableArray *loadedShoppingList = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    [defaults synchronize];
    
    return loadedShoppingList;
}

@end
