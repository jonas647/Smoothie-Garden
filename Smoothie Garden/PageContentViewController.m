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
    
    self.ImageView.image = [UIImage imageNamed:self.imageFile];
    self.titleLabel.text = self.titleText;
    self.descriptionTextView.text = self.descriptionText;
    
    //Must have the view as selectable in storyboard to get the font working (Apple bug)
    [self.descriptionTextView sizeToFit];
    [self.descriptionTextView layoutIfNeeded];
    self.descriptionTextView.layoutManager.allowsNonContiguousLayout = false;
    self.descriptionTextView.selectable = NO;
    
    [self newFrameForUIView:self.descriptionTextView];
    
    
    
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
