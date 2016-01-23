//
//  InAppPurchasePageViewRootViewController.m
//  Smoothie Box
//
//  Created by Jonas C Björkell on 2016-01-17.
//  Copyright © 2016 Jonas C Björkell. All rights reserved.
//

#import "InAppPurchasePageViewRootViewController.h"

@interface InAppPurchasePageViewRootViewController ()

@end

@implementation InAppPurchasePageViewRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.viewControllers = [[NSMutableArray alloc]initWithObjects:@"inAppPurchaseScreenOne", @"inAppPurchaseScreenTwo", @"inAppPurchaseScreenThree", nil];
    
    // Create page view controller
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"InAppPageViewController"];
    self.pageViewController.dataSource = self;
    
    // Change the size of page view controller to fit the screen between header view and button
    self.pageViewController.view.frame = CGRectMake(0, CGRectGetMinY(_pageViewSize.frame), self.view.frame.size.width, CGRectGetHeight(_pageViewSize.frame)*0.55);
    
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    
    UIViewController *startingViewController = [self viewControllerAtIndex:0];
    NSArray *startingVCs = @[startingViewController];
    [self.pageViewController setViewControllers:startingVCs direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    [self.view bringSubviewToFront:self.pageViewController.view];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
