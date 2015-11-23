//
//  Recipe.m
//  Smoothie Garden
//
//  Created by Jonas C Björkell on 2015-08-09.
//  Copyright (c) 2015 Jonas C Björkell. All rights reserved.
//

#define METRIC_deciliter @"dl"
#define METRIC_teaspoon @"teaspoon"
#define METRIC_tablespoon @"tablespoon"
#define USCUSTOMARY_cup @"cup"

#import "Recipe.h"

@implementation Recipe

+ (NSString*) convertToUsUnitsFrom:(NSString *)metricText {
    
    NSArray *separatedString = [metricText componentsSeparatedByString:@","];
    
    if (separatedString.count>3) {
        NSLog(@"Separated string contains :%i strings", (int)separatedString.count);
    }
    
    //Ingredient text is formatted like
    //"1,dl,of nut milk
    
    //First object is the quantity
    NSString *quantity = [separatedString objectAtIndex:0];
    
    //Second object is the ingredient with a bunch of other text like "of", "and" etc.
    NSString *ingredient = [separatedString objectAtIndex:1];
    
    return [self usCustomaryUnitsFromMetricQuantity:[quantity floatValue] andIngredient:ingredient];
    
}


+ (NSString*) usCustomaryUnitsFromMetricQuantity: (float) qty andIngredient:(NSString*) type {
    
    NSString *measureType = [self measureTypeFromText:type];
    float usMeasure;
    if ([measureType isEqualToString:METRIC_deciliter]) {
        usMeasure = qty*0.42;
        
    } else if ([measureType isEqualToString:METRIC_tablespoon]) {
        usMeasure = qty; //1 tbsp equals 1 tbsp
        
    } else if ([measureType isEqualToString:METRIC_teaspoon]) {
        usMeasure = qty; //1 tsp equals 1 tsp
        
    } else
        NSLog(@"No US equivalent for %@", type);
    
    NSString *ingredientText = [type stringByReplacingOccurrencesOfString:METRIC_deciliter withString:USCUSTOMARY_cup];
    NSString *usCustomaryString = [NSString stringWithFormat:@"%@, %@", [self roundedNumberFrom:qty], ingredientText];
    
    return usCustomaryString;
    
}

+ (NSString*) measureTypeFromText: (NSString*) ingredientText {
    
    if ([ingredientText containsString:METRIC_deciliter]) {
        return METRIC_deciliter;
        
    } else if ([ingredientText containsString:METRIC_tablespoon]) {
        return METRIC_tablespoon;
        
    } else if ([ingredientText containsString:METRIC_teaspoon]) {
        return METRIC_teaspoon;
    }
    
    return ingredientText;
}

+ (NSString*) roundedNumberFrom: (float) number {
    float roundedValue = round(2.0f * number) / 2.0f;
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setMaximumFractionDigits:1];
    [formatter setRoundingMode: NSNumberFormatterRoundDown];
    
    return [formatter stringFromNumber:[NSNumber numberWithFloat:roundedValue]];
}

@end
