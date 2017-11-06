//
//  RadarVC.m
//  AllCool.pl
//
//  Created by Sanjay on 16/09/17.
//  Copyright © 2017 Sanjay. All rights reserved.
//

#import "RadarVC.h"

@interface RadarVC ()

@end

@implementation RadarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    GET_HEADER_VIEW
    header.title.text = @"Radar";
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
