//
//  BraveryVC.m
//  AllCool.pl
//
//  Created by Sanjay on 22/10/17.
//  Copyright © 2017 Sanjay. All rights reserved.
//

#import "BraveryVC.h"
#import "MyCellView.h"

@interface BraveryVC ()
{
    IBOutlet NSLayoutConstraint *lineX;
    IBOutlet UIScrollView *scrollBotals;
    
}
@end

@implementation BraveryVC

- (void)viewDidLoad {
    [super viewDidLoad];

    // -- Single Brawery Detail
    
    SVHUD_START
    [WebServiceCalls GET:@"vendorss/Brewary_Profile.php" parameter:nil completionBlock:^(id JSON, WebServiceResult result)
     {
         SVHUD_STOP
         @try
         {
             if ([JSON[@"success"] integerValue] == 1)
             {

             }
             else
             {

             }
         }
         @catch (NSException *exception)
         {  }
         @finally
         {  }
     }];

    [self loadCollectionScrollView];
    
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
    
   
    UIAlertAction* online = [UIAlertAction
                                 actionWithTitle:@"Odwiedzony"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                   
                                 }];
        
    [online setValue:[[UIImage imageNamed:@"flag_op"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forKey:@"image"];
        
    [view addAction:online];
    
    

    UIAlertAction* offline = [UIAlertAction
                                  actionWithTitle:@"Ulubiony"
                                  style:UIAlertActionStyleDefault
                                  handler:^(UIAlertAction * action)
                                  {
                                  
                                      
                                  }];
        
    [offline setValue:[[UIImage imageNamed:@"like_op"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forKey:@"image"];
        
    [view addAction:offline];

    
    UIAlertAction* doNotDistrbe = [UIAlertAction
                                   actionWithTitle:@"Pokaz droge"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action)
                                   {
                                       [view dismissViewControllerAnimated:YES completion:nil];
                                   }];
    
    UIAlertAction* away = [UIAlertAction
                           actionWithTitle:@"Ocen festiwal"
                           style:UIAlertActionStyleDestructive
                           handler:^(UIAlertAction * action)
                           {  }];
    
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
         }
         else
         {
             [WebServiceCalls alert:JSON[@"message"]];
         }
     }];
}
@end
