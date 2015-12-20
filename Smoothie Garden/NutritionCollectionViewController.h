//
//  NutritionCollectionViewController.h
//  Smoothie Box
//
//  Created by Jonas C Björkell on 2015-12-20.
//  Copyright © 2015 Jonas C Björkell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Recipe.h"

@interface NutritionCollectionViewController : UICollectionViewController

@property (nonatomic, strong) Recipe *selectedRecipe;
@property (nonatomic, strong) NSArray *nutrientCatalog;
    
   

@end
