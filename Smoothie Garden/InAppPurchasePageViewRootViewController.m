//
//  InAppPurchasePageViewRootViewController.m
//  Smoothie Box
//
//  Created by Jonas C Björkell on 2016-01-17.
//  Copyright © 2016 Jonas C Björkell. All rights reserved.
//

#import "InAppPurchasePageViewRootViewController.h"
#import "AppDelegate.h"
#import "SBIAPHelper.h"
#import "SBActivityIndicatorView.h"

@interface InAppPurchasePageViewRootViewController ()

@end

@implementation InAppPurchasePageViewRootViewController
{
    SBActivityIndicatorView *loadingIndicator;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.viewControllers = [[NSMutableArray alloc]initWithObjects:@"inAppPurchaseScreenOne", @"inAppPurchaseScreenTwo", @"inAppPurchaseScreenThree",nil];
    
    // Create page view controller
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"InAppPageViewController"];
    self.pageViewController.dataSource = self;
    
    // Change the size of page view controller to fit the screen between header view and button
    self.pageViewController.view.frame = CGRectMake(0, CGRectGetMinY(_pageViewSize.frame), self.view.frame.size.width, CGRectGetHeight(_pageViewSize.frame));
    
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    
    UIViewController *startingViewController = [self viewControllerAtIndex:0];
    NSArray *startingVCs = @[startingViewController];
    [self.pageViewController setViewControllers:startingVCs direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    [self.view bringSubviewToFront:self.pageViewController.view];
    
    //Setup the activity indicator for loading IAP
    //[self setupActivityIndicator];
    
    //Register for notifications from the IAPHelper to be able to unlock the recipes after IAP has been purchased
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:IAPHelperProductPurchasedNotification object:nil];
    //Notification to be able to show activity indicator and remove it when the iap has been loaded     
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeLoadingIndicator) name:IAPHelperProductResponseForTransaction object:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - In app purchase
- (IBAction)buyRecipes:(id)sender {
    
    AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    //Right now there's only one available purchase so get the first object in the array
    SKProduct *productToBuy = [delegate.iTunesPurchases objectAtIndex:0];
    
    if (productToBuy) {
        
        [[SBIAPHelper sharedInstance]buyProduct:productToBuy];
        
        //Create loading indicator to show the user that the in app purchase is loading
        loadingIndicator = [[SBActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width/5, self.view.frame.size.width/5)];
        [loadingIndicator setCenter:self.view.center];
        [self.view addSubview:loadingIndicator];
        [self.view bringSubviewToFront:loadingIndicator];
        
        [loadingIndicator startAnimating];
        
    }
    
}

- (void)productPurchased:(NSNotification *)notification {
    
    NSString * productIdentifier = notification.object;
    
    //Use the archiving object singleton to store the unlocked IAP
    [[SBIAPHelper sharedInstance] unlockIAP:productIdentifier];
    
    //Remove the loading indicator
    [loadingIndicator stopAnimating];
    
    //Update analytics of the purchase
    //TODO
    // Where should I get the SKProduct?
    
}

- (void)removeLoadingIndicator {
    
    [loadingIndicator stopAnimating];
    
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
