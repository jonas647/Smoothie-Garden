//
//  Ingredient.m
//  Smoothie Box
//
//  Created by Jonas C Björkell on 2015-11-23.
//  Copyright © 2015 Jonas C Björkell. All rights reserved.
//

#define MEASUREMENT_METHOD @"MeasurementMethod"
#define MEASUREMENT_METRIC 1001
#define MEASUREMENT_US_CUSTOMARY_UNITS 1002
#define METRIC_deciliter @"dl"
#define METRIC_teaspoon @"tbsp"
#define METRIC_tablespoon @"tblsp"
#define USCUSTOMARY_cup @"cup"


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

- (NSString*) stringWithQuantityAndMeasure {
    
    //Check what measurement that should be used
    int usedMeasurementMethod = [Ingredient usedMeasure];
    
    switch (usedMeasurementMethod) {
        case MEASUREMENT_METRIC:
            //If metric is used then no need for convertion
            //Just put the quantity and measure type together into a string
            return [NSString stringWithFormat:@"%@ %@", self.quantity, self.measure];
            break;
        case MEASUREMENT_US_CUSTOMARY_UNITS:
            //If US customary. Then we need to convert this before returning the string
            return [self convertToStringUsingMeasurementMethod:MEASUREMENT_US_CUSTOMARY_UNITS];
        default:
            NSLog(@"WARNING, trying to use %i for measurement. %i doesn't exist", usedMeasurementMethod, usedMeasurementMethod);
            return nil;
            break;
    }
    
}

- (NSString*) stringWithIngredientText {
    
    return self.text;
}



#pragma mark - Convertion of measurement

- (NSString*) convertToStringUsingMeasurementMethod: (int) usedMeasurementMethod {
    
    //Create this mid-method to be able to add more measurements in the future. Are there any more?
    
    switch (usedMeasurementMethod) {
        case MEASUREMENT_US_CUSTOMARY_UNITS:
            //Call the method for the US Customary units
            return [self stringWithquantity:self.quantity usingUSCustomaryUnitsFor:self.measure];
            break;
            
        default:
            NSLog(@"Converting using a measurement method not in use: %i", usedMeasurementMethod);
            return nil;
            break;
    }
}

- (NSString*) stringWithquantity: (NSString*) qty usingUSCustomaryUnitsFor: (NSString*) measureType {
    
    
    //If the measure type is converted then convert to US Customary
    //If not, just return the same string as for metric
    if ([self isMeasureTypeConverted]) {
        float metricMeasure = 0.0;
        if ([qty floatValue]) {
            metricMeasure = [qty floatValue];
        } else {
            NSLog(@"Metric measure isn't of float value: %@", qty);
        }
        
        float usMeasure;
        NSString *newMeasureType = measureType;
        if ([measureType isEqualToString:METRIC_deciliter]) {
            //Convert deciliter into cups
            NSLog(@"-_-_-_-_-_-_--__--__-");
            NSLog(@"Converting Metric: %f", metricMeasure);
            usMeasure = metricMeasure * 0.42;
            NSLog(@"To US: %f", usMeasure);
            
            //Set a new text string for the "Cups" instead of "dl"
            newMeasureType = USCUSTOMARY_cup;
            
        } else if ([measureType isEqualToString:METRIC_tablespoon]) {
            usMeasure = metricMeasure; //1 tbsp equals 1 tbsp
            
        } else if ([measureType isEqualToString:METRIC_teaspoon]) {
            usMeasure = metricMeasure; //1 tsp equals 1 tsp
            
        } else
            NSLog(@"No US equivalent for %@", measureType);
        
        
        
        //Create the final string by appending the measure type ("Cups") to the quantity
        NSString *usCustomaryString = [NSString stringWithFormat:@"%@ %@", [self roundedNumberFrom:usMeasure], newMeasureType];
        
        return usCustomaryString;
    } else {
        return [NSString stringWithFormat:@"%@ %@", qty, measureType];
    }
    
    
}

- (BOOL) isMeasureTypeConverted {
    
    //Check for all measuretypes there are available and return YES if one of those
    NSString *measureType = self.measure;
    if ([measureType isEqualToString:METRIC_deciliter] ||
        [measureType isEqualToString:METRIC_tablespoon] ||
        [measureType isEqualToString:METRIC_teaspoon]) {
        return YES;
    } else {
        return NO;
    }
}

- (NSString*) roundedNumberFrom: (float) number {
    float roundedValue = round(2.0f * number) / 2.0f;
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setMaximumFractionDigits:1];
    [formatter setRoundingMode: NSNumberFormatterRoundDown];
    
    //Check if the quantity is half, then change it to 1/2 instead of 0.5
    //Otherwise just send back the rounded value (ie. "1", "1.5" etc.
    if (roundedValue == 0.5) {
        return @"1/2";
    } else {
        return [formatter stringFromNumber:[NSNumber numberWithFloat:roundedValue]];
    }
    
    
}

 //Saved/Archived values

+ (int) usedMeasure {
    
    if ([[NSUserDefaults standardUserDefaults]integerForKey:MEASUREMENT_METHOD]) {
        return (int)[[NSUserDefaults standardUserDefaults]integerForKey:MEASUREMENT_METHOD];
    } else
        return MEASUREMENT_METRIC;
    
}

+ (void) useMeasurementMethod: (int) measure {
    
    [[NSUserDefaults standardUserDefaults]setInteger:measure forKey:MEASUREMENT_METHOD];
    
}



@end
