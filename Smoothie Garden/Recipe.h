//
//  Recipe.h
//  Smoothie Garden
//
//  Created by Jonas C Björkell on 2015-08-09.
//  Copyright (c) 2015 Jonas C Björkell. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - Recipe Types
#define RECIPE_TYPE_SMOOTHIE 1
#define RECIPE_TYPE_BOWL 2


@interface Recipe : NSObject

@property (nonatomic) int recipeType;
@property (nonatomic) int recipeCategory;
@property (nonatomic) BOOL favorite;
@property (nonatomic, strong) NSString *recipeName;
@property (nonatomic, strong) NSString *recipeDescription;
@property (nonatomic, strong) NSString *detailedRecipedescription;
@property (nonatomic, strong) NSString *boosterDescription;
@property (nonatomic, strong) NSArray *ingredients;
@property (nonatomic, strong) NSString *imageName;

@end
