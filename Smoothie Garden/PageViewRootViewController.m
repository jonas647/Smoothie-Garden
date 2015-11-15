//
//  PageViewRootViewController.m
//  Smoothie Garden
//
//  Created by Jonas C Björkell on 2015-09-29.
//  Copyright © 2015 Jonas C Björkell. All rights reserved.
//

#import "PageViewRootViewController.h"
#import <StoreKit/StoreKit.h>
#import "SBIAPHelper.h"
#import "AppDelegate.h"
#import "ArchivingObject.h"
#import "SBActivityIndicatorView.h"

@interface PageViewRootViewController ()

@end

@implementation PageViewRootViewController
{
    SBActivityIndicatorView *loadingIndicator;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString *defaultTitleText = @"This is what you get!";
    
    _pageTitles = @[defaultTitleText,defaultTitleText,defaultTitleText,defaultTitleText];
    _pageTexts = @[@"Over 20 healthy, vegan, lactos-free Smoothie Recipes,", @"Create your own recipe book with your favorite recipes for easy access", @"Free regular updates with new recipes", @"Start a healthy lifestyle now!"];
    _pageImages = @[@"Sweet Cherry Pie.png", @"page2.png", @"page3.png", @"page4.png"];
    _leftPageImages =@[@"Passion for Chia.png", @"",@"",@""];
    _rightPageImages = @[@"Green Coco Kale.png",@"",@"",@""];
    
    
    // Create page view controller
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    self.pageViewController.dataSource = self;
    
    PageContentViewController *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    // Change the size of page view controller
    // Set the Y start position somewhat lower since the navigation bar is on screen
    self.pageViewController.view.frame = CGRectMake(0, self.view.frame.size.height*0.15, self.view.frame.size.width, self.view.frame.size.height - self.view.frame.size.height*0.35);
    
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    
    //Hide the tab bar
    //TODO
    
    //Move to next page after x number of seconds
    //TODO
    
    //Register for notifications from the IAPHelper to be able to unlock the recipes after IAP has been purchased
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:IAPHelperProductPurchasedNotification object:nil];
    //Notification to be able to show activity indicator and remove it when the iap has been loaded
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:IAPHelperProductTransactionNotification object:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((PageContentViewController*) viewController).pageIndex;
    if ((index == 0) || (index == NSNotFound))
    {
        return nil;
    }
    index--;
    return [self viewControllerAtIndex:index];
}
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((PageContentViewController*) viewController).pageIndex;
    if (index == NSNotFound)
    {
        return nil;
    }
    index++;
    if (index == [self.pageTitles count])
    {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

- (PageContentViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if (([self.pageTitles count] == 0) || (index >= [self.pageTitles count])) {
        return nil;
    }
    // Create a new view controller and pass suitable data.
    PageContentViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageContentViewController"];
    if (self.pageTitles[index]) {
        pageContentViewController.titleText = self.pageTitles[index];
    }
    if (self.pageImages[index]) {
        pageContentViewController.imageFile = self.pageImages[index];
    }
    if (self.leftPageImages[index]) {
        pageContentViewController.leftImageFile = self.leftPageImages[index];
    }
    if (self.rightPageImages[index]) {
        pageContentViewController.rightImageFile = self.rightPageImages[index];
    }
    if (self.pageTexts[index]) {
        pageContentViewController.descriptionText = self.pageTexts[index];
    }
    NSLog(@"Page content setup");
    pageContentViewController.pageIndex = index;
    return pageContentViewController;
}

- (IBAction)buyRecipes:(id)sender {
    
    AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    //Right now there's only one available purchase so get the first object in the array
    SKProduct *productToBuy = [delegate.iTunesPurchases objectAtIndex:0];
    
    if (productToBuy) {
        NSLog(@"Buy product");
        [[SBIAPHelper sharedInstance]buyProduct:productToBuy];
    
        //Create loading indicator to show the user that the in app purchase is loading
        loadingIndicator = [[SBActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width/5, self.view.frame.size.width/5)];
        [loadingIndicator setCenter:self.view.center];
        [self.view addSubview:loadingIndicator];
        [self.view bringSubviewToFront:loadingIndicator];
    
    } else {
            NSLog(@"Product not loaded");
            
        }
    
}

- (void)productPurchased:(NSNotification *)notification {

    NSString * productIdentifier = notification.object;
    
    //Use the archiving object singleton to store the unlocked IAP
    ArchivingObject *archiver = [ArchivingObject sharedInstance];
    [archiver unlockIAP:productIdentifier];
    
    //Remove the loading indicator
    [loadingIndicator stopAnimating];
}

-(NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return [self.pageTitles count];
}
- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}

- (void)changePage:(UIPageViewControllerNavigationDirection)direction {
    NSUInteger pageIndex = ((PageContentViewController *) [_pageViewController.viewControllers objectAtIndex:0]).pageIndex;
    
    if (direction == UIPageViewControllerNavigationDirectionForward) {
        pageIndex++;
    }
    else {
        pageIndex--;
    }
    
    PageContentViewController *viewController = [self viewControllerAtIndex:pageIndex];
    
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
