//
//  MyTextField.m
//  AllCool.pl
//
//  Created by Sanjay on 07/09/17.
//  Copyright © 2017 Sanjay. All rights reserved.
//

#import "MyTextField.h"

@implementation MyTextField

- (void)drawRect:(CGRect)rect {

    self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder attributes:@{NSForegroundColorAttributeName:APP_COLOR_RED}];

}


@end
