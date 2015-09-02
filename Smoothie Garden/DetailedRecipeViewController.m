//
//  DetailedRecipeViewController.m
//  Smoothie Garden
//
//  Created by Jonas C Björkell on 2015-08-09.
//  Copyright (c) 2015 Jonas C Björkell. All rights reserved.
//

#import "DetailedRecipeViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface DetailedRecipeViewController ()

@end

@implementation DetailedRecipeViewController
{
    NSString *recipeName;
    NSArray  *recipeInstructions;
    NSArray *ingredients;
    
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
    
    
    recipeImage.image = [UIImage imageNamed:@"IMG_0408_iphone.png"];
    
    recipeInstructions = [NSArray arrayWithObjects:
                          @"Pressa saften från apelsin och lime",
                          @"Skala ingefära",
                          @"Tillsätt hallon,mango och goji-bär",
                          @"Mixa smoothien till slät konsistens",
                          @"Sprinkla med gojibär på toppen",
                          @"Drick och njut i trädgården",
                          nil];
    
    ingredients = [NSArray arrayWithObjects:
                            @"En apelsin",
                            @"En halv lime",
                            @"2dl hallon",
                            @"1dl mango",
                            @"1 matsked goji-bär",
                            @"1cm ingefära",
                            nil];
                            
    //Adjust the UITextViews to the size of the text to be presented
    ingredientsTableView.frame =     [self newFrameForUIView:ingredientsTableView];
    instructionsTableView.frame =    [self newFrameForUIView:instructionsTableView];
    
    [ingredientsHeightConstraint setConstant:ingredientsTableView.frame.size.height];
    [instructionsHeightConstraint setConstant:instructionsTableView.frame.size.height];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGRect) newFrameForUIView: (UIView* ) view {

    //Change the height of the UITextViews
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

#pragma mark - Table View Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if ([tableView isEqual:ingredientsTableView]) {
        return [ingredients count];
    } else if ([tableView isEqual:instructionsTableView])
    {
        return [recipeInstructions count];
        
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tmpTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier         =   @"MainCell";
    UITableViewCell *cell               =   [tmpTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (nil == cell) {
        cell    =   [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if (indexPath.row % 2) {
        cell.backgroundColor = [UIColor lightGrayColor];
    } else {
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    if ([tmpTableView isEqual:ingredientsTableView]) {
        cell.textLabel.text = [ingredients objectAtIndex:indexPath.row];
    } else if ([tmpTableView isEqual:instructionsTableView])
    {
        cell.textLabel.text = [recipeInstructions objectAtIndex:indexPath.row];
        
    }
    
    
    
    return cell;
}



@end
