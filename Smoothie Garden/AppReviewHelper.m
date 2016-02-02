//
//  AppReviewHelper.m
//  Smoothie Box
//
//  Created by Jonas C Björkell on 2015-11-29.
//  Copyright © 2015 Jonas C Björkell. All rights reserved.
//

#import "AppReviewHelper.h"

#define HAS_REVIEW_BEEN_GIVEN @"hasReviewBeenGiven"
#define Treshold_for_showing_review 8 //Change this to change how frequent the app review alert should be shown

@implementation AppReviewHelper

+ (BOOL) shouldShowReviewAlert {
    
    //Add one more view of recipes
    [self addOneTimeShowForRecipes];
    
    //Check in the NSUserDefaults if review has been given
    if (![self hasReviewBeenGiven]) {
        //If no review has been given, run furthuer validation to see if alert should be shown
        
        //Check how many times the recipe has been shown and run modulus operator to see if it is at the treshold for showing alert
        int modulusOperation = [self numberOfTimesRecipesShown] % [self tresholdForShowingAlert];
        
        if ([self numberOfTimesRecipesShown]>0 && modulusOperation == 0) {
            return YES;
        } else {
            return NO;
        }
    } else {
        return NO;
    }
    
}

+ (int) numberOfTimesRecipesShown {
    
    return (int)[[NSUserDefaults standardUserDefaults] integerForKey:[NSString stringWithFormat:@"recipeShown_numberOfTimes"]];
    
}

+ (void) addOneTimeShowForRecipes {
    
    //No difference based on what recipe that is shown. Just count how many times a recipe has been opened. But this function can be changed later to be recipe dependent
    
    int numberOfTimesShown = [self numberOfTimesRecipesShown] + 1;
    
    [[NSUserDefaults standardUserDefaults]setInteger:numberOfTimesShown forKey:[NSString stringWithFormat:@"recipeShown_numberOfTimes"]];
    
}

+ (int) tresholdForShowingAlert {
    //Alert should be shown every time for this number of shown per recipe
    return Treshold_for_showing_review;
}

+ (BOOL) hasReviewBeenGiven {
    
    //TODO
    //Should validate if the key exists
    return [[NSUserDefaults standardUserDefaults] boolForKey:HAS_REVIEW_BEEN_GIVEN];
}

+ (void) dontShowAnyMoreReviewAlerts {
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:HAS_REVIEW_BEEN_GIVEN];
}

+ (void) firstTimeAppLaunch {
    
    //During first launch the has review should be set to NO since no review has been given.
    
    //If the key already exist, then don't do anything
    
    if(![[[[NSUserDefaults standardUserDefaults] dictionaryRepresentation] allKeys] containsObject:HAS_REVIEW_BEEN_GIVEN]){
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:HAS_REVIEW_BEEN_GIVEN];
    }
        
    
}

@end
