
//
//  FirstPubCell.m
//  AllCool.pl
//
//  Created by Sanjay on 26/11/17.
//  Copyright © 2017 Sanjay. All rights reserved.
//

#import "FirstPubCell.h"
#import "PubDesVC.h"

@implementation FirstPubCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)tapBtnCall:(id)sender {
    
    NSString *phoneNumber = [@"tel://" stringByAppendingString:_lblPhoneNo.text];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
}

- (IBAction)tapOnDec:(id)sender {
    
    PubDesVC *obj = [[PubDesVC alloc]initWithNibName:@"PubDesVC" bundle:nil];
    obj.infoPub = _infoPub;
    [self.selfBack.navigationController pushViewController:obj animated:YES];
}

@end
