//
//  Ingredient.m
//  Smoothie Box
//
//  Created by Jonas C Björkell on 2015-11-23.
//  Copyright © 2015 Jonas C Björkell. All rights reserved.
//

#import "Ingredient.h"

@implementation Ingredient

- (id) initWithQuantity:(NSString *)qty andMeasure:(NSString *)measure andText:(NSString *)txt {
    
    if (self = [super init]) { // equivalent to "self does not equal nil"
        
        self.quantity = qty;
        self.measure = measure;
        self.text = txt;
        
        
    }
    return self;
    
}

@end
