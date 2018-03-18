//
//  DescripionVC.m
//  AllCool.pl
//
//  Created by Pramod Kumar Sharma on 17/11/17.
//  Copyright © 2017 Sanjay. All rights reserved.
//

#import "DescripionVC.h"

@interface DescripionVC ()

@end

@implementation DescripionVC

@synthesize strTitle, strDescription;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    GET_HEADER_VIEW_WITH_BACK
    header.title.text = strTitle;
    header.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    
    txtDescription.text = strDescription;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
