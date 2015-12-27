//
//  NutrientFactPageViewRootViewController.m
//  Smoothie Box
//
//  Created by Jonas C Björkell on 2015-12-19.
//  Copyright © 2015 Jonas C Björkell. All rights reserved.
//

#import "NutrientFactPageViewRootViewController.h"
#import "NutritionPageContentViewController.h"
#import "BlankViewController.h"

@interface NutrientFactPageViewRootViewController ()

@end

@implementation NutrientFactPageViewRootViewController
{
    //SBActivityIndicatorView *loadingIndicator;
    NSMutableArray *vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _recipeImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", self.selectedRecipe.imageName]];
   
    vc = [[NSMutableArray alloc]init];
    [vc addObject:@"BlankViewController"];
    [vc addObject:@"NutrientPageContentController"];
    
    // Create page view controller
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"NutrientPageViewController"];
    self.pageViewController.dataSource = self;
    
    // Change the size of page view controller
    // Set the Y start position somewhat lower since the navigation bar is on screen
    //self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - self.view.frame.size.height*0.15);

    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    
    BlankViewController *startingViewController = (BlankViewController*)[self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    [self.view bringSubviewToFront:_pageViewController.view];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSUInteger) indexForViewController: (UIViewController*) viewController {
    
    NSString * ident = viewController.restorationIdentifier;
    
    NSLog(@"Identifier for vc: %@", viewController.restorationIdentifier);
    
    return [vc indexOfObject:ident];
}


- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSLog(@"Previous view controller");
    NSUInteger index = [self indexForViewController:viewController];
    
    if (index == 0 || index == NSNotFound) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSLog(@"Next view controller");
    NSUInteger index = [self indexForViewController:viewController];
    
    if (index >= [vc count] || index == NSNotFound)
    {
        return nil;
    }
    index++;
    
    return [self viewControllerAtIndex:index];
}


- (UIViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if (index > [vc count]) {
        NSLog(@"View nil at index: %i", (int)index);
        return nil;
    }
    
    // Create a new view controller and pass suitable data.
    if (index == 0) {
        NSLog(@"Blank view at index: %i", (int)index);
        BlankViewController *blankView = (BlankViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"BlankViewController"];
        
        return blankView;
    } else if (index == 1) {
    NSLog(@"Nutrition view at index: %i", (int)index);
        NutritionPageContentViewController *nutritionPage = (NutritionPageContentViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"NutrientPageContentController"];
        
        nutritionPage.selectedRecipe = self.selectedRecipe;
        
        return nutritionPage;
    } else {
        return nil;
    }
}

#pragma mark - Page Control

-(NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return [vc count];
}
- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}

- (void)changePage:(UIPageViewControllerNavigationDirection)direction {
    
    NSLog(@"Change page");
    
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
