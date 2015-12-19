//
//  NutrientCatalog.m
//  Smoothie Box
//
//  Created by Jonas C Björkell on 2015-12-15.
//  Copyright © 2015 Jonas C Björkell. All rights reserved.
//

#import "NutrientCatalog.h"

@implementation NutrientCatalog


- (id) initWithDictionary: (NSDictionary*) dic {
 
    if (self = [super init]) { // equivalent to "self does not equal nil"
        
        self.nutrientValues = dic;
        self.measuringUnit = [dic objectForKey:@"Unit"];
    }
    
    return self;
}

- (NSString*) measuringUnitForIngredient {
    
    //Return the unit that the ingredient is measured in (grams, pieces, dl, tbsp etc.)
    return [self.nutrientValues objectForKey:@"Unit"];
}

- (NSString*) unitForNutrient:(NSString *)nutrient {
    
    //Return the unit (g, mg etc.) for the requested nutrient
    return [[self.nutrientValues objectForKey:nutrient]objectForKey:@"Unit"];
}
- (NSString*) volumeForNutrient: (NSString*)nutrient {
    
    //Return the measure (units, volume) for the nutrient.
    NSLog(@"Measure for %@", nutrient);
    return [[self.nutrientValues objectForKey:nutrient]objectForKey:@"Measure"];
}

- (NSDictionary*) dictionaryForNutrient:(NSString *)nutrient {
    
    for (NSDictionary *dic in self.nutrientValues) {
        if ([nutrient isEqualToString:[NSString stringWithFormat:@"%@", dic]]) {
            return dic;
        }
    }
    
    NSLog(@"No matching dictionaries for %@", nutrient);
    
    return nil;
}

- (int) numberOfNutrients {
    
    return [self.nutrientValues count];
}

@end
