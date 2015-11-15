//
//  ReachabilityHelper.h
//  Scuba Kid
//
//  Created by Jonas C Björkell on 2014-11-08.
//  Copyright (c) 2014 Jonas C Björkell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

@interface ReachabilityHelper : NSObject

//Internet connectivity
@property (nonatomic, strong) Reachability *internetReachableFoo;

- (BOOL)connectedToInternet;

@end
