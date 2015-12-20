//
//  NutrientCatalog.h
//  Smoothie Box
//
//  Created by Jonas C Björkell on 2015-12-15.
//  Copyright © 2015 Jonas C Björkell. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NutrientCatalog : NSObject

@property (nonatomic,strong) NSString *measuringUnit;
@property (nonatomic,strong) NSDictionary *nutrientValues;

- (id) initWithDictionary: (NSDictionary*) dic;
- (NSString*) measuringUnitForIngredient;
- (NSString*) unitForNutrient:(NSString *)nutrient;
- (NSString*) volumeForNutrient: (NSString*)nutrient;

- (NSDictionary*) dictionaryForNutrient: (NSString*)nutrient;
- (NSDictionary*) dictionaryWithNoVolume;
- (int) numberOfNutrients;

@end
