//
//  SBActivityIndicatorView.m
//  Smoothie Box
//
//  Created by Jonas C Björkell on 2015-11-15.
//  Copyright © 2015 Jonas C Björkell. All rights reserved.
//

#import "SBActivityIndicatorView.h"

@implementation SBActivityIndicatorView

-(id) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
        self.hidden = NO;
        
        self.layer.cornerRadius = 8.0;
        self.layer.borderWidth = 0.2;
        self.layer.borderColor = [UIColor grayColor].CGColor;
        [self setBackgroundColor:[UIColor whiteColor]];
    }
    return(self);
}

- (void) startActivityIndicator {
    
    [self startAnimating];
    
}

- (void) stopActivityIndicator {
    
    [self stopAnimating];
    [self setHidesWhenStopped:YES];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
