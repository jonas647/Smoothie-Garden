//
//  PageContentViewController.h
//  Smoothie Garden
//
//  Created by Jonas C Björkell on 2015-09-29.
//  Copyright © 2015 Jonas C Björkell. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PageContentViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UIImageView *ImageView;
@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;
@property (weak, nonatomic) IBOutlet UIImageView *rightImageView;


@property NSUInteger pageIndex;
@property NSString *titleText;
@property NSString *descriptionText;
@property NSString *imageFile;
@property NSString *leftImageFile;
@property NSString *rightImageFile;




@end
