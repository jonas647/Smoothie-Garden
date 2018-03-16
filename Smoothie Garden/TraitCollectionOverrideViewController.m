//
//  TraitCollectionOverrideViewController.m
//  Smoothie Box
//
//  Created by Jonas C Björkell on 2016-10-29.
//  Copyright © 2016 Jonas C Björkell. All rights reserved.
//

#import "TraitCollectionOverrideViewController.h"
#import "DetailedRecipeViewController.h"
#import "DeviceHelper.h"

@interface TraitCollectionOverrideViewController ()

@end

@implementation TraitCollectionOverrideViewController {
    
    DetailedRecipeViewController *recipeController;
    UIButton *rightButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpReferenceSizeClasses];

    //TODO
    //Not working after xcode upgrade to make the navigation bar transparent, need to analyze why
    //For now disable the like button as it doesn't look good when it's in the non-transparent navigation bar
    
    //Add like button as right bar button in the navigation bar
    /*
    UIButton *customButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    
     UIImage *buttonImage = [UIImage imageNamed:@"Heart Outline"];
     UIImage *selectedButtonImage = [UIImage imageNamed:@"Heart Filled"];
     [customButton setBackgroundImage:buttonImage  forState:UIControlStateNormal];
     [customButton setBackgroundImage:selectedButtonImage  forState:UIControlStateSelected];
     [customButton addTarget:self action:@selector(rightButtonSelected) forControlEvents:UIControlEventTouchUpInside];
     
     UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView: customButton];
     
    self.navigationItem.rightBarButtonItem = barButtonItem;
    rightButton = customButton;
    
    
    //Hide the navigation bar but show the buttons
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
 
     */
    
    //Check if recipe is liked and if so show the right bar button as liked
    if ([recipeController isRecipeLiked]) {
        [rightButton setSelected:YES];
    }
}

- (void)setUpReferenceSizeClasses {
    UITraitCollection *traitCollection_hCompact = [UITraitCollection traitCollectionWithHorizontalSizeClass:UIUserInterfaceSizeClassRegular];
    UITraitCollection *traitCollection_vRegular = [UITraitCollection traitCollectionWithVerticalSizeClass:UIUserInterfaceSizeClassCompact];
    _traitCollection_CompactRegular = [UITraitCollection traitCollectionWithTraitsFromCollections:@[traitCollection_hCompact, traitCollection_vRegular]];
    
    UITraitCollection *traitCollection_hAny = [UITraitCollection traitCollectionWithHorizontalSizeClass:UIUserInterfaceSizeClassUnspecified];
    UITraitCollection *traitCollection_vAny = [UITraitCollection traitCollectionWithVerticalSizeClass:UIUserInterfaceSizeClassUnspecified];
    _traitCollection_AnyAny = [UITraitCollection traitCollectionWithTraitsFromCollections:@[traitCollection_hAny, traitCollection_vAny]];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    _willTransitionToPortrait = self.view.frame.size.height > self.view.frame.size.width;
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    _willTransitionToPortrait = size.height > size.width;
}

-(UITraitCollection *)overrideTraitCollectionForChildViewController:(UIViewController *)childViewController {
    
    [super overrideTraitCollectionForChildViewController:childViewController];
    
    if ([[DeviceHelper sharedInstance]isDeviceIpad] && !_willTransitionToPortrait) {
   
        return _traitCollection_CompactRegular;
    } else {
   
        return _traitCollection_AnyAny;
    }
    
}

- (void) rightButtonSelected {
    
    if (recipeController) {
        [rightButton setSelected:![recipeController isRecipeLiked]];
        [recipeController likeRecipe];
        
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    //Set the recipe to show nutrients for in the nutrition view controller
    //Also sets the recipe image
    NSString * segueName = segue.identifier;
    if ([segueName isEqualToString: @"detailedRecipe"]) {
        DetailedRecipeViewController *newVC = (DetailedRecipeViewController*)[segue destinationViewController];
        newVC.selectedRecipe = self.selectedRecipe;
        
        recipeController = newVC;
        
    }
    
}

@end
