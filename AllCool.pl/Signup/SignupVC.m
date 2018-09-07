//
//  SignupVC.m
//  AllCool.pl
//
//  Created by Sanjay on 06/09/17.
//  Copyright © 2017 Sanjay. All rights reserved.
//

#import "SignupVC.h"

@interface SignupVC ()<UIGestureRecognizerDelegate>

@end

@implementation SignupVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    GESTURE_POP
}
GESTURE_POP_DELEGATE

- (IBAction)btnSignUpClk:(id)sender
{
    if (txtFname.text.length < 1)
    {
        [txtFname becomeFirstResponder];
        [WebServiceCalls alert:@"Enter First name."];
    }
    else if (txtLname.text.length < 1)
    {
        [txtLname becomeFirstResponder];
        [WebServiceCalls alert:@"Enter Last name."];
    }
    else if (txtEmail.text.length < 1)
    {
        [txtEmail becomeFirstResponder];
        [WebServiceCalls alert:@"Enter Email first."];
    }
    else if (![WebServiceCalls isValidEmail:txtEmail.text])
    {
        [txtEmail becomeFirstResponder];
        [WebServiceCalls alert:@"Enter valid Email."];
    }
    else if (txtPass.text.length < 1)
    {
        [txtPass becomeFirstResponder];
        [WebServiceCalls alert:@"Enter Password first."];
    }
    else if (![txtPass.text isEqualToString:txtConPass.text])
    {
        [WebServiceCalls alert:@"Password not match."];
    }
    else
    {
        [self SignUpAPI];
    }
}

-(void) SignUpAPI
{
    NSDictionary *dict = @{@"firstname":txtFname.text, @"lastname":txtLname.text, @"email":txtEmail.text, @"password":txtPass.text, @"device_id":@"static_1234_static"};
    
    // http://allcool.pl/api_ios/Locator_Register.php
    SVHUD_START
    [WebServiceCalls POST:@"Locator_Register.php" parameter:dict completionBlock:^(id JSON, WebServiceResult result)
     {
         SVHUD_STOP
         NSLog(@"%@", JSON);
         
         if ([JSON[@"success"] integerValue] == 1)
         {
             // [WebServiceCalls alert:JSON[@"message"]];
             
             // POP_BACK
             /*UIStoryboard *storybord = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
             FirstVC *obj = [storybord instantiateViewControllerWithIdentifier:@"FirstVC"];
             [self.navigationController pushViewController:obj animated:YES];*/
             
             [self performSegueWithIdentifier:@"goMessage" sender:nil];
             [SVProgressHUD showInfoWithStatus:JSON[@"message"]];
         }
         else
         {
             [WebServiceCalls alert:JSON[@"message"]];
         }
     }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
@end
