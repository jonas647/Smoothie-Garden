//
//  PageContentViewController.m
//  Smoothie Garden
//
//  Created by Jonas C Björkell on 2015-09-29.
//  Copyright © 2015 Jonas C Björkell. All rights reserved.
//

#import "PageContentViewController.h"

@interface PageContentViewController ()

@end

@implementation PageContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //Validate the image files for ".png" and make the image view nil if it isn't an image
    if ([self.imageFile hasSuffix:@".png"]) {
        self.ImageView.image = [UIImage imageNamed:self.imageFile];
    } else
        self.ImageView.image = nil;
    
    if ([self.leftImageFile hasSuffix:@".png"]) {
        self.leftImageView.image = [UIImage imageNamed:self.leftImageFile];
    } else
        self.leftImageView.image = nil;
    
    if ([self.rightImageFile hasSuffix:@".png"]) {
        self.rightImageView.image = [UIImage imageNamed:self.rightImageFile];
    } else
        self.rightImageView.image = nil;
    
    if (self.titleText) {
        self.titleLabel.text = self.titleText;
    }
    
    if (self.descriptionText) {
        self.descriptionTextView.text = self.descriptionText;
        
        //Must have the view as selectable in storyboard to get the font working (Apple bug)
        [self.descriptionTextView sizeToFit];
        [self.descriptionTextView layoutIfNeeded];
        self.descriptionTextView.layoutManager.allowsNonContiguousLayout = false;
        self.descriptionTextView.selectable = NO;
        
        [self newFrameForUIView:self.descriptionTextView];
    }
    
    
    
    
}

- (void) viewDidLayoutSubviews {
 
    self.ImageView.layer.cornerRadius = 12.0f;
    self.leftImageView.layer.cornerRadius = 6.0f;
    self.rightImageView.layer.cornerRadius = 6.0f;
    
    self.ImageView.layer.masksToBounds = YES;
    self.leftImageView.layer.masksToBounds = YES;
    self.rightImageView.layer.masksToBounds = YES;

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGRect) newFrameForUIView: (UIView* ) view {
    
    //Change the height of the UIView based on its content
    CGFloat fixedWidth = view.frame.size.width;
    CGSize newSize = [view sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = view.frame;
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
    
    return newFrame;
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
