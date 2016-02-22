//
//  InAppPurchaseScreenOneViewController.m
//  Smoothie Box
//
//  Created by Jonas C Björkell on 2016-01-17.
//  Copyright © 2016 Jonas C Björkell. All rights reserved.
//

#import "InAppPurchaseScreenOneViewController.h"

@interface InAppPurchaseScreenOneViewController ()

@end

@implementation InAppPurchaseScreenOneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void) viewDidLayoutSubviews {
    
    self.centerImage.layer.cornerRadius = 12.0f;
    self.leftImage.layer.cornerRadius = 6.0f;
    self.rightImage.layer.cornerRadius = 6.0f;
    
    self.centerImage.layer.masksToBounds = YES;
    self.leftImage.layer.masksToBounds = YES;
    self.rightImage.layer.masksToBounds = YES;
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