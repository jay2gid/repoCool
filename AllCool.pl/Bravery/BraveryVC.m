//
//  BraveryVC.m
//  AllCool.pl
//
//  Created by Sanjay on 22/10/17.
//  Copyright © 2017 Sanjay. All rights reserved.
//

#import "BraveryVC.h"

@interface BraveryVC ()
{
    IBOutlet NSLayoutConstraint *lineX;
}
@end

@implementation BraveryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tapSegmanets:(UIButton *)sender {

    lineX.constant = WIDTH/3 * sender.tag;
}


@end
