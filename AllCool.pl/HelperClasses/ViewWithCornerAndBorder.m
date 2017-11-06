//
//  ViewWithCornerAndBorder.m
//  AllCool.pl
//
//  Created by Sanjay on 06/09/17.
//  Copyright © 2017 Sanjay. All rights reserved.
//

#import "ViewWithCornerAndBorder.h"

@implementation ViewWithCornerAndBorder

- (void)drawRect:(CGRect)rect {

    self.clipsToBounds = YES;
    self.layer.cornerRadius = 3;
    
    self.layer.borderWidth = 0.8;
    self.layer.borderColor = APP_COLOR_RED.CGColor;
}

@end
