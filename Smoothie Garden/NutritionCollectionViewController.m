//
//  NutritionCollectionViewController.m
//  Smoothie Box
//
//  Created by Jonas C Björkell on 2015-12-20.
//  Copyright © 2015 Jonas C Björkell. All rights reserved.
//

#import "NutritionCollectionViewController.h"

@interface NutritionCollectionViewController ()

@end

@implementation NutritionCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
    //UIEdgeInsets sectionInsets = UIEdgeInsetsMake(50.0, 20.0, 50.0, 20.0);
    
    //TODO
    //Get all the nutrient dictionaries summarized for all the ingredients in the recipe
    
    NSLog(@"Nutrition collection view init");
    
    //self.nutrientCatalog = [self.selectedRecipe];
   
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

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
//#warning Incomplete implementation, return the number of sections
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return self.nutrientCatalog.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    
    static NSString *identifier = @"NutritionCell";
    
    UICollectionViewCell *newCell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    UILabel *nutritionTitleLabel = (UILabel*)[cell viewWithTag:101];
    UILabel *nutritionVolumeLabel = (UILabel*)[cell viewWithTag:102];
    
    NSDictionary *nutrientToDisplay = (NSDictionary*)[self.nutrientCatalog objectAtIndex:indexPath.row];
    
    nutritionTitleLabel.text = [self nutrientTitleFromDictionary:nutrientToDisplay];
    nutritionVolumeLabel.text = [self nutrientVolumeFromDictionary:nutrientToDisplay];
    
    return newCell;
}

- (NSString*) nutrientTitleFromDictionary: (NSDictionary*) dic {
    
    return [NSString stringWithFormat:@"%@", dic];
}

- (NSString*) nutrientVolumeFromDictionary: (NSDictionary*) dic {
 
    //Return the nutrient volume including the unit. For example "200mg"
    if ([dic objectForKey:@"Measure"]) {
        
        NSString *measure = [dic objectForKey:@"Measure"];
        
        if ([dic objectForKey:@"Unit"]) {
            
            measure = [NSString stringWithFormat:@"%@%@", measure, [dic objectForKey:@"Unit"]];
            
        } else {
            NSLog(@"No unit for %@", dic);
        }
        
        return measure;
    } else {
        NSLog(@"No measure for %@", dic);
        
        return nil;
    }
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
