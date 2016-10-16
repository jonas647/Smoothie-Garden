//
//  NutrientCollectionViewCell.h
//  Smoothie Box
//
//  Created by Jonas C Björkell on 2016-10-09.
//  Copyright © 2016 Jonas C Björkell. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NutrientCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *nutrientType;
@property (weak, nonatomic) IBOutlet UILabel *nutrientValue;
@property (weak, nonatomic) IBOutlet UILabel *percentOfDailyIntake;

@end
