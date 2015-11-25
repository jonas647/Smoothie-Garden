//
//  Ingredient.h
//  Smoothie Box
//
//  Created by Jonas C Björkell on 2015-11-23.
//  Copyright © 2015 Jonas C Björkell. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Ingredient : NSObject

- (id) initWithQuantity: (NSString*) qty andMeasure: (NSString*) measure andText: (NSString*) txt;
- (NSString*) stringWithQuantityAndMeasure;
- (NSString*) stringWithIngredientText;

@property (nonatomic) NSString *measure;
@property (nonatomic, strong) NSString *quantity;
@property (nonatomic, strong) NSString *text;
+ (void) useMeasurementMethod: (int) measure ;
+ (int) usedMeasure;

@end
