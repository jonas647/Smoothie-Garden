//
//  NutritionViewController.m
//  Smoothie Box
//
//  Created by Jonas C Björkell on 2015-12-21.
//  Copyright © 2015 Jonas C Björkell. All rights reserved.
//

#import "NutritionViewController.h"

@interface NutritionViewController ()

@end

@implementation NutritionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CGFloat w = self.view.frame.size.width;
    CGFloat h = self.view.frame.size.height;
    /*
    // Set up the page control
    CGRect frame = CGRectMake(0, h - 60, w, 60);
    self.pageControl = [[UIPageControl alloc]
                        initWithFrame:frame
                        ];
    
    // Add a target that will be invoked when the page control is
    // changed by tapping on it
    [self.pageControl
     addTarget:self
     action:@selector(pageControlChanged:)
     forControlEvents:UIControlEventValueChanged
     ];
    */
    
    // Set the number of pages to the number of pages in the paged interface
    // and let the height flex so that it sits nicely in its frame
    //self.pageControl.numberOfPages = PAGES;
    //self.pageControl.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    
    //[self.view addSubview:self.pageControl];
    
}

- (void)pageControlChanged:(id)sender
{
    UIPageControl *pageControl = sender;
    CGFloat pageWidth = self.collectionView.frame.size.width;
    CGPoint scrollTo = CGPointMake(pageWidth * pageControl.currentPage, 0);
    [self.collectionView setContentOffset:scrollTo animated:YES];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageWidth = self.collectionView.frame.size.width;
    self.pageControl.currentPage = self.collectionView.contentOffset.x / pageWidth;
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    //#warning Incomplete implementation, return the number of sections
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    // Configure the cell
    
    static NSString *identifier = @"NutritionCell";
    
    UICollectionViewCell *newCell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    UILabel *nutritionTitleLabel = (UILabel*)[newCell viewWithTag:101];
    UILabel *nutritionVolumeLabel = (UILabel*)[newCell viewWithTag:102];
    
    nutritionTitleLabel.text = @"Zink, Zn";
    nutritionVolumeLabel.text = @"200mg";
    
    /*
    NSDictionary *nutrientToDisplay = (NSDictionary*)[self.nutrientCatalog objectAtIndex:indexPath.row];
    
    nutritionTitleLabel.text = [self nutrientTitleFromDictionary:nutrientToDisplay];
    nutritionVolumeLabel.text = [self nutrientVolumeFromDictionary:nutrientToDisplay];
    */
    return newCell;
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
