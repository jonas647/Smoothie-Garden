//
//  PageViewRootViewController.h
//  Smoothie Garden
//
//  Created by Jonas C Björkell on 2015-09-29.
//  Copyright © 2015 Jonas C Björkell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PageContentViewController.h"

@interface PageViewRootViewController : UIViewController <UIPageViewControllerDataSource>

@property (nonatomic,strong) UIPageViewController *pageViewController;
@property (nonatomic,strong) NSArray *pageTitles;
@property (nonatomic,strong) NSArray *pageImages;
@property (nonatomic,strong) NSArray *leftPageImages;
@property (nonatomic,strong) NSArray *rightPageImages;
@property (nonatomic,strong) NSArray *pageTexts;

- (PageContentViewController *)viewControllerAtIndex:(NSUInteger)index;



@end
