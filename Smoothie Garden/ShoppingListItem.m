//
//  ShoppingListItem.m
//  Smoothie Box
//
//  Created by Jonas C Björkell on 2016-07-21.
//  Copyright © 2016 Jonas C Björkell. All rights reserved.
//

#import "ShoppingListItem.h"
#import "Ingredient.h"

@implementation ShoppingListItem


- (id)initWithIngredient: (Ingredient*) i {
    
    if ((self = [super init])) {
    
        _ingredient = i;
        
    }
    
    return self;
}

- (Ingredient*) ingredientForItem {
    return _ingredient;
}

- (BOOL)isItemOfIngredientType:(Ingredient *)i {
    
    if (_ingredient.type == i.type) {
        return YES;
    } else {
        return NO;
    }
}

- (void)addQuantityToItem: (float) q {
    
    _ingredient.quantity = _ingredient.quantity + q;
    
}

- (id) initWithCoder:(NSCoder *)aDecoder {
    
    if(self = [super init]) {
        
        [self setIngredient:[aDecoder decodeObjectForKey:@"ingredient"]];
        
    }
    
    return self;
    
}
- (void) encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:_ingredient forKey:@"ingredient"];
    
}

@end
