//
//  SmoothieTabBarViewController.m
//  Smoothie Garden
//
//  Created by Jonas C Björkell on 2015-08-30.
//  Copyright (c) 2015 Jonas C Björkell. All rights reserved.
//

#import "SmoothieTabBarViewController.h"

@interface SmoothieTabBarViewController ()

@end

@implementation SmoothieTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) showPopupViewController:(NSString *)viewControllerName {
    
    //UIViewController *tempViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:viewControllerName];
    
    UIView *blank = [[UIView alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
    blank.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:blank];
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
