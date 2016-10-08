//
//  RecipeListViewController.h
//  Smoothie Box
//
//  Created by Jonas C Björkell on 2016-10-08.
//  Copyright © 2016 Jonas C Björkell. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecipeListViewController : UIViewController <UISearchBarDelegate, UISearchResultsUpdating, UISearchControllerDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *recipeCollectionView;
@property (weak, nonatomic) IBOutlet UIView *searchbarBackground;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sideBarButton;


@property (strong, nonatomic) UISearchController *searchController;

@end
