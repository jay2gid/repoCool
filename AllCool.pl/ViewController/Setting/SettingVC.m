//
//  SettingVC.m
//  AllCool.pl
//
//  Created by Sanjay on 09/09/17.
//  Copyright © 2017 Sanjay. All rights reserved.
//

#import "SettingVC.h"

@interface SettingVC ()

@end

@implementation SettingVC

- (void)viewDidLoad {
    [super viewDidLoad];

    GET_HEADER_VIEW
    header.title.text = @"Ustawienia";

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
