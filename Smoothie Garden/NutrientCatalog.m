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

- (NSDictionary*) dictionaryWithNoVolume {
    
    //Create the nutrient dictionary that will hold all information of nutrient
    NSMutableDictionary *newNutrientDictionary = [[NSMutableDictionary alloc]init];
    
    for (NSMutableDictionary *dic in self.nutrientValues) {
        
            //Create a new dictionary to hold the nutrient facts
            NSMutableDictionary *nutrientDic = [[NSMutableDictionary alloc]init];
            [newNutrientDictionary setObject:nutrientDic forKey:dic];
            
            //Set the new objects for the nutrient dictionary
            NSString *unitString = [[self.nutrientValues objectForKey:dic]objectForKey:@"Unit"];
            NSString *typeString = [[self.nutrientValues objectForKey:dic]objectForKey:@"Type"];
            [nutrientDic setObject:unitString forKey:@"Unit"];
            [nutrientDic setObject:typeString forKey:@"Type"];
            
            //For all the nutrients update the volume/measure to 0 so that it can be summarized from the ingredient instead
            [nutrientDic setObject:@"0" forKey:@"Measure"];
            
        
            
        
    }
    NSLog(@"Returning with zero values %@ as dic", newNutrientDictionary);
    return newNutrientDictionary;
}

- (int) numberOfNutrients {
    
    return [self.nutrientValues count];
}

@end
