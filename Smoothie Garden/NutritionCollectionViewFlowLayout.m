//
//  NutritionCollectionViewFlowLayout.m
//  Smoothie Box
//
//  Created by Jonas C Björkell on 2015-12-23.
//  Copyright © 2015 Jonas C Björkell. All rights reserved.
//

#import "NutritionCollectionViewFlowLayout.h"

@implementation NutritionCollectionViewFlowLayout


 - (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
     CGRect oldBounds = self.collectionView.bounds;
     if (CGRectGetWidth(newBounds) != CGRectGetWidth(oldBounds)) {
         NSLog(@"Invalidate");
         return YES;
     }
     NSLog(@"Don't invalidate");
     return NO;
 }


@end
