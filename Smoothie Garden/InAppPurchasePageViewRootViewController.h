//
//  InAppPurchasePageViewRootViewController.h
//  Smoothie Box
//
//  Created by Jonas C Björkell on 2016-01-17.
//  Copyright © 2016 Jonas C Björkell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBPageViewRootViewController.h"

@interface InAppPurchasePageViewRootViewController : SBPageViewRootViewController


@property (weak, nonatomic) IBOutlet UILabel *headerLabel;
@property (weak, nonatomic) IBOutlet UIButton *purchaseButton;
@property (weak, nonatomic) IBOutlet UIView *pageViewSize;


@end
