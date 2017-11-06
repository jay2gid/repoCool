//
//  BrowaryVC.m
//  AllCool.pl
//
//  Created by Sanjay on 08/09/17.
//  Copyright © 2017 Sanjay. All rights reserved.
//

#import "BrowaryVC.h"

@interface BrowaryVC ()
{
    IBOutlet UIScrollView *scrollData;
    
    NSArray *arrProducers;
}
@end

@implementation BrowaryVC

- (void)viewDidLoad {
    [super viewDidLoad];

    GET_HEADER_VIEW
    header.title.text = @"Browary";
    
    [self get_all_producers];
}

-(void) get_all_producers
{
    //  http://allcool.pl/api_ios/get_all_producers.php
    SVHUD_START
    [WebServiceCalls GET:@"get_all_producers.php" parameter:nil completionBlock:^(id JSON, WebServiceResult result)
     {
         SVHUD_STOP
         NSLog(@"%@", JSON);
         
         @try
         {
             if ([JSON[@"success"] integerValue] == 1)
             {
                 arrProducers = JSON[@"producers"];
                 [self loadData];
             }
             else
             {
                // [WebServiceCalls alert:@"Unable to fetch data. try again"];
             }
         }
         @catch (NSException *exception)
         {
         }
         @finally
         {
         }
     }];
}

-(void)loadData
{
    for (int i = 0; i<arrProducers.count; i++)
    {
        int wd = WIDTH/3;
    
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(wd*(i%3), wd * (int)(i/3), WIDTH/3, WIDTH/3)];
        
        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(wd/6,10,wd-wd/3,wd- wd/3)];
        image.backgroundColor = GRAY_COLOR;
        [view addSubview:image];
        [image sd_setImageWithURL:[NSURL URLWithString:arrProducers[i][@"image"]] placeholderImage:[UIImage imageNamed:@"noimage.jpg"]];
        
        
        UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(5,wd-40,wd-10,50)];
        lbl.numberOfLines = 0;
        lbl.text = arrProducers[i][@"producer_name"];
        [view addSubview:lbl];
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.font = [UIFont systemFontOfSize:14];
        
        [scrollData addSubview:view];
    }
    
    int chk = 1*(arrProducers.count%3);
    if (chk > 0)
    {
        chk = 1;
    }
    
    [scrollData setContentSize:CGSizeMake(WIDTH, (WIDTH/3)*((arrProducers.count/3)+chk)+10)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
