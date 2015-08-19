//
//  DetailedRecipeViewController.m
//  Smoothie Garden
//
//  Created by Jonas C Björkell on 2015-08-09.
//  Copyright (c) 2015 Jonas C Björkell. All rights reserved.
//

#import "DetailedRecipeViewController.h"

@interface DetailedRecipeViewController ()

@end

@implementation DetailedRecipeViewController
{
    NSString *recipeName;
    NSString *recipeInstructions;
    
}

- (void) awakeFromNib {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    
    //Get the size (primarily the height) by checking the size of the content view that holds all the subviews
    scrollView.contentSize=CGSizeMake(contentView.frame.size.width,contentView.frame.size.height);
    
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    
    instructionsText.backgroundColor = [UIColor greenColor];
    
    NSLog(@"Size for instructions: %f", instructionsText.frame.size.height);
    
    recipeImage.image = [UIImage imageNamed:@"IMG_0408_iphone.png"];
    instructionsText.text = @"TEST TEST TEST TEST TEST TESTTEST TEST TESTTEST TEST TESTTEST TEST TESTTEST TEST TESTTEST TEST TESTTEST TEST TESTTEST TEST TESTTEST TEST TESTTEST TEST TESTTEST TEST TESTTEST TEST TESTTEST TEST TESTTEST TEST TESTTEST TEST TESTTEST TEST TESTTEST TEST TESTTEST TEST TESTTEST TEST TESTTEST TEST TESTTEST TEST TESTTEST TEST TESTTEST TEST TESTTEST TEST TESTTEST TEST TESTTEST TEST TESTTEST TEST TESTTEST TEST TESTTEST TEST TESTTEST TEST TESTTEST TEST TESTTEST TEST TESTTEST TEST TESTTEST TEST TESTTEST TEST TESTTESTTEST TEST TESTTEST TEST TESTTEST TEST TESTTEST TEST TESTTEST TEST TESTTESTTEST TEST TESTTEST TEST TESTTEST TEST TESTTEST TEST TESTTEST TEST TESTTESTTEST TEST TESTTEST TEST TESTTEST TEST TESTTEST TEST TESTTEST TEST TEST. Slut";
    
    //Adjust the UITextViews to the size of the text to be presented
    ingredientsText.frame =     [self newFrameForUITextView:ingredientsText];
    instructionsText.frame =    [self newFrameForUITextView:instructionsText];
    
    [ingredientsHeightConstraint setConstant:ingredientsText.frame.size.height];
    [instructionsHeightConstraint setConstant:instructionsText.frame.size.height];
    //[instructionsHeightConstraint setConstant:400];
    
    NSLog(@"Size for instructions: %f", instructionsText.frame.size.height);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGRect) newFrameForUITextView: (UITextView* ) textView {

    //Change the height of the UITextViews
    CGFloat fixedWidth = textView.frame.size.width;
    CGSize newSize = [textView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = textView.frame;
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
