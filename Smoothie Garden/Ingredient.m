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
#define METRIC_centimeter @"cm"
#define METRIC_teaspoon @"tbsp"
#define METRIC_tablespoon @"tblsp"

#define USCUSTOMARY_cup @"cup"
#define USCUSTOMARY_inch @"inches"


#import "Ingredient.h"

@implementation Ingredient

- (id) initWithQuantity:(float)qty andType:(NSString*) type andMeasure:(NSString*)measure andOptional: (BOOL) optional {
    
    if (self = [super init]) { // equivalent to "self does not equal nil"
        
        self.quantity = qty;
        self.type = type; //Used for matching with the nutrient plist and localization
        self.measure = measure;
        self.optional = optional;
        
        
        //Check if it's a plural number of ingredients. Needed to set the text for the ingredient.
        BOOL pluralIngredient = NO;
        if (self.quantity>1) {
            pluralIngredient = YES;
        };
        
        //Set the text that should be shown for the ingredient in the recipe
        self.text = [self setupIngredientTextForIngredient:type andPlural:pluralIngredient];
        
        //Set the search strings by getting the string for the plural/singular that wasn't set to the text for the ingredient and then join that string with the text string
        NSString *pluralSingularString = [self setupIngredientTextForIngredient:type andPlural:!pluralIngredient];
        NSString *jointString = [NSString stringWithFormat:@"%@ %@", self.text, pluralSingularString];
        
        //Set the searchable string
        self.searchString = jointString;
        
        [self setupNutrientDataFromPlist];
    
    }
    
    return self;
    
}

- (NSString*) setupIngredientTextForIngredient: (NSString*) ingredient andPlural: (BOOL) plural {
    
    //Get the plist that has all the ingredient texts
    NSString *filepathToIngredientTexts = [[NSBundle mainBundle] pathForResource:@"IngredientsTranslation" ofType:@"plist"];
    NSDictionary *ingredientDictionary = [NSDictionary dictionaryWithContentsOfFile:filepathToIngredientTexts];
    
    //Get the dictionary for this ingredient
    NSDictionary *thisIngredients = [ingredientDictionary objectForKey:ingredient];
    
    //Get the current language
    NSString *language = [self currentLanguage];
    
    NSString *ingredientText;
    if (plural == YES) {
        //Get the plural text with the current language
        ingredientText = [[thisIngredients objectForKey:@"Pluralis"]objectForKey:language];
    } else if (plural == NO) {
        //Singularis text
        ingredientText = [[thisIngredients objectForKey:@"Singularis"]objectForKey:language];
    }
    if (ingredientText == nil) {
        NSLog(@"No translation for %@", ingredient);
        return ingredient;
    }

    return ingredientText;
}

- (NSString*) currentLanguage {
    
    //Identify the language of the device
    NSString *currentLanguage = [[NSLocale preferredLanguages] objectAtIndex:0];
    
    //Return the two first characters, ie. "en"
    return [currentLanguage substringToIndex:2];
    
}

- (NSString*) localizedMeasure {
    
    //Get the plist that has all the measurements
    NSString *filepathToMeasurementTexts = [[NSBundle mainBundle] pathForResource:@"Measurement" ofType:@"plist"];
    NSDictionary *measurementDictionary = [NSDictionary dictionaryWithContentsOfFile:filepathToMeasurementTexts];
    
    //Current language
    NSString *language = [self currentLanguage];
    
    //Get the localized measurement. If it's null then return blank space. (as in "1 [blank] banana")
    if ([[measurementDictionary objectForKey:self.measure]objectForKey:language]) {
        return [[measurementDictionary objectForKey:self.measure]objectForKey:language];
    } else {
        return @"";
    }
    
}

- (NSString*) stringWithQuantityAndMeasure {
    
    //Check what measurement that should be used. Metric or US
    int usedMeasurementMethod = [Ingredient usedMeasure];
    
    //Initialize a number formatter
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc]init];
    numberFormatter.locale = [NSLocale currentLocale];// this ensures the right separator behavior
    numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    numberFormatter.usesGroupingSeparator = YES;
    
    //Quantity of the ingredient
    float qty = self.quantity;
    
    //Set number of decimals depending on the quantity. If it's an integer then now decimals
    if (qty == (int)qty) {
        //Qty has integer value without decimals
        numberFormatter.maximumFractionDigits = 0;
    } else {
        //One decimal
        numberFormatter.maximumFractionDigits = 1;
    }
    
    //Final string to show to the user as quantity
    NSString *quantityString;
    
    //If quantity smaller than one it's always rounded to closest 0,5. so smaller than one means 0,5. Will show as 1/2 instead
    if (qty < 1) {
        quantityString = @"1/2";
    } else {
        NSLog(@"%@: %f is larger than 1", self.type, qty);
        quantityString = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:qty]];
    }
    
    //"optional" string in local language
    NSString *optional = NSLocalizedString(@"LOCALIZE_Optional", nil);
    
    //Joined string of quantity and measure
    NSString *qtyMeasure;
    
    //Converted qty
    float convertedQuantity;
    
    //Depending on US/Metric, add the measure to the quantity
    switch (usedMeasurementMethod) {
        case MEASUREMENT_METRIC:
            //If metric is used then no need for convertion
            //Just put the quantity (one decimal) and measure type together into a string
            
            qtyMeasure = [NSString stringWithFormat:@"%@ %@", quantityString, [self localizedMeasure]];
            
            if (self.optional) {
                
                NSString *stringWithOptional = [NSString stringWithFormat:@"(%@) %@", optional,qtyMeasure];
                return stringWithOptional;
            } else {
                return qtyMeasure;
            }
            break;
        case MEASUREMENT_US_CUSTOMARY_UNITS:
            //If US customary. Then we need to convert this before returning the string
            
            convertedQuantity = [self convertUsingMeasurementMethod:MEASUREMENT_US_CUSTOMARY_UNITS];
            qtyMeasure = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:convertedQuantity]];
            
            if (self.optional) {
                NSString *stringWithOptional = [NSString stringWithFormat:@"(%@) %@", optional,qtyMeasure];
                return stringWithOptional;
            } else {
                return qtyMeasure;
            }
        default:
            NSLog(@"WARNING, trying to use %i for measurement. %i doesn't exist", usedMeasurementMethod, usedMeasurementMethod);
            return nil;
            break;
    }
    
}

- (NSString*) stringWithIngredientText {
    
    return self.text;
}

#pragma mark - Nutrient information

- (NSDictionary*) allNutrients {
    
    return self.nutrients.nutrientValues;
}

- (void) setupNutrientDataFromPlist {
    
    NSMutableDictionary *nutrientParentDictionary = [[NSMutableDictionary alloc]init];
    
    NSString *filepath = [[NSBundle mainBundle] pathForResource:@"NutritionInformation" ofType:@"plist"];
    NSDictionary *dictionaryFromPlist = [NSDictionary dictionaryWithContentsOfFile:filepath];
    
    //Get dictionary from the type (banana, chia etc.) for the ingredient
    NSMutableDictionary *nutrientsDictionary;
    if ([dictionaryFromPlist objectForKey:self.type]) {
        nutrientsDictionary = [dictionaryFromPlist objectForKey:self.type]; // Get the dictionary for the specific ingredient
        
        for (NSDictionary *dic in nutrientsDictionary) {
            
            //Only loop when it's of NSDictionary class
            if ([[nutrientsDictionary objectForKey:dic] isKindOfClass:[NSDictionary class]]) {
                
                //Create a mutable dictionary so that the measurement can be changed
                NSMutableDictionary *newChildDictionary = [[NSMutableDictionary alloc]init];
                
                //Check if the class is dictionary (Unit is not) and if the measure object is available
                if ([[nutrientsDictionary objectForKey:dic] objectForKey:@"Measure"]) {
                    
                    NSString *nutrientVolume = [[nutrientsDictionary objectForKey:dic] objectForKey:@"Measure"]; // How many units that the ingredient consists of
                    
                    float nutrientVolumeFloat = [nutrientVolume floatValue]; //float value from the string
                    float ingredientVolumeFloat = self.quantity; //float value of the volume from the ingredient
        
                    //Depending on the unit calculate the measure based on the ingredient volume
                    
                    
                    //TODO
                    //Should the unit be saved on the ingredients?
                    
                    float newMeasureForNutrient = nutrientVolumeFloat * ingredientVolumeFloat;
                    
                    //Add the new measure to the dictionary
                    [newChildDictionary setObject:[NSString stringWithFormat:@"%f", newMeasureForNutrient] forKey:@"Measure"];
                    
                    //Add the other objects to the dictionary
                    [newChildDictionary setObject:[[nutrientsDictionary objectForKey:dic] objectForKey:@"Unit"] forKey:@"Unit"];
                    [newChildDictionary setObject:[[nutrientsDictionary objectForKey:dic] objectForKey:@"Type"] forKey:@"Type"];
                    
                    //Add the newly created dictionary to the parent dictionary that will hold all the nutrients
                    [nutrientParentDictionary setObject:newChildDictionary forKey:[NSString stringWithFormat:@"%@", dic]];
                    
                    /*
                    if ([[nutrientsDictionary objectForKey:@"Unit"] isEqualToString:@"Piece"]) {
                        NSLog(@"%@ is measured in pieces", self.type);
                        
                        float newMeasureForNutrient = nutrientVolumeFloat * ingredientVolumeFloat;
                        
                        NSLog(@"New Measure: %f", newMeasureForNutrient);
                        
                        //Add the new measure to the dictionary
                        [newChildDictionary setObject:[NSString stringWithFormat:@"%f", newMeasureForNutrient] forKey:@"Measure"];
                        
                        //Add the other objects to the dictionary
                        [newChildDictionary setObject:[[nutrientsDictionary objectForKey:dic] objectForKey:@"Unit"] forKey:@"Unit"];
                        [newChildDictionary setObject:[[nutrientsDictionary objectForKey:dic] objectForKey:@"Type"] forKey:@"Type"];
                        
                        //Add the newly created dictionary to the parent dictionary that will hold all the nutrients
                        [nutrientParentDictionary setObject:newChildDictionary forKey:[NSString stringWithFormat:@"%@", dic]];
                        
                    } else if ([[nutrientsDictionary objectForKey:@"Unit"] isEqualToString:@"G"]) {
                    
                        
                    
                } else if ([[nutrientsDictionary objectForKey:@"Unit"] isEqualToString:@"Mg"]) {
                    
                
                } else {
                    
                
                }*/
                
                }else {
                NSLog(@"%@ is no NSDictionary", [nutrientsDictionary objectForKey:dic]);
            
            }
            
            }
        
        
        }
    
    } else {
        NSLog(@"No dictionary for: %@", self.type);
    }
    
    
    
    if (nutrientParentDictionary) {
        
        self.nutrients = [[NutrientCatalog alloc]initWithDictionary:nutrientParentDictionary];
    } else {
        NSLog(@"No nutrients for %@", self.type);
    }
    
    
    
}

- (NSDictionary*) nutrientDataFor:(NSString *)nutrient {
    //Returns data with the total sum of the nutrient based on how many g/dl etc. the recipe consists of
   
    return [self.nutrients dictionaryForNutrient:nutrient];
    
}

- (NSDictionary*) nutrientCatalogWithNoValueForMeasure {
    return [self.nutrients dictionaryWithNoVolume];
}
- (NSString*) totalVolumeForNutrient: (NSString*) nutrient {
    
    //Returns to total volume for this specific nutrient based on the volume of the ingredient
    return [self.nutrients volumeForNutrient:nutrient];
    
}

#pragma mark - Convertion of measurement

- (float) convertUsingMeasurementMethod: (int) usedMeasurementMethod {
    
    //Create this mid-method to be able to add more measurements in the future. Are there any more?
    
    switch (usedMeasurementMethod) {
        case MEASUREMENT_US_CUSTOMARY_UNITS:
            //Call the method for the US Customary units
            return [self quantity:self.quantity usingUSCustomaryUnitsFor:self.measure];
            break;
            
        default:
            NSLog(@"Converting using a measurement method not in use: %i", usedMeasurementMethod);
            return 0;
            break;
    }
}

- (float) quantity: (float) qty usingUSCustomaryUnitsFor: (NSString*) measureType {
    
    
    //If the measure type is converted then convert to US Customary
    //If not, just return the same string as for metric
    if ([self isMeasureTypeConverted]) {
        float metricMeasure = qty;
        float usMeasure;
        NSString *newMeasureType = measureType;
        if ([measureType isEqualToString:METRIC_deciliter]) {
            //Convert deciliter into cups
            usMeasure = metricMeasure * 0.42;
            
            //Set a new text string for the "Cups" instead of "dl"
            newMeasureType = USCUSTOMARY_cup;
            
        } else if ([measureType isEqualToString:METRIC_tablespoon]) {
            usMeasure = metricMeasure; //1 tbsp equals 1 tbsp
            
        } else if ([measureType isEqualToString:METRIC_teaspoon]) {
            usMeasure = metricMeasure; //1 tsp equals 1 tsp
            
        } else if ([measureType isEqualToString:METRIC_centimeter]) {
          
            usMeasure = metricMeasure * 0.3937; //1cm is 0,4 inches
            newMeasureType = USCUSTOMARY_inch;
            
        } else
            NSLog(@"No US equivalent for %@", measureType);
        
        //Round the value
        NSLog(@"Us measure: %f", usMeasure);
        float roundedValue = round(2.0f * usMeasure) / 2.0f;
        NSLog(@"Rounded: %f", roundedValue);
        
        return roundedValue;
    } else {
        return qty;
    }
    
    
}

- (BOOL) isMeasureTypeConverted {
    
    //Check for all measuretypes there are available and return YES if one of those
    NSString *measureType = self.measure;
    if ([measureType isEqualToString:METRIC_deciliter] ||
        [measureType isEqualToString:METRIC_tablespoon] ||
        [measureType isEqualToString:METRIC_teaspoon] ||
        [measureType isEqualToString:METRIC_centimeter]) {
        return YES;
    } else {
        return NO;
    }
}

- (NSString*) roundedNumberFrom: (float) number {
    float roundedValue = round(2.0f * number) / 2.0f;
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setLocale:[NSLocale currentLocale]];
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

- (int) defaultMeasurementMethodForUser {
    
    //TODO
    //Validate the user country code to see if the user should be set to metric or US at app start
    
    return 0;
}

#pragma mark - Saved and Archived values
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
