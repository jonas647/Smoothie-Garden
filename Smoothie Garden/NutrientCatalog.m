//
//  NutrientCatalog.m
//  Smoothie Box
//
//  Created by Jonas C Björkell on 2015-12-15.
//  Copyright © 2015 Jonas C Björkell. All rights reserved.
//

#import "NutrientCatalog.h"

//NSCoding
#define NSCoding_NutrientValues @"NutrientValues"
#define NSCoding_MeasuringUnit @"Unit"

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
    return [[self.nutrientValues objectForKey:nutrient]objectForKey:@"Measure"];
}

- (NSDictionary*) dictionaryForNutrient:(NSString *)nutrient {
    
    for (NSDictionary *dic in self.nutrientValues) {
        if ([nutrient isEqualToString:[NSString stringWithFormat:@"%@", dic]]) {
            return dic;
        }
    }
    
    return nil;
}

- (NSDictionary*) dictionaryWithNoVolume {
    
    //Create the nutrient dictionary that will hold all information of nutrient
    NSMutableDictionary *newNutrientDictionary = [[NSMutableDictionary alloc]init];
    
    for (NSMutableDictionary *dic in self.nutrientValues) {
        
        //Create a new dictionary to hold the nutrient facts
        NSMutableDictionary *nutrientDic = [[NSMutableDictionary alloc]init];
        
        if (nutrientDic != nil) {
            [newNutrientDictionary setObject:nutrientDic forKey:dic];
        } else {
            NSLog(@"%@ doesn't exist", dic);
        }
        
        //Set the new objects for the nutrient dictionary
        NSString *unitString;
        if ([self.nutrientValues objectForKey:dic] != nil) {
            unitString = [[self.nutrientValues objectForKey:dic]objectForKey:@"Unit"];
        } else {
            NSLog(@"No unit found in nutrient values");
        }
        
        NSString *typeString;
        if ([self.nutrientValues objectForKey:dic] != nil) {
            typeString = [[self.nutrientValues objectForKey:dic]objectForKey:@"Type"];
        } else {
            NSLog(@"No type found in nutrient values");
        }
        
        [nutrientDic setObject:unitString forKey:@"Unit"];
        [nutrientDic setObject:typeString forKey:@"Type"];
        
        //For all the nutrients update the volume/measure to 0 so that it can be summarized from the ingredient instead
        [nutrientDic setObject:@"0" forKey:@"Measure"];
        
    }
    return newNutrientDictionary;
}

- (int) numberOfNutrients {
    
    return (int)[self.nutrientValues count];
}

- (id) initWithCoder:(NSCoder *)aDecoder {
    
    if(self = [super init]) {
        
        [self setNutrientValues:[aDecoder decodeObjectForKey:NSCoding_NutrientValues]];
        [self setMeasuringUnit:[aDecoder decodeObjectForKey:NSCoding_MeasuringUnit]];
        
    }
    
    return self;
    
}
- (void) encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:self.nutrientValues forKey:NSCoding_NutrientValues];
    [aCoder encodeObject:self.measuringUnit forKey:NSCoding_MeasuringUnit];
    
}

@end
