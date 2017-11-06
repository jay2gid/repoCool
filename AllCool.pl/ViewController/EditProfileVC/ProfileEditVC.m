//
//  ProfileEditVC.m
//  AllCool.pl
//
//  Created by Sanjay on 16/09/17.
//  Copyright © 2017 Sanjay. All rights reserved.
//

#import "ProfileEditVC.h"

@interface ProfileEditVC ()

@end

@implementation ProfileEditVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    GET_HEADER_VIEW_WITH_BACK
    header.title.text = @"Me";

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
