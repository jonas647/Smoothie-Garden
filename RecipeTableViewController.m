//
//  RecipeTableViewController.m
//  Smoothie Garden
//
//  Created by Jonas C Björkell on 2015-08-06.
//  Copyright (c) 2015 Jonas C Björkell. All rights reserved.
//

#import "RecipeTableViewController.h"
#import "Recipe.h"

#define CELL_HEIGHT 276

@interface RecipeTableViewController ()

@end

@implementation RecipeTableViewController
{
    NSArray *recipes;
    Recipe *selectedRecipe;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    recipes = [NSArray arrayWithObjects:@"Smoothie Masala",@"Green Garden Smoothie",@"Singapore Smoothie", nil];
    
    //self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = [UIColor lightGrayColor];
    
    self.title = @"Garden Smoothie";

    [self.navigationController.navigationBar setBackgroundImage:
     [UIImage imageNamed:@"wood.jpg"]forBarMetrics:UIBarMetricsDefault];
    
    
    self.tableView.sectionHeaderHeight = 0.0;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
    //self.navigationController.hidesBarsOnSwipe = true;
    
    
}

- (void) loadCustomRecipes {
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [recipes count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *tableCellIdentifier = @"RecipeTableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableCellIdentifier];
    
    
    // Configure the cell...
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableCellIdentifier];
    }
    
    int random = arc4random_uniform(2);
    
    UIImageView *imv = [[UIImageView alloc]initWithFrame:CGRectMake(0,0, 360,CELL_HEIGHT)];
    
    if (random == 0) {
        imv.image=[UIImage imageNamed:@"IMG_0430_iphone.png"];
    } else {
        imv.image=[UIImage imageNamed:@"IMG_0408_iphone.png"];
    }
    
    //imv.image=[UIImage imageNamed:@"IMG_1412_iphone.JPG"];
    
    //Change size of cell so that the image fills the entire screen
    //First change size of cell so that it fills entire width
    [cell setFrame:CGRectMake(cell.frame.origin.x, cell.frame.origin.y, self.view.frame.size.width, cell.frame.size.height)];
    //Then change size of the image to the width of the cell
    [imv setFrame:CGRectMake(imv.frame.origin.x, imv.frame.origin.y, cell.frame.size.width, imv.frame.size.height)];
    
    [cell.contentView addSubview:imv];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(25, CELL_HEIGHT - 30, 360, 30)];
    label.text = [recipes objectAtIndex:indexPath.row];
    label.textColor = [UIColor whiteColor];
    [cell.contentView addSubview:label];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedRecipe = [recipes objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"DetailedRecipeSegue" sender:self];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return CELL_HEIGHT;
    
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
 
    UIViewController *vcToPushTo = segue.destinationViewController;
    //vcToPushTo. = selectedRecipe;
}


@end
