//
//  RecipeTableViewController.h
//  Smoothie Garden
//
//  Created by Jonas C Björkell on 2015-08-06.
//  Copyright (c) 2015 Jonas C Björkell. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecipeTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating, UIScrollViewDelegate>


@property (weak, nonatomic) IBOutlet UIBarButtonItem *sideBarButton;
@property (strong, nonatomic) UISearchController *searchController;
@property (strong, nonatomic) NSArray *recipes;

@end
