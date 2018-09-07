//
//  ForgotPsswodVC.m
//  AllCool.pl
//
//  Created by Sanjay on 06/09/17.
//  Copyright © 2017 Sanjay. All rights reserved.
//

#import "ForgotPsswodVC.h"

@interface ForgotPsswodVC ()<UIGestureRecognizerDelegate>
{

    IBOutlet UILabel *lblEnterEmail;
}
@end

@implementation ForgotPsswodVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    lblEnterEmail.layer.shadowColor = BLACK_COLOR.CGColor;
    lblEnterEmail.layer.shadowOffset = CGSizeMake(1, 1);
    lblEnterEmail.layer.shadowOpacity = 10;
    GESTURE_POP

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
