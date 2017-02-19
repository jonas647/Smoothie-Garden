//
//  DetoxCollectionViewCell.h
//  Smoothie Box
//
//  Created by Jonas C Björkell on 2017-02-18.
//  Copyright © 2017 Jonas C Björkell. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetoxCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *headerLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *recipeTitle;



@end
