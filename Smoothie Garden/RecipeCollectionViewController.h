//
//  RecipeCollectionViewController.h
//  Smoothie Box
//
//  Created by Jonas C Björkell on 2016-06-04.
//  Copyright © 2016 Jonas C Björkell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecipeManager.h"

@interface RecipeCollectionViewController : UICollectionViewController <UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sideBarButton;
@property (strong, nonatomic) UISearchController *searchController;


@end
