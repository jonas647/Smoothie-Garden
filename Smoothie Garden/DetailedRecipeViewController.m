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
    NSArray  *recipeInstructions;
    
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
    
    instructionsTableView.backgroundColor = [UIColor greenColor];
    
    recipeImage.image = [UIImage imageNamed:@"IMG_0408_iphone.png"];
    
    recipeInstructions = [NSArray arrayWithObjects:
                          @"Pressa saften från apelsin och lime",
                          @"Skala ingefära",
                          @"Tillsätt hallon,mango och goji-bär",
                          @"Mixa smoothien till slät konsistens",
                          @"Sprinkla med gojibär på toppen",
                          @"Drick och njut i trädgården",
                          nil];
    
    ingredientsText.text = @"En apelsin, En halv lime, 2dl hallon, 1 dl mango, 1 matsked goji-bär, 1cm ingefära";
    
    //Adjust the UITextViews to the size of the text to be presented
    ingredientsText.frame =     [self newFrameForUIView:ingredientsText];
    instructionsTableView.frame =    [self newFrameForUIView:instructionsTableView];
    
    [ingredientsHeightConstraint setConstant:ingredientsText.frame.size.height];
    [instructionsHeightConstraint setConstant:instructionsTableView.frame.size.height];
    
    //[instructionsHeightConstraint setConstant:400];
    
    
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
    return [recipeInstructions count];
}

- (UITableViewCell *)tableView:(UITableView *)tmpTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier         =   @"MainCell";
    UITableViewCell *cell               =   [tmpTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (nil == cell) {
        cell    =   [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [recipeInstructions objectAtIndex:indexPath.row];
    
    
    if (indexPath.row % 2) {
        cell.backgroundColor = [UIColor lightGrayColor];
    } else {
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    
    return cell;
}



@end
