//
//  BtnCell.m
//  AllCool.pl
//
//  Created by Sanjay on 14/11/17.
//  Copyright © 2017 Sanjay. All rights reserved.
//

#import "BtnCell.h"

@implementation BtnCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)tapButton:(UIButton *)sender
{
    if (sender.tag == 1) {
        [Helper callToNumber:[Helper getString:_infoDicBrovary[@"products"][0][@"phone"]]];
    }
    
    if (sender.tag == 2) {
        [Helper openUrl:[Helper getString:_infoDicBrovary[@"products"][0][@"website"]]];
    }
    
    if (sender.tag ==3) {
        
    }
    
    if (sender.tag == 4) {
        
    }
    
    if (sender.tag == 5)
    {
        UIStoryboard *storybord = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        DescripionVC *obj = [storybord instantiateViewControllerWithIdentifier:@"DescripionVC"];
        obj.strDescription = [Helper getString:_infoDicBrovary[@"products"][0][@"description"]];
        [self.selfBack.navigationController pushViewController:obj animated:YES];
    }
}

@end
