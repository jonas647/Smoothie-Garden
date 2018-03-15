//
//  RecipeSplitViewController.m
//  Smoothie Box
//
//  Created by Jonas C Björkell on 2016-09-03.
//  Copyright © 2016 Jonas C Björkell. All rights reserved.
//

#import "RecipeSplitViewController.h"
#import "DetailedRecipeViewController.h"

@interface RecipeSplitViewController ()

@end

@implementation RecipeSplitViewController 

- (void)viewDidLoad {
    [super viewDidLoad];

    self.delegate = self;
    
    self.navigationItem.leftBarButtonItem = [self displayModeButtonItem];
    self.navigationItem.leftItemsSupplementBackButton = YES;
}

- (void)viewDidLayoutSubviews {
    
    //Set size of the master/detail views not to make the detailed view too big
    CGFloat minimumWidth = MIN(CGRectGetWidth(self.view.bounds),CGRectGetHeight(self.view.bounds));
    self.minimumPrimaryColumnWidth = minimumWidth / 2;
    self.maximumPrimaryColumnWidth = minimumWidth;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark -
#pragma mark Split View Controller delegate.

- (BOOL)splitViewController:(UISplitViewController *)splitViewController showViewController:(UIViewController *)vc sender:(id)sender
{
    //Standard behaviour.  This won't get called in our case when the split view is collapsed and the primary view controllers are obscured.
    return NO;
}

// Since we treat warnings as errors, silence warning about unknown selector below on UIViewController subclasses.
#pragma GCC diagnostic ignored "-Wundeclared-selector"

/*
- (BOOL)splitViewController:(UISplitViewController *)splitViewController showDetailViewController:(UIViewController *)vc sender:(id)sender
{
    if (splitViewController.collapsed == NO)
    {
        // The navigation controller we'll be adding the view controller vc to.
        UINavigationController *navController = splitViewController.viewControllers[1];
        
        UIViewController *topDetailViewController = [navController.viewControllers lastObject];
        if ([topDetailViewController isKindOfClass:[DetailedRecipeViewController class]] ||
            ([vc respondsToSelector:@selector(shouldReplaceDetailedView)] && [vc performSelector:@selector(shouldReplaceDetailedView)]))
        {
            // Replace the (expanded) detail view with this new view controller.
            [navController setViewControllers:@[vc] animated:NO];
        }
        else
        {
            // Otherwise, just push.
            [navController pushViewController:vc animated:YES];
        }
    }
    else
    {
        // Collapsed.  Just push onto the conbined primary and detailed navigation controller.
        UINavigationController *navController = splitViewController.viewControllers[0];
        [navController pushViewController:vc animated:YES];
    }
    
    // We've handled this ourselves.
    return YES;
}

- (BOOL)splitViewController:(UISplitViewController *)splitViewController collapseSecondaryViewController:(UIViewController *)secondaryViewController ontoPrimaryViewController:(UIViewController *)primaryViewController
{
    UINavigationController *primaryNavController = (UINavigationController *)primaryViewController;
    UINavigationController *secondaryNavController = (UINavigationController *)secondaryViewController;
    UIViewController *bottomSecondaryView = [secondaryNavController.viewControllers firstObject];
    if ([bottomSecondaryView isKindOfClass:[DetailedRecipeViewController class]])
    {
        NSAssert([secondaryNavController.viewControllers count] == 1, @"BlankViewController is not only detail view controller");
        // If our secondary controller is blank, do the collapse ourself by doing nothing.
        return YES;
    }
    
    // We need to shift these view controllers ourselves.
    // This should be the primary views and then the detailed views on top.
    // Otherwise the UISplitViewController does wacky things like embedding a UINavigationController inside another UINavigation Controller, which causes problems for us later.
    NSMutableArray *newPrimaryViewControllers = [NSMutableArray arrayWithArray:primaryNavController.viewControllers];
    [newPrimaryViewControllers addObjectsFromArray:secondaryNavController.viewControllers];
    primaryNavController.viewControllers = newPrimaryViewControllers;
    
    return YES;
}

- (UIViewController *)splitViewController:(UISplitViewController *)splitViewController separateSecondaryViewControllerFromPrimaryViewController:(UIViewController *)primaryViewController
{
    UINavigationController *primaryNavController = (UINavigationController *)primaryViewController;
    
    // Split up the combined primary and detail navigation controller in their component primary and detail view controller lists, but with same ordering.
    NSMutableArray *newPrimaryViewControllers = [NSMutableArray array];
    NSMutableArray *newDetailViewControllers = [NSMutableArray array];
    for (UIViewController *controller in primaryNavController.viewControllers)
    {
        if ([controller respondsToSelector:@selector(shouldDisplayInDetailedView)] && [controller performSelector:@selector(shouldDisplayInDetailedView)])
        {
            [newDetailViewControllers addObject:controller];
        }
        else
        {
            [newPrimaryViewControllers addObject:controller];
        }
    }
    
    if (newDetailViewControllers.count == 0)
    {
        // If there's no detailed views on the top of the navigation stack, return a blank view  (in navigation controller) for detailed side.
        UINavigationController *blankDetailNavController = [[UINavigationController alloc] initWithRootViewController:[[DetailedRecipeViewController alloc] init]];
        return blankDetailNavController;
    }
    
    // Set the new primary views.
    primaryNavController.viewControllers = newPrimaryViewControllers;
    
    // Return the new detail navigation controller and views.
    UINavigationController *detailNavController = [[UINavigationController alloc] init];
    detailNavController.viewControllers = newDetailViewControllers;
    return detailNavController;
}
*/

@end
