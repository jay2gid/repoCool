//
//  AppDelegate.h
//  AllCool.pl
//
//  Created by Sanjay on 06/09/17.
//  Copyright © 2017 Sanjay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleSignIn/GoogleSignIn.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <CoreLocation/CoreLocation.h>
@import GoogleMaps;
@import GooglePlaces;
@import Google;
@import GoogleSignIn;

@interface AppDelegate : UIResponder <UIApplicationDelegate,GIDSignInDelegate>

@property (strong, nonatomic) UIWindow *window;
+(AppDelegate *)delegate;

@property (strong, nonatomic) UINavigationController *navigationController;
@property (strong, nonatomic) CLLocationManager *lmanager;

@end

