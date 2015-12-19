//
//  Ingredient.h
//  Smoothie Box
//
//  Created by Jonas C Björkell on 2015-11-23.
//  Copyright © 2015 Jonas C Björkell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NutrientCatalog.h"

@interface Ingredient : NSObject

- (id) initWithQuantity:(NSString *)qty andType: (NSString*) type andMeasure:(NSString *)measure andText:(NSString *)txt andOptional: (BOOL) optional;
- (NSString*) stringWithQuantityAndMeasure;
- (NSString*) stringWithIngredientText;

@property (nonatomic, strong) NSString *measure;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *quantity;
@property (nonatomic, strong) NSString *text;
@property (nonatomic) BOOL optional;

@property (nonatomic, strong) NutrientCatalog *nutrients;

- (NSDictionary*) nutrientDataFor:(NSString *)nutrient;

+ (void) useMeasurementMethod: (int) measure ;
+ (int) usedMeasure;

@end
