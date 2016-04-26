//
//  SBPageViewRootViewController.m
//  Smoothie Box
//
//  Created by Jonas C Björkell on 2016-01-17.
//  Copyright © 2016 Jonas C Björkell. All rights reserved.
//

#import "SBPageViewRootViewController.h"


@interface SBPageViewRootViewController ()

@end

@implementation SBPageViewRootViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //Need to implement view did load to load custom page view, populate the view controllers etc.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSUInteger) indexForViewController: (UIViewController*) viewController {
    
    NSString * ident = viewController.restorationIdentifier;
    
    return [_viewControllers indexOfObject:ident];
}


- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexForViewController:viewController];
    
    if (index == 0 || index == NSNotFound) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexForViewController:viewController];
    
    if (index >= [_viewControllers count] || index == NSNotFound)
    {
        return nil;
    }
    index++;
    
    return [self viewControllerAtIndex:index];
}


- (UIViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if (index >= [_viewControllers count]) {
        return nil;
    }
    
    UIViewController *controllerAtIndex = [self.storyboard instantiateViewControllerWithIdentifier:[_viewControllers objectAtIndex:index]];
    return controllerAtIndex;
    
}


#pragma mark - Page Control

-(NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return [_viewControllers count];
}
- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}

- (void)changePage:(UIPageViewControllerNavigationDirection)direction {
    
    NSUInteger pageIndex = [self indexForViewController:[_pageViewController.viewControllers objectAtIndex:0]];
    
    if (direction == UIPageViewControllerNavigationDirectionForward) {
        pageIndex++;
    }
    else {
        pageIndex--;
    }
    
    UIViewController *viewController = [self viewControllerAtIndex:pageIndex];
    
    if (viewController == nil) {
        return;
    }
    
    [_pageViewController setViewControllers:@[viewController]
                                  direction:direction
                                   animated:YES
                                 completion:nil];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
