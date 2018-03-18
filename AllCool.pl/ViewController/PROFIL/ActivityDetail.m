//
//  ActivityDetail.m
//  AllCool.pl
//
//  Created by Sanjay on 07/01/18.
//  Copyright © 2018 Sanjay. All rights reserved.
//

#import "ActivityDetail.h"

@interface ActivityDetail (){
    
    IBOutlet UIImageView *image;
    IBOutlet UILabel *lblName;
    IBOutlet UILabel *lblDate;
    IBOutlet UILabel *lblComment;
    IBOutlet StarRatingControl *rating;
    
    IBOutlet UIImageView *imageWallpost;
    
    NSString *activity_type;
    
    NSDictionary *dictDetail;
    ViewAddRatingTobotal *viewRating;
}
@end

@implementation ActivityDetail
@synthesize infoDic;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    GET_HEADER_VIEW_WITH_BACK
    header.title.text = @"Oceana     ";
    
    
    activity_type = [Helper getString:infoDic[@"activity_type"]];
    
    [self getMyActivityData];
}

-(void)getMyActivityData{
    
    //id(mainid),type
    NSDictionary *param =@{@"id":[Helper getString:infoDic[@"id"]] ,@"type": activity_type} ;
    
    SVHUD_START
    [WebServiceCalls POST:@"get_activity_results.php" parameter:param completionBlock:^(id JSON, WebServiceResult result)
     {
         SVHUD_STOP
         
         @try
         {
             // [Helper makeToast:[Helper getString:JSON[@"message"]]];
             
             if ([JSON[@"success"] integerValue] == 1)
             {
                 if ([activity_type isEqualToString:@"rate_beer"]) {
                     
                     if (JSON[@"rate_beer"]) {
                         dictDetail = JSON[@"rate_beer"][0];
                     }
                 }
                 if ([activity_type isEqualToString:@"rat_brewery"] || [activity_type isEqualToString:@"rate_vendor"]) {
                     
                     if (JSON[@"rate_vendor"]) {
                         dictDetail = JSON[@"rate_vendor"][0];
                     }
                 }
                 if ([activity_type isEqualToString:@"rate_festival"]) {
                     
                     if (JSON[@"rate_festival"]) {
                         dictDetail = JSON[@"rate_festival"][0];
                     }
                 }
                 
                 NSURL  *url = [NSURL URLWithString:[Helper getString:dictDetail[@"usr_img"]]];
                 [image sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"noimage.jpg"]];
                 
                 lblDate.text = [Helper getString:dictDetail[@"dat"]];
                 lblName.text = [Helper getString:dictDetail[@"name"]];
                 lblComment.text = [Helper getString:dictDetail[@"comment"]];
                 rating.rating = [Helper getIntegerDefaultZero:dictDetail[@"rating"]];
             }
             else
             {
                 
             }
         }
         @catch (NSException *exception) {
         }
         @finally {
         }
     }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)tapEyeButton:(id)sender {
    
    if ([activity_type isEqualToString:@"rate_beer"]) {
        UIStoryboard *storybord = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        BotalVC *OBJ = [storybord instantiateViewControllerWithIdentifier:@"BotalVC"];
        OBJ.dictBeer = dictDetail;
        OBJ.from = @"other";
        [self.navigationController pushViewController:OBJ animated:YES];
    }
    if ( [activity_type isEqualToString:@"rate_vendor"]) {
        
        if ([dictDetail[@"vid"] integerValue] != 0) {
            PubVC *obj = [[PubVC alloc]initWithNibName:@"PubVC" bundle:nil];
            obj.infoDic = dictDetail;
            obj.from = @"other";
            [self.navigationController pushViewController:obj animated:YES];
        }
    }
    if ([activity_type isEqualToString:@"rat_brewery"] ) {
        
        BraveryVC *obj = [[[NSBundle mainBundle]loadNibNamed:@"Bravery" owner:self options:nil] objectAtIndex:0];
        obj.infoDic =  dictDetail;
        obj.from =  @"other";

        [self.navigationController pushViewController:obj animated:YES];
    }
    
    if ([activity_type isEqualToString:@"rate_festival"]) {
        
        UIStoryboard *storybord = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        FestivalViewVC *obj = [storybord instantiateViewControllerWithIdentifier:@"FestivalViewVC"];
        obj.F_ID = [Helper getString:dictDetail[@"fid"]];
        [self.navigationController pushViewController:obj animated:YES];
    }
    
}

- (IBAction)tapOption:(id)sender {

    
    UIAlertController * view = [UIAlertController
                                alertControllerWithTitle:@""
                                message:@""
                                preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* action1 = [UIAlertAction
                              actionWithTitle:@"Edytuj"
                              style:UIAlertActionStyleDefault
                              handler:^(UIAlertAction * action)
                              {
                                  [self editRatingView];
                              }];
    
    
    UIAlertAction* action3 = [UIAlertAction actionWithTitle:@"Kasuj" style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * action)
                              {
                                  [self apiDelete];
                              }];
    
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Wyjdz" style:UIAlertActionStyleCancel
                                                   handler:^(UIAlertAction * action)
                             {}];
    
    [view addAction:action1];
    [view addAction:action3];
    
    [view addAction:cancel];
    [self presentViewController:view animated:YES completion:nil];
}

-(void)editRatingView{
    
    viewRating = [[[NSBundle mainBundle] loadNibNamed:@"View" owner:self options:nil]objectAtIndex:1];
    viewRating.frame = CGRectMake(0, 0, WIDTH, HEIGHT);
    // view.BID = [NSString stringWithFormat:@"%@",dictBeer[@"id"]];
    viewRating.selfBack = self;
    viewRating.isUpdate = true;
    [self.view addSubview:viewRating];
    [viewRating.btnOk addTarget:self action:@selector(tapOkEditRatingComment) forControlEvents:UIControlEventTouchUpInside];
    viewRating.txtComment.text = [Helper getString:dictDetail[@"comment"]];
    viewRating.viewStarRating.rating = rating.rating;
}

-(void)tapOkEditRatingComment{
  
    NSString *urlDelete = @"";
    NSDictionary *dictParam =   @{@"id":[Helper getString:dictDetail[@"id"]],
                                @"rating":[NSString stringWithFormat:@"%lu",(unsigned long)viewRating.viewStarRating.rating],
                                @"comment":viewRating.txtComment.text};
   
    if ([activity_type isEqualToString:@"rate_beer"]) {
        urlDelete = @"vendorss/update_rat_beer.php";
    }
    
    if ( [activity_type isEqualToString:@"rate_vendor"]) {
        urlDelete = @"vendorss/update_rat_vendor.php";
    }
    
    if ([activity_type isEqualToString:@"rat_brewery"] ) {
        urlDelete = @"vendorss/update_rat_brewery.php";
    }
    
    if ([activity_type isEqualToString:@"rate_festival"]) {
        urlDelete = @"vendorss/update_rat_brewery.php";
    }
    
    SVHUD_START
    [WebServiceCalls POST:urlDelete parameter:dictParam completionBlock:^(id JSON, WebServiceResult result)
     {
         SVHUD_STOP
         NSLog(@"%@", JSON);
         @try
         {
             [Helper makeToast:[Helper getString:JSON[@"message"]]];
             if ([JSON[@"success"] integerValue] == 1)
             {
                 lblComment.text = viewRating.txtComment.text;
                 rating.rating = viewRating.viewStarRating.rating;
                 [viewRating removeFromSuperview];
                 
             }else {
                 
             }
             
         } @catch (NSException *exception) {
         }
         @finally {
         }
     }];
}

-(void)apiDelete{

    NSString *urlDelete = @"";
    NSDictionary *dictParam ;
    
    if ([activity_type isEqualToString:@"rate_beer"]) {
        urlDelete = @"vendorss/delete_rat_beer.php";
        dictParam = @{@"id":[Helper getString:dictDetail[@"id"]]};
    }
    if ( [activity_type isEqualToString:@"rate_vendor"]) {
        urlDelete = @"vendorss/delete_rat_vendor.php";
        dictParam = @{@"id":[Helper getString:dictDetail[@"id"]]};
    }
    if ([activity_type isEqualToString:@"rat_brewery"] ) {
        urlDelete = @"vendorss/delete_rat_brewery.php";
        dictParam = @{@"id":[Helper getString:dictDetail[@"id"]],@"type":activity_type};
    }
    if ([activity_type isEqualToString:@"rate_festival"]) {
        urlDelete = @"vendorss/delete_rat_beer.php";
        dictParam = @{@"id":[Helper getString:dictDetail[@"id"]]};
    }
    SVHUD_START

    
    [WebServiceCalls POST:urlDelete parameter:dictParam completionBlock:^(id JSON, WebServiceResult result)
     {
         SVHUD_STOP
         NSLog(@"%@", JSON);
         @try
         {
             [Helper makeToast:[Helper getString:JSON[@"message"]]];
             if ([JSON[@"success"] integerValue] == 1)
             {
                 [self.navigationController popViewControllerAnimated:true];
             
             }else {
                 
             }
         } @catch (NSException *exception) {
         }
         @finally {
         }
     }];
}

@end
