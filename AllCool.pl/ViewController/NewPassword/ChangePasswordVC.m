//
//  ChangePasswordVC.m
//  AllCool.pl
//
//  Created by Sanjay on 16/09/17.
//  Copyright © 2017 Sanjay. All rights reserved.
//

#import "ChangePasswordVC.h"

@interface ChangePasswordVC ()

@end

@implementation ChangePasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    GET_HEADER_VIEW_WITH_BACK
    header.title.text = @"Zmien hasto";

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
