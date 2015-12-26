//
//  NutritionViewController.h
//  Smoothie Box
//
//  Created by Jonas C Björkell on 2015-12-21.
//  Copyright © 2015 Jonas C Björkell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Recipe.h"


@interface NutritionViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate>

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) UIPageControl *pageControl;
@property (strong, nonatomic) Recipe *selectedRecipe;

- (void) hideCollectionView:(BOOL) hide;

@end
