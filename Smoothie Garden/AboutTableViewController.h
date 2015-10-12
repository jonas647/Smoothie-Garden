//
//  AboutTableViewController.h
//  Smoothie Garden
//
//  Created by Jonas C Björkell on 2015-10-12.
//  Copyright © 2015 Jonas C Björkell. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutTableViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet UITableViewCell *instagramCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *facebookLikeCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *facebookPageCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *emailCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *reviewCell;

@end
