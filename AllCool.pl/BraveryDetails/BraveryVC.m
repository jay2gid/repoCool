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
#import "BtnCell.h"
#import "PosterCell.h"
@interface BraveryVC ()
{
    IBOutlet NSLayoutConstraint *lineX;
    IBOutlet UIScrollView *scrollBotals;
    NSDictionary *dict_Brewary;
    IBOutlet UITableView *table;
    
    NSUInteger tableFlag;
    NSArray *arrBeer,*arrWallPost;
    NSString * idBravery;
    
    
    IBOutlet UILabel *lblLikeCount;
    IBOutlet UIImageView *imgBg;
}
@end

@implementation BraveryVC

@synthesize infoDic, imgLogo, avg_rating, lblProducer_name, lblBar_type;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    tableFlag = 1;
    table.delegate = self;
    table.dataSource = self;

    GET_HEADER_VIEW_WITH_BACK
    header.title.text = @"Allcool.pl";
    header.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    
    if (!arrWallPost)
    {
        [self getWallPost];
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    
    idBravery = [Helper getString:infoDic[@"id"]] ;
    if ([_from isEqualToString:@"other"]) {
        idBravery = [Helper getString:infoDic[@"vid"]] ;
    }
    NSString *url = [NSString stringWithFormat:@"vendorss/Brewary_Profile.php?id=%@&uid=%@",idBravery, UserID];
    SVHUD_START
    [WebServiceCalls GET:url parameter:nil completionBlock:^(id JSON, WebServiceResult result)
     {
         SVHUD_STOP
         NSLog(@"%@", JSON);
         @try
         {
             if ([JSON[@"success"] integerValue] == 1) {
                 if (!arrBeer) {
                     [self getAllBeer];
                 }

                 dict_Brewary = JSON;
                 
                 [Helper setImageOnPGlass:imgLogo url:dict_Brewary[@"products"][0][@"image"]];
                 // [Helper setImageOnPGlass:imgBg url:dict_Brewary[@"products"][0][@"image"]];
                 lblLikeCount.text = [Helper getStringORZero:JSON[@"count"]];
                 
                 avg_rating.rating = [dict_Brewary[@"products"][0][@"Avg_rating"] integerValue];
                 lblProducer_name.text = dict_Brewary[@"products"][0][@"producer_name"];
                 lblBar_type.text = dict_Brewary[@"products"][0][@"bar_type"];
                 
                 [table reloadData];
             } else {
              //   [Helper makeToast:JSON[@"message"]];
             }
         }
         @catch (NSException *exception)
         {  }
         @finally
         {  }
     }];

   

}

-(void)getAllBeer
{
    
    NSString *url = [NSString stringWithFormat:@"vendorss/Bravery_beer.php?id=%@", infoDic[@"id"]];
    SVHUD_START
    [WebServiceCalls GET:url parameter:nil completionBlock:^(id JSON, WebServiceResult result) {
        
         SVHUD_STOP
         NSLog(@"%@", JSON);
         @try
         {
             if ([JSON[@"success"] integerValue] == 1)
             {
                 arrBeer = JSON[@"products"];
                 [self loadCollectionScrollView];
             }
             else
             {
                 [Helper makeToast:JSON[@"message"]];
             }
         }
         @catch (NSException *exception)
         {  }
         @finally
         {  }
     }];
}

-(void)getWallPost{
    
    NSString *url = [NSString stringWithFormat:@"vendorss/Brewaryget_wallpost.php?pid=%@", infoDic[@"id"]];
    SVHUD_START
    [WebServiceCalls GET:url parameter:nil completionBlock:^(id JSON, WebServiceResult result) {
        
        SVHUD_STOP
        @try
        {
            if ([JSON[@"success"] integerValue] == 1){
                arrWallPost = JSON[@"post"];
                [self loadCollectionScrollView];
            }
            else {
               
                // [WebServiceCalls alert:JSON[@"message"]];
                // [Helper makeToast:JSON[@"message"]];
            }
        }
        @catch (NSException *exception)
        {  }
        @finally
        {  }
    }];
}


-(void)loadCollectionScrollView
{
    float cellHeight = HEIGHT/3;

    for (int i = 0; i<arrBeer.count; i++)
    {
        MyCellView *myCell = [[[NSBundle mainBundle]loadNibNamed:@"MyCell" owner:self options:nil]objectAtIndex:1];
        myCell.frame = CGRectMake(WIDTH/2* (float)(i%2), i/2 *cellHeight, WIDTH/2, cellHeight);
        
        NSString *url = [NSString stringWithFormat:@"%@", arrBeer[i][@"image"]];
        [myCell.imgBoatal sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"noimage.jpg"]];
        
        myCell.lglName.text = [NSString stringWithFormat:@"%@", arrBeer[i][@"product_name"]];
        
        myCell.rating.rating = [arrBeer[i][@"Avg_rating"] integerValue];
        myCell.infoDict = arrBeer[i];
        
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

-(void)tapOnbotal:(UIButton *)sender
{
//    BotalVC *OBJ = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"BotalVC"];
//    OBJ.dictBeer = arrBeer[sender.tag];
//    [self.navigationController pushViewController:OBJ animated:YES];
}

- (IBAction)tapPlus:(id)sender
{
    UIAlertController * view = [UIAlertController
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
                                       ViewAddRatingTobotal *view1 = [[[NSBundle mainBundle] loadNibNamed:@"View" owner:self options:nil]objectAtIndex:2];
                                       view1.frame = CGRectMake(0, 0, WIDTH, HEIGHT);
                                       view1.selfBack = self;
                                       view1.delegate = self;
                                       view1.VID = idBravery;
                                       [self.view addSubview:view1];
                                       
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
    
    [doNotDistrbe setValue:[[UIImage imageNamed:@"box_op"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forKey:@"image"];
    [away setValue:[[UIImage imageNamed:@"star_op"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forKey:@"image"];
    
    [view addAction:doNotDistrbe];
    [view addAction:away];
    [view addAction:cancel];
    
    [self presentViewController:view animated:YES completion:nil];
}

-(void)didSuccessRating
{
    [self viewDidAppear:NO];
    NSLog(@"Comment Added");
}

-(void)didSuccessVenderSuggest
{
    NSLog(@"Sujjestion Added.");
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
             [self.navigationController.view makeToast:JSON[@"message"]];
             [self viewDidAppear:NO];
         }
         else
         {
             [self.navigationController.view makeToast:JSON[@"message"]];
         }
     }];
}

- (IBAction)tapSegmanets:(UIButton *)sender {
    
    [UIView animateWithDuration:0.3 animations:^{
        lineX.constant = WIDTH/3 * sender.tag;
    }];
    

    if (sender.tag == 0)
    {
        tableFlag = 1;
        scrollBotals.hidden = true;
        table.hidden = false;
        [table reloadData];
    }
    else if (sender.tag == 1){
        
        scrollBotals.hidden = false;
        table.hidden = true;
        
        if (!arrBeer){
            [self getAllBeer];
        }
        else {
            [self loadCollectionScrollView];
        }
    }
    else {
        
        tableFlag = 2;
        scrollBotals.hidden = true;
        [table reloadData];
    }
}

#pragma mark Table

-(CGFloat)tableView:(UITableView* )tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableFlag == 1) {
        if (indexPath.row == 0) {
            if ([[Helper getString:dict_Brewary[@"products"][0][@"description"]] length] < 2) {
                return 175;
            }else{
                return  234;
            }
        }
        else{
            return 85;
        }
    }
   else{
       return 300;
   }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableFlag == 1){
        NSInteger count = [dict_Brewary[@"comment"] count];
        return count+1;
    }
    else{
        return arrWallPost.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableFlag == 1){
        
        if (indexPath.row == 0) {
            
            BtnCell *myCell = [[[NSBundle mainBundle]loadNibNamed:@"MyCell" owner:self options:nil]objectAtIndex:0];
            
            myCell.lblProducer_name.text = [Helper getString:dict_Brewary[@"products"][0][@"producer_name"]];
            myCell.lblPhone.text = [Helper getString:dict_Brewary[@"products"][0][@"phone"]];
            myCell.lblWebsite.text =  [Helper getString:dict_Brewary[@"products"][0][@"website"]];
            myCell.lblRegion.text = [Helper getString:dict_Brewary[@"products"][0][@"region"]];
            myCell.lblBar_type.text = [Helper getString:dict_Brewary[@"products"][0][@"bar_type"]];
            myCell.lblDescription.text = [Helper getString:dict_Brewary[@"products"][0][@"description"]];
            
            myCell.infoDicBrovary = dict_Brewary;
            myCell.selfBack = self;
            return myCell;
        }
        else {
            
            RatingCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"Cells" owner:self options:nil]objectAtIndex:3];
            NSDictionary *dict = dict_Brewary[@"comment"][indexPath.row-1];
            
            cell.lblUserName.text = [NSString stringWithFormat:@"%@",dict[@"name"]];
            cell.lblDateTime.text = [NSString stringWithFormat:@"%@",dict[@"dat"]];
            cell.lblReview.text = [NSString stringWithFormat:@"%@",dict[@"comment"]];
            cell.viewRating.rating = [dict[@"rating"] integerValue];
            
            return cell;
        }
    }
    else {
        PosterCell *myCell = [[[NSBundle mainBundle]loadNibNamed:@"MyCell" owner:self options:nil]objectAtIndex:2];
        
         [myCell.imgPoster sd_setImageWithURL:[NSURL URLWithString:arrWallPost[indexPath.row][@"img"]] placeholderImage:[UIImage imageNamed:@"no_image.png"]];

        myCell.lblDesc.text = [Helper getString:arrWallPost[indexPath.row][@"title"]];
        myCell.lblDate.text = [Helper getString:arrWallPost[indexPath.row][@"dat"]];
        myCell.lblTitle.text = [Helper getString:arrWallPost[indexPath.row][@"title"]];

        return myCell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
