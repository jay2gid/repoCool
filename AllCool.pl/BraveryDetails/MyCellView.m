//
//  MyCellView.m
//  AllCool.pl
//
//  Created by Sanjay on 12/11/17.
//  Copyright © 2017 Sanjay. All rights reserved.
//

#import "MyCellView.h"

@implementation MyCellView

// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}

- (IBAction)tapButton:(id)sender {
    
    BotalVC *OBJ = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"BotalVC"];
    OBJ.dictBeer = _infoDict;
    [[AppDelegate delegate].navigationController pushViewController:OBJ animated:YES];
}


@end
