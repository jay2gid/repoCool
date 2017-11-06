//
//  SplashVC.m
//  AllCool.pl
//
//  Created by Sanjay on 06/09/17.
//  Copyright © 2017 Sanjay. All rights reserved.
//

#import "SplashVC.h"
#import "UIImage+GIF.h"
@interface SplashVC ()
{
    IBOutlet UIImageView *imgaeGif;

}
@end

@implementation SplashVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    HIDE_NAV_BAR
    
  //  NSURL *url = [[NSBundle mainBundle] URLForResource:@"driver_call_icon" withExtension:@"gif"];

    
    UIImage* mygif = [UIImage sd_animatedGIFNamed:@"kufel5"];
    imgaeGif.image = mygif;
    
    [self performSelector:@selector(method) withObject:nil afterDelay:3];
}

-(void)method
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userid"] != NULL)
    {
        UIStoryboard *storybord = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        FirstVC *obj = [storybord instantiateViewControllerWithIdentifier:@"FirstVC"];
        
        self.navigationController.viewControllers = [NSArray arrayWithObject:obj];
    }
    else
    {
        [self performSegueWithIdentifier:@"goLogin" sender:nil];

    }
    [self performSelector:@selector(remobveGIF) withObject:nil afterDelay:1];
}

-(void)remobveGIF
{
    [imgaeGif removeFromSuperview];
}

- (void)didReceiveMemoryWarning{
    
    [super didReceiveMemoryWarning];
}

@end
