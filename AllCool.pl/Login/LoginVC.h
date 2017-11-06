//
//  LoginVC.h
//  AllCool.pl
//
//  Created by Sanjay on 06/09/17.
//  Copyright © 2017 Sanjay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface LoginVC : UIViewController<UIGestureRecognizerDelegate>
{
    IBOutlet UITextField *txtEmail;
    IBOutlet UITextField *txtPass;

    IBOutlet UIButton *btnForgot;
}
@end
