//
//  SBPageViewRootViewController.h
//  Smoothie Box
//
//  Created by Jonas C Björkell on 2016-01-17.
//  Copyright © 2016 Jonas C Björkell. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SBPageViewRootViewController : UIViewController <UIPageViewControllerDataSource>

@property (nonatomic,strong) UIPageViewController *pageViewController;
@property (nonatomic, strong) NSMutableArray *viewControllers;

- (UIViewController *)viewControllerAtIndex:(NSUInteger)index;

@end
