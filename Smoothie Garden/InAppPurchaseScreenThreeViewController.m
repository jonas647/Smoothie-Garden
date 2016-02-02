//
//  InAppPurchaseScreenThreeViewController.m
//  Smoothie Box
//
//  Created by Jonas C Björkell on 2016-01-30.
//  Copyright © 2016 Jonas C Björkell. All rights reserved.
//

#import "InAppPurchaseScreenThreeViewController.h"

@interface InAppPurchaseScreenThreeViewController ()

@end

@implementation InAppPurchaseScreenThreeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void) viewDidLayoutSubviews {
    
    self.fakeTableView.layer.cornerRadius = 6.0f;
    self.fakeTableView.layer.masksToBounds = YES;
    self.fakeTableView.layer.borderWidth = 1.0f;
    self.fakeTableView.layer.borderColor = [[UIColor lightGrayColor]CGColor];
    
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
