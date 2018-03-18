//
//  ProfilVC.m
//  AllCool.pl
//
//  Created by Sanjay on 24/09/17.
//  Copyright © 2017 Sanjay. All rights reserved.
//

#import "ProfilVC.h"

@interface ProfilVC ()
{
    IBOutlet UIImageView *imgFill;
    IBOutlet UILabel *lblStatus;
    IBOutlet UILabel *lblPiwaCount;
    IBOutlet UILabel *lblBarowCount;
    IBOutlet UILabel *lblBrowrCount;
    IBOutlet UILabel *lblPountCount;
    IBOutlet UIView *viewForHeader;
    
    IBOutlet UIScrollView *scrollBotals;
    
    IBOutlet UIScrollView *scrollVender;
    
}

@end
@implementation ProfilVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (_idUser) {
        GET_HEADER_VIEW_WITH_BACK
        header.title.text = @"Profil";
        [viewForHeader addSubview:header];

    }else{
        GET_HEADER_VIEW
        header.title.text = @"Profil";
        [viewForHeader addSubview:header];
    }
    
    [self getMyActivityData];
    
    //  [Helper setImageOnPGlass:imgFill url:USER_IMAGE_URL];
}

-(void)getMyActivityData {
    
    
    NSDictionary *param =@{@"uid": UserID} ;
    
    if (_idUser) {
        param =@{@"uid": _idUser} ;
    }
    
    SVHUD_START
    [WebServiceCalls POST:@"profileAttribute.php" parameter:param completionBlock:^(id JSON, WebServiceResult result)
     {
         SVHUD_STOP
         NSLog(@"%@", JSON);
         @try
         {
             
             [Helper setImageOnPGlass:imgFill url:JSON[@"usr_img"]];

             
             if ([JSON[@"success"] integerValue] == 1) {
                 lblPiwaCount.text = [Helper getString:JSON[@"user_beer_tested"]];
                 lblBarowCount.text = [Helper getString:JSON[@"user_brewery_visited"]];
                 lblPountCount.text = [Helper getString:JSON[@"user_total_earn"]];
                 lblBrowrCount.text = [Helper getString:JSON[@"user_pub_visited"]];
                 
                 for (int i = 0; i < [JSON[@"beer_detail"] count] ; i++) {
                     UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake( 60 * i, 0, 50, scrollBotals.frame.size.height)];

                     [scrollBotals addSubview:imageView];
                     imageView.contentMode = UIViewContentModeScaleAspectFill;
                     imageView.clipsToBounds = true;
                     [Helper setImageOnPGlass:imageView url:JSON[@"beer_detail"][i][@"image"]];

                 }
                 
                 for (int i = 0; i < [JSON[@"vendor_details"] count] ; i++) {
                     UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake( 60 * i, 0, 50, scrollVender.frame.size.height)];
                    
                     [Helper setImageOnPGlass:imageView url:JSON[@"vendor_details"][i][@"img"]];

                     [scrollVender addSubview:imageView];
                     imageView.contentMode = UIViewContentModeScaleAspectFill;
                     imageView.clipsToBounds = true;
                 }
                 
                 scrollVender.contentSize = CGSizeMake(60 * [JSON[@"vendor_details"] count], 10);
                 scrollBotals.contentSize = CGSizeMake(60 * [JSON[@"beer_detail"] count], 10);
                 
                 lblStatus.text =  [Helper getString:JSON[@"quote"]];
                 
             }else {
                 [Helper makeToast:[Helper getString:JSON[@"message"]]];
             }
         }
         @catch (NSException *exception) { }
         @finally { }
     }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
