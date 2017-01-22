//
//  RecipeImageViewController.m
//  Smoothie Box
//
//  Created by Jonas C Björkell on 2016-10-11.
//  Copyright © 2016 Jonas C Björkell. All rights reserved.
//

#import "RecipeImageViewController.h"

@interface RecipeImageViewController ()

@end

@implementation RecipeImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Set the image of the selected recipe
    NSString *recipeImageName = _selectedRecipe.imageName;
    _recipeImage.image = [UIImage imageNamed:recipeImageName];
    _recipeImageIpad.image = [UIImage imageNamed:recipeImageName];
    
    
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
