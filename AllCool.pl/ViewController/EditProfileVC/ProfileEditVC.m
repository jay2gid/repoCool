//
//  ProfileEditVC.m
//  AllCool.pl
//
//  Created by Sanjay on 16/09/17.
//  Copyright © 2017 Sanjay. All rights reserved.
//

#import "ProfileEditVC.h"

@interface ProfileEditVC (){
     IBOutlet UIImageView *imageProfile;
    IBOutlet UILabel *lblStatus;
    IBOutlet UIView *lblName;
}
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


@end
