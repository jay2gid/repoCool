//
//  LoginVC.m
//  AllCool.pl
//
//  Created by Sanjay on 06/09/17.
//  Copyright © 2017 Sanjay. All rights reserved.
//

#import "LoginVC.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>

@interface LoginVC ()<FBSDKLoginButtonDelegate,GIDSignInDelegate,GIDSignInUIDelegate>
{
    FBSDKLoginButton *loginButton;
}

@property(strong, nonatomic) GIDSignInButton *signInButton;

@end

@implementation LoginVC

- (void)viewDidLoad {
    
    [super viewDidLoad];

    HIDE_NAV_BAR
    
    
    btnForgot.layer.shadowColor = BLACK_COLOR.CGColor;
    btnForgot.layer.shadowOffset = CGSizeMake(1, 1);
    btnForgot.layer.shadowOpacity = 10;
    
    loginButton = [[FBSDKLoginButton alloc] init];
    loginButton.center = self.view.center;
    [self.view addSubview:loginButton];
    loginButton.loginBehavior = FBSDKLoginBehaviorWeb;
    loginButton.hidden = true;
    loginButton.delegate = self;
    
    
    [GIDSignIn sharedInstance].uiDelegate = self;
    [GIDSignIn sharedInstance].clientID = kClientID;
    
    _signInButton = [[GIDSignInButton alloc]init];
    _signInButton.center = self.view.center;
    [self.view addSubview:_signInButton];
    [GIDSignIn sharedInstance].delegate = self;
    _signInButton.hidden = true;
    
    GESTURE_POP_REMOVE
    
}
- (IBAction)tapFacebookLogin:(id)sender
{
    [loginButton sendActionsForControlEvents:UIControlEventTouchUpInside];
}

- (IBAction)tapGoogleLogin:(id)sender
{
    [_signInButton sendActionsForControlEvents:UIControlEventTouchUpInside];
}



- (IBAction)btnLoginClk:(id)sender
{
    if (txtEmail.text.length < 1)
    {
        [txtEmail becomeFirstResponder];
        [WebServiceCalls alert:@"Enter Email first."];
    }
    else if (txtPass.text.length < 1)
    {
        [txtPass becomeFirstResponder];
        [WebServiceCalls alert:@"Enter Email first."];
    }
    else if (![WebServiceCalls isValidEmail:txtEmail.text])
    {
        [txtEmail becomeFirstResponder];
        [WebServiceCalls alert:@"Enter valid Email."];
    }
    else
    {
        NSDictionary *dict = @{@"email":txtEmail.text, @"password":txtPass.text, @"type":@"user"};

        [self LoginWithParamerter:dict];
    }
}

-(void)LoginWithParamerter:(NSDictionary *)param
{
    SVHUD_START
    [WebServiceCalls POST:@"check_login.php" parameter:param completionBlock:^(id JSON, WebServiceResult result)
    {
        SVHUD_STOP
        NSLog(@"%@", JSON);
        if (result == WebServiceResultFail) {
            
            if (JSON)
            {
               [WebServiceCalls alert:JSON[@"message"]];
            }
        }
        else
        {
            if ([JSON[@"success"] integerValue] == 1)
            {
            //[WebServiceCalls alert:JSON[@"message"]];
            
            /*
             {
             message = "Zalogowano z sukcesem";
             success = 1;
             "user_detail" =     {
             address = "        ";
             city = "";
             contact = "";
             country = Poland;
             "dat_add" = "2017-03-22 02:26:13";
             dob = "";
             firstname = RRahul;
             image = "http://allcool.pl/assests/images/user/1494731616_1494731613908.jpg";
             lastname = Jangid;
             msg = "Zalogowano z sukcesem";
             newsletter = "";
             postcode = "";
             quote = "";
             title = Pan;
             useremail = "rahuljangid1993@gmail.com";
             userid = 1;
             usrtype = 2;
             };
             }
             */
            
            NSString *setUserID = [NSString stringWithFormat:@"%@", JSON[@"user_detail"][@"userid"]];
            [[NSUserDefaults standardUserDefaults] setObject:setUserID forKey:@"userid"];
            
            NSString *setUserName = [NSString stringWithFormat:@"%@ %@", JSON[@"user_detail"][@"firstname"], JSON[@"user_detail"][@"lastname"]];
            [[NSUserDefaults standardUserDefaults] setObject:setUserName forKey:@"username"];
            
            NSString *setEmailID = [NSString stringWithFormat:@"%@", JSON[@"user_detail"][@"useremail"]];
            [[NSUserDefaults standardUserDefaults] setObject:setEmailID forKey:@"useremail"];
            
            NSString *setUserType = [NSString stringWithFormat:@"%@", JSON[@"user_detail"][@"usrtype"]];
            [[NSUserDefaults standardUserDefaults] setObject:setUserType forKey:@"usertype"];
            
            UIStoryboard *storybord = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            FirstVC *obj = [storybord instantiateViewControllerWithIdentifier:@"FirstVC"];
            [self.navigationController pushViewController:obj animated:YES];
            }
            else
            {
                [WebServiceCalls alert:JSON[@"message"]];
            }
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark Facebook Delegate

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
}

- (void)loginButton:(FBSDKLoginButton *)loginButton
didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result
              error:(NSError *)error
{
    ////  NSLog(@"%@",result);
    ////  NSLog(@"%@",result);
    
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@"id,name,email" forKey:@"fields"];
    
    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:parameters]
     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error)
     {
         if(!error)
         {
             NSMutableDictionary *dic = [NSMutableDictionary dictionary];
             [dic setObject:result[@"name"] forKey:@"name"];
             [dic setObject:@"facebook" forKey:@"type"];

             if (result[@"email"])
             {
                 [dic setObject:result[@"email"] forKey:@"name"];
             }
             else
             {
                 [dic setObject:[NSString stringWithFormat:@"%@@fb.com",result[@"id"]] forKey:@"email"];
             }
             
             [self LoginWithParamerter:dic];
             
             FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
             [loginManager logOut];
         }
     }];
}

- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton { 
    
}

- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user withError:(NSError *)error {
    
//    NSString *userId = user.userID;                  // For client-side use only!
//    NSString *idToken = user.authentication.idToken; // Safe to send to the server
      NSString *fullName = user.profile.name;
//    NSString *givenName = user.profile.givenName;
//    NSString *familyName = user.profile.familyName;
      NSString *email = user.profile.email;
    
   
    if (user)
    {
        NSDictionary *dic = @{@"name":fullName,@"email":email,@"type":@"google"};
        [self LoginWithParamerter:dic];
    }
    [signIn signOut];
    // NSLog(@"%@ %@ %@ %@ %@ %@",userId,idToken,fullName,givenName,familyName,email);
    
}

@end
