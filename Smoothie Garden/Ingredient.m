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

//For NSCoding
#define NSCoding_Measure @"iMeasure"
#define NSCoding_Type @"iType"
#define NSCoding_Qty @"iQty"
#define NSCoding_Text @"iText"
#define NSCoding_SearchString @"iSearchString"
#define NSCoding_Optional @"iOptional"
#define NSCoding_Sorting @"iSorting"
#define NSCoding_Nutrients @"iNutrients"


#import "Ingredient.h"

@implementation Ingredient

- (id) initWithQuantity:(float)qty andType:(NSString*) type andMeasure:(NSString*)measure andOptional: (BOOL) optional andSorting:(int)sorting {
    
    if (self = [super init]) { // equivalent to "self does not equal nil"
        
        self.quantity = qty;
        self.type = type; //Used for matching with the nutrient plist and localization
        self.measure = measure;
        self.optional = optional;
        self.sorting = sorting;
        
        //Check if it's a plural number of ingredients. Needed to set the text for the ingredient.
        BOOL pluralIngredient = NO;
        if (self.quantity>1) {
            pluralIngredient = YES;
        };
        
        //Set the text that should be shown for the ingredient in the recipe
        self.text = [self setupIngredientTextForIngredient:type andPlural:pluralIngredient];
        
        //Set the search strings by getting the string for the plural/singular that wasn't set to the text for the ingredient (so that it's possible to search for both singularis and pluralis) and then join that string with the text string
        NSString *pluralSingularString = [self setupIngredientTextForIngredient:type andPlural:!pluralIngredient];
        
        
        //Set the searchable string. If the plural is the same as singular then only one of them needed
        if ([pluralSingularString isEqualToString:self.text]) {
            self.searchString = self.text;
        } else {
            NSString *jointString = [NSString stringWithFormat:@"%@ %@", self.text, pluralSingularString];
            self.searchString = jointString;
        }
        
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
        //NSLog(@"No translation for %@", ingredient);
        return ingredient;
    }

    return ingredientText;
}

- (NSString*) currentLanguage {
    
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"selectedLanguage"]!= nil) {
        return [[NSUserDefaults standardUserDefaults]objectForKey:@"selectedLanguage"];
    } else {
        //Identify the language of the device
        NSString *currentLanguage = [[NSLocale preferredLanguages] objectAtIndex:0];
        
        //Return the two first characters, ie. "en"
        return [currentLanguage substringToIndex:2];
    }
    
}

- (NSString*) localizedMeasureFor: (NSString*) measure {
    
    //Get the plist that has all the measurements
    NSString *filepathToMeasurementTexts = [[NSBundle mainBundle] pathForResource:@"Measurement" ofType:@"plist"];
    NSDictionary *measurementDictionary = [NSDictionary dictionaryWithContentsOfFile:filepathToMeasurementTexts];
    
    //Current language
    NSString *language = [self currentLanguage];
    
    //Get the localized measurement. If it's null then return blank space. (as in "1 [blank] banana")
    if ([[measurementDictionary objectForKey:measure]objectForKey:language]) {
        return [[measurementDictionary objectForKey:measure]objectForKey:language];
    } else {
        return @"";
    }
    
}

- (NSString*) stringWithQuantityAndMeasure {
    
    //Check what measurement that should be used. Metric or US
    int usedMeasurementMethod = [Ingredient usedMeasure];
    
    //Get the quantity of the recipe
    float qty = [self convertQuantityUsingMeasurementMethod:usedMeasurementMethod];
    
    //Initialize a number formatter
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc]init];
    numberFormatter.locale = [NSLocale currentLocale];// this ensures the right separator behavior (comma vs dot)
    numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    numberFormatter.usesGroupingSeparator = YES;
    
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
    
    //If quantity smaller than one it's always rounded to closest 1/2, 1/4, 1/5 (using1/5 for chia/almond milk)
    
    if (qty == 0) {
        quantityString = @"";
    } else if (qty > 0 && qty <= 0.22) {
        quantityString = @"1/5";
    } else if (qty > 0 && qty < 0.3) {
        quantityString = @"1/4";
    } else if (qty > 0.3 && qty < 1) {
        quantityString = @"1/2";
    } else {
        quantityString = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:qty]];
    }
    
    //"optional" string in local language
    NSString *optional = NSLocalizedString(@"LOCALIZE_Optional", nil);
    
    //"Cups" or "dl"
    NSString *measure = [self convertMeasureTypeTo:usedMeasurementMethod];
    
    //Localize measure
    measure = [self localizedMeasureFor:measure];
    
    //Joined string of quantity and measure
    NSString *qtyMeasure = [NSString stringWithFormat:@"%@ %@", quantityString, measure];
    
    if (self.optional) {
        
        NSString *stringWithOptional = [NSString stringWithFormat:@"(%@) %@", optional,qtyMeasure];
        return stringWithOptional;
    } else {
        return qtyMeasure;
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
                    
                    float newMeasureForNutrient = nutrientVolumeFloat * ingredientVolumeFloat;
                    
                    //Add the new measure to the dictionary
                    if ([NSString stringWithFormat:@"%f", newMeasureForNutrient] != nil) {
                        
                        [newChildDictionary setObject:[NSString stringWithFormat:@"%f", newMeasureForNutrient] forKey:@"Measure"];
                    } else {
                        NSLog(@"Measure %f can't be saved for : %@", newMeasureForNutrient, dic);
                    }
                    
                    //Add the other objects to the dictionary
                    if ([[nutrientsDictionary objectForKey:dic] objectForKey:@"Unit"] != nil) {
                        [newChildDictionary setObject:[[nutrientsDictionary objectForKey:dic] objectForKey:@"Unit"] forKey:@"Unit"];
                    } else {
                        NSLog(@"Can't save Unit in %@", dic);
                    }
                    
                    if ([[nutrientsDictionary objectForKey:dic] objectForKey:@"Type"] != nil) {
                        [newChildDictionary setObject:[[nutrientsDictionary objectForKey:dic] objectForKey:@"Type"] forKey:@"Type"];
                    } else {
                        NSLog(@"Can't save Type in %@", dic);
                    }
                    
                    //Add the newly created dictionary to the parent dictionary that will hold all the nutrients
                    if (newChildDictionary != nil) {
                        [nutrientParentDictionary setObject:newChildDictionary forKey:[NSString stringWithFormat:@"%@", dic]];
                    } else {
                        NSLog(@"Child dictionary with ingredient not created properly");
                    }
                    
                    
                }else {
                //NSLog(@"%@ is no NSDictionary", [nutrientsDictionary objectForKey:dic]);
            
            }
            
            }
        
        
        }
    
    } else {
        //NSLog(@"No dictionary for: %@", self.type);
    }
    
    
    
    if (nutrientParentDictionary) {
        
        self.nutrients = [[NutrientCatalog alloc]initWithDictionary:nutrientParentDictionary];
    } else {
        //NSLog(@"No nutrients for %@", self.type);
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

- (float) convertQuantityUsingMeasurementMethod: (int) usedMeasurementMethod {
    
    //Quantity in the recipe
    float qty = self.quantity;
    //Measure type in the recipe
    NSString *measureType = self.measure;
    
    //Just make it simple since we just have two measurements and the Metric will just use the ones that are saved in the recipe.
    //So return the same qty if metric measure is used
    if (usedMeasurementMethod == MEASUREMENT_METRIC) {
        return qty;
    }
    
    //If the measure type is converted then convert to US Customary since that's the only thing right now
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
        
        return usMeasure;
    } else {
        return qty;
    }
    
}

- (NSString*) convertMeasureTypeTo: (int) usedMeasurementMethod {
    
    NSString *measureType = self.measure;
    NSString *newMeasureType = self.measure;
    
    //If metric is used then just return the same measure
    if (usedMeasurementMethod == MEASUREMENT_METRIC) {
        return newMeasureType;
    } else if ([measureType isEqualToString:METRIC_deciliter]) {
        
        //Set a new text string for the "Cups" instead of "dl"
        newMeasureType = USCUSTOMARY_cup;
        
    } else if ([measureType isEqualToString:METRIC_tablespoon]) {
        newMeasureType = measureType; //1 tbsp equals 1 tbsp
        
    } else if ([measureType isEqualToString:METRIC_teaspoon]) {
        newMeasureType = measureType; //1 tsp equals 1 tsp
        
    } else if ([measureType isEqualToString:METRIC_centimeter]) {
        
        newMeasureType = USCUSTOMARY_inch;
    }
    
    
    return newMeasureType;
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
    if (roundedValue == 0) {
        return @"";
    } else if (roundedValue == 0.5) {
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

- (id) initWithCoder:(NSCoder *)aDecoder {
    
    if(self = [super init]) {
        
        [self setMeasure:[aDecoder decodeObjectForKey:NSCoding_Measure]];
        [self setType:[aDecoder decodeObjectForKey:NSCoding_Type]];
        [self setQuantity:[aDecoder decodeFloatForKey:NSCoding_Qty]];
        [self setText:[aDecoder decodeObjectForKey:NSCoding_Text]];
        [self setSearchString:[aDecoder decodeObjectForKey:NSCoding_SearchString]];
        [self setOptional:[aDecoder decodeBoolForKey:NSCoding_Optional]];
        [self setSorting:[aDecoder decodeIntForKey:NSCoding_Sorting]];
        [self setNutrients:[aDecoder decodeObjectForKey:NSCoding_Nutrients]];
        
    }
    
    return self;
    
}
- (void) encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:self.measure forKey:NSCoding_Measure];
    [aCoder encodeObject:self.type forKey:NSCoding_Type];
    [aCoder encodeFloat:self.quantity forKey:NSCoding_Qty];
    [aCoder encodeObject:self.text forKey:NSCoding_Text];
    [aCoder encodeObject:self.searchString forKey:NSCoding_SearchString];
    [aCoder encodeBool:self.optional forKey:NSCoding_Optional];
    [aCoder encodeInt:self.sorting forKey:NSCoding_Sorting];
    [aCoder encodeObject:self.nutrients forKey:NSCoding_Nutrients];
    
}

/*
#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    
    Ingredient *newIngredient = [[[self class] allocWithZone:zone] init];
    newIngredient.measure = [_measure copyWithZone:zone];
    newIngredient.type = [_type copyWithZone:zone];
    newIngredient.quantity = [_quantity copyWithZone:zone];
    newIngredient.text = [_type copyWithZone:zone];
    newIngredient.searchString = [_type copyWithZone:zone];
    newIngredient.optional = [_type copyWithZone:zone];
    newIngredient.sorting = [_type copyWithZone:zone];
    newIngredient.nutrients = [_type copyWithZone:zone];
    
    return newIngredient;
    
}
*/

@end
