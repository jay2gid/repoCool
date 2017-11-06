//
//  BraveryCell.m
//  AllCool.pl
//
//  Created by Sanjay on 07/09/17.
//  Copyright © 2017 Sanjay. All rights reserved.
//

#import "BraveryCell.h"

@implementation BraveryCell
@synthesize btnDaduj,btnKasuj,btnNottaki;
- (void)awakeFromNib {
    [super awakeFromNib];
    
    btnDaduj.layer.cornerRadius = 13;
    btnDaduj.layer.borderWidth = 1;
    btnDaduj.layer.borderColor = btnDaduj.titleLabel.textColor.CGColor;
    
    btnKasuj.layer.cornerRadius = 13;
    btnKasuj.layer.borderWidth = 1;
    btnKasuj.layer.borderColor = btnDaduj.titleLabel.textColor.CGColor;
    
    btnNottaki.layer.cornerRadius = 13;
    btnNottaki.layer.borderWidth = 1;
    btnNottaki.layer.borderColor = btnDaduj.titleLabel.textColor.CGColor;
    
    _imageBravery.clipsToBounds = YES;
    _imageBravery.layer.cornerRadius = 36;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
