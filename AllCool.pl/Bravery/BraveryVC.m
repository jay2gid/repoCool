//
//  BraveryVC.m
//  AllCool.pl
//
//  Created by Sanjay on 22/10/17.
//  Copyright © 2017 Sanjay. All rights reserved.
//

#import "BraveryVC.h"
#import "MyCellView.h"
#import "ViewAddRatingTobotal.h"

@interface BraveryVC ()
{
    IBOutlet NSLayoutConstraint *lineX;
    IBOutlet UIScrollView *scrollBotals;
    
    NSDictionary *dict_Brewary;
}
@end

@implementation BraveryVC

@synthesize infoDic;

- (void)viewDidLoad {
    [super viewDidLoad];

    // -- Single Brawery Detail
    
    /* NSDictionary *dict = @{@"uid":UserID, @"id":infoDic[@"id"]};


    SVHUD_START
    [WebServiceCalls POST:@"vendorss/Brewary_Profile.php" parameter:dict completionBlock:^(id JSON, WebServiceResult result)
     {
         SVHUD_STOP
         NSLog(@"%@", JSON);
         
         @try
         {
             if ([JSON[@"success"] integerValue] == 1)
             {
                 [WebServiceCalls alert:JSON[@"message"]];
             }
             else
             {
                 [WebServiceCalls alert:JSON[@"message"]];
             }
         }
         @catch (NSException *exception)
         {  }
         @finally
         {  }         
     }];*/
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    NSString *url = [NSString stringWithFormat:@"vendorss/Brewary_Profile.php?id=%@&uid=%@", infoDic[@"id"], UserID];
    SVHUD_START
    [WebServiceCalls GET:url parameter:nil completionBlock:^(id JSON, WebServiceResult result)
     {
         SVHUD_STOP
         NSLog(@"%@", JSON);
         @try
         {
             if ([JSON[@"success"] integerValue] == 1)
             {
                 dict_Brewary = JSON;
             }
             else
             {
                 [WebServiceCalls alert:JSON[@"message"]];
             }
         }
         @catch (NSException *exception)
         {  }
         @finally
         {  }
     }];
    
    //[self loadCollectionScrollView];
}



-(void)loadCollectionScrollView
{
    float cellHeight = HEIGHT/3;

    for (int i = 0; i<5; i++) {

        MyCellView *myCell = [[[NSBundle mainBundle]loadNibNamed:@"MyCell" owner:self options:nil]objectAtIndex:1];
        myCell.frame = CGRectMake(WIDTH/2* (float)(i%2), i/2 *cellHeight, WIDTH/2, cellHeight);
        [scrollBotals addSubview:myCell];

        UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(0, (i/2 + 1)*cellHeight, WIDTH, 0.5)];
        lbl.backgroundColor = [UIColor lightGrayColor];
        [scrollBotals addSubview:lbl];

        lbl = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH/2, i/2 *cellHeight, 0.5, cellHeight)];
        lbl.backgroundColor = [UIColor lightGrayColor];
        [scrollBotals addSubview:lbl];
    }

    [scrollBotals setContentSize:CGSizeMake(WIDTH, HEIGHT)];
    
}

- (IBAction)tapSegmanets:(UIButton *)sender {

    lineX.constant = WIDTH/3 * sender.tag;
}


- (IBAction)tapPlus:(id)sender
{
    UIAlertController * view=   [UIAlertController
                                 alertControllerWithTitle:@""
                                 message:@""
                                 preferredStyle:UIAlertControllerStyleActionSheet];
    
    if ([dict_Brewary[@"products"][0][@"pub_visited"] integerValue] != 1)
    {
        UIAlertAction* online = [UIAlertAction
                                 actionWithTitle:@"Odwiedzony"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     // http://allcool.pl/api_ios/brewery_visited.php
                                     
                                     NSDictionary *dict = @{@"uid":UserID, @"vid":infoDic[@"id"]};
                                     [self Api_URL:@"brewery_visited.php" Data:dict];
                                     
                                     [view dismissViewControllerAnimated:YES completion:nil];
                                 }];
        
        [online setValue:[[UIImage imageNamed:@"flag_op"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forKey:@"image"];
        
        [view addAction:online];
    }

    if ([dict_Brewary[@"products"][0][@"fav_vendor"] integerValue] != 1)
    {
        UIAlertAction* offline = [UIAlertAction
                                  actionWithTitle:@"Ulubiony"
                                  style:UIAlertActionStyleDefault
                                  handler:^(UIAlertAction * action)
                                  {
                                      // http://allcool.pl/api_ios/favourite_brewery.php
                                      
                                      NSDictionary *dict = @{@"uid":UserID, @"vid":infoDic[@"id"]};
                                      [self Api_URL:@"favourite_brewery.php" Data:dict];
                                      
                                      [view dismissViewControllerAnimated:YES completion:nil];
                                  }];
        
        [offline setValue:[[UIImage imageNamed:@"like_op"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forKey:@"image"];
        
        [view addAction:offline];
    }
    
    UIAlertAction* doNotDistrbe = [UIAlertAction
                                   actionWithTitle:@"Pokaz droge"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action)
                                   {
                                       [view dismissViewControllerAnimated:YES completion:nil];
                                   }];
    
    UIAlertAction* away = [UIAlertAction
                           actionWithTitle:@"Ocen festiwal"
                           style:UIAlertActionStyleDefault
                           handler:^(UIAlertAction * action)
                           {
                               ViewAddRatingTobotal *view1 = [[[NSBundle mainBundle] loadNibNamed:@"View" owner:self options:nil]objectAtIndex:1];
                               view1.frame = CGRectMake(0, 0, WIDTH, HEIGHT);
                               view1.isF_ID_Vid = 1;
                               view1.VID = infoDic[@"id"];
                               view1.selfBack = self;
                               view1.delegate = self;
                               [self.view addSubview:view1];
                               
                               [view dismissViewControllerAnimated:YES completion:nil];
                           }];
    
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:@"Cancel"
                             style:UIAlertActionStyleCancel
                             handler:^(UIAlertAction * action)
                             {  }];
    
    [doNotDistrbe setValue:[[UIImage imageNamed:@"star_op"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forKey:@"image"];
    [away setValue:[[UIImage imageNamed:@"star_op"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forKey:@"image"];
    
    [view addAction:doNotDistrbe];
    [view addAction:away];
    [view addAction:cancel];
    
    [self presentViewController:view animated:YES completion:nil];
}

-(void)didSuccessRating
{
    NSLog(@"Comment Added");
}

-(void)Api_URL:(NSString *)url Data:(NSDictionary *)dict
{
    SVHUD_START
    [WebServiceCalls POST:url parameter:dict completionBlock:^(id JSON, WebServiceResult result)
     {
         SVHUD_STOP
         NSLog(@"%@", JSON);
         
         if ([JSON[@"success"] integerValue] == 1)
         {
             [WebServiceCalls alert:JSON[@"message"]];
             [self viewDidAppear:NO];
         }
         else
         {
             [WebServiceCalls alert:JSON[@"message"]];
         }
     }];
}
@end
