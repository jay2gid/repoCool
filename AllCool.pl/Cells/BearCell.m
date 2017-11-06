//
//  BearCell.m
//  AllCool.pl
//
//  Created by Sanjay on 07/09/17.
//  Copyright © 2017 Sanjay. All rights reserved.
//

#import "BearCell.h"

@implementation BearCell
{
    IBOutlet UIView *viewMid;
}

@synthesize btnDaduj,btnKasuj,btnNottaki;

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    btnDaduj.layer.cornerRadius = 13;
    btnDaduj.layer.borderWidth = 1;
    btnDaduj.layer.borderColor = btnDaduj.titleLabel.textColor.CGColor;

    btnKasuj.layer.cornerRadius = 13;
    btnKasuj.layer.borderWidth = 1;
    btnKasuj.layer.borderColor = btnKasuj.titleLabel.textColor.CGColor;
    
    btnNottaki.layer.cornerRadius = 13;
    btnNottaki.layer.borderWidth = 1;
    btnNottaki.layer.borderColor = btnNottaki.titleLabel.textColor.CGColor;
    
    viewMid.layer.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5].CGColor;
    viewMid.layer.shadowOffset = CGSizeMake(0.5, 0.5);
    viewMid.layer.shadowOpacity = 5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
