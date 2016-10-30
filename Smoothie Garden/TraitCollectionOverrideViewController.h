//
//  TraitCollectionOverrideViewController.h
//  Smoothie Box
//
//  Created by Jonas C Björkell on 2016-10-29.
//  Copyright © 2016 Jonas C Björkell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Recipe.h"

@interface TraitCollectionOverrideViewController : UIViewController {
    
    BOOL _willTransitionToPortrait;
    UITraitCollection *_traitCollection_CompactRegular;
    UITraitCollection *_traitCollection_AnyAny;
}

@property (nonatomic, strong) Recipe *selectedRecipe;
@property (weak, nonatomic) IBOutlet UIView *containerView;

@end