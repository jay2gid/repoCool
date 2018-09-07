//
//  ViewBearRadar.m
//  AllCool.pl
//
//  Created by Sanjay on 13/02/18.
//  Copyright © 2018 Sanjay. All rights reserved.
//

#import "ViewBearRadar.h"

@implementation ViewBearRadar

- (void)drawRect:(CGRect)rect {
    self.layer.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5].CGColor;
    self.layer.shadowOffset = CGSizeMake(0.5, 0.5);
    self.layer.shadowOpacity = 5;
    
    _checkBox.animationDuration = 0.2;
    _checkBox.boxType = BEMBoxTypeSquare;
    
}

@end
