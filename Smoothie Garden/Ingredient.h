//
//  Ingredient.h
//  Smoothie Box
//
//  Created by Jonas C Björkell on 2015-11-23.
//  Copyright © 2015 Jonas C Björkell. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Ingredient : NSObject

@property (nonatomic) int measure;
@property (nonatomic, strong) NSString *quantity;
@property (nonatomic, strong) NSString *ingredient;

@end
