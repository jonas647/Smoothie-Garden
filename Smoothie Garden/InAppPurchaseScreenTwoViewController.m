//
//  InAppPurchaseScreenTwoViewController.m
//  Smoothie Box
//
//  Created by Jonas C Björkell on 2016-01-30.
//  Copyright © 2016 Jonas C Björkell. All rights reserved.
//

#import "InAppPurchaseScreenTwoViewController.h"

@interface InAppPurchaseScreenTwoViewController ()

@end

@implementation InAppPurchaseScreenTwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void) viewDidLayoutSubviews {
    
    self.centerImage.layer.cornerRadius = 12.0f;
    self.centerImage.layer.masksToBounds = YES;
    
    //Add border to the nutrient views
    float borderWidth = 2.0f;
    CGColorRef borderColor = [UIColor whiteColor].CGColor;
    
    _caloriesView.layer.borderWidth = borderWidth;
    _caloriesView.layer.borderColor = borderColor;
    
    _carbsView.layer.borderWidth = borderWidth;
    _carbsView.layer.borderColor = borderColor;
    
    _proteinView.layer.borderWidth = borderWidth;
    _proteinView.layer.borderColor = borderColor;
    
    _fatView.layer.borderWidth = borderWidth;
    _fatView.layer.borderColor = borderColor;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
