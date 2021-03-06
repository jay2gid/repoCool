//
//  FestivalViewVC.m
//  AllCool.pl
//
//  Created by Upendra Singh Shekhawat on 25/09/17.
//  Copyright © 2017 Sanjay. All rights reserved.
//

#import "FestivalViewVC.h"
#import "ExibitorTVCell.h"
#import "ProgramTVCell.h"
#import "RatingTVCell.h"
#import "CategoryTVCell.h"
#import "ViewAddRatingTobotal.h"
#import "ViewProgram.h"

@interface FestivalViewVC ()

@end

@implementation FestivalViewVC
{
    NSArray *arrImgSelected, *arrImgDefault, *arrImgName, *arrLblName;
    
    NSInteger tag;
    
    NSArray *arrExibitors, *arrProg, *arrRating, *arrCategory;
    NSDictionary *fest_Dict;
    
    ViewProgram *viewProgram;

}

@synthesize F_ID;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    GET_HEADER_VIEW_WITH_BACK
    header.title.text = @"Allcool.pl";

    viewStar.rating = 4;
    
    btnCall.layer.borderWidth = 1;
    btnCall.layer.borderColor = [[UIColor colorWithRed:102/255.0 green:192/255.0 blue:78/255.0 alpha:1]  CGColor];
    
    btnCall.layer.cornerRadius = 5;
    btnCall.layer.masksToBounds = YES;
    
    arrImgDefault = @[@"exibitors_unselect.png", @"program_unselect.png", @"map_unselect.png", @"rating_unselect.png", @"category_unselect.png"];
    arrImgSelected = @[@"exibitors_select.png", @"program_select.png", @"map_select.png", @"rating_select.png", @"category_select.png"];
    
    arrImgName = @[imgExibitors, imgProg, imgMap, imgRating, imgCategory];
    arrLblName = @[lblExibitors, lblProg, lblMap, lblRating, lblCategory];
    
    imgMapPreiew.hidden = YES;
    
    tag = 0;
    
    arrExibitors = arrProg = arrRating = arrCategory = @[];
    
    [self festivalDetails];
    [self get_Fest_Exibitors];
    [self get_Fest_Prog];
    [self get_Fest_Rating];
    [self get_Fest_Category];
    
    [tblViewFest reloadData];

    
    ////// --- defauld data
    
    lblFestName.text = [Helper getString:_infoDic[@"f_name"]];
    lblAddLine1.text = [NSString stringWithFormat:@"%@ %@",_infoDic[@"street_name"],_infoDic[@"street_num"]];
    lblAddLine2.text = [NSString stringWithFormat:@"%@ | ",_infoDic[@"city"]];
    lblFestDate.text = [NSString stringWithFormat:@"%@ - %@",_infoDic[@"start_Date"],_infoDic[@"end_Date"]];
    
    [Helper setImageOnPBotal:imgFest url:_infoDic[@"f_logo"]];
}

-(void)calenderPrgram{
    viewProgram  = [[[NSBundle mainBundle]loadNibNamed:@"" owner:self options:nil]objectAtIndex:0];
    viewProgram.frame = self.view.frame;
    [self.view addSubview:viewProgram];
    viewProgram.table.delegate = self;
    viewProgram.table.dataSource = self;
    viewProgram.hidden = true;
}



-(void) festivalDetails
{
    // festival/festival_single.php
    
    NSDictionary *dict = @{@"uid":UserID, @"id":F_ID};
    
    SVHUD_START
    [WebServiceCalls POST:@"festival/festival_single.php" parameter:dict completionBlock:^(id JSON, WebServiceResult result)
     {
         SVHUD_STOP
         NSLog(@"%@", JSON);
         
         if ([JSON[@"success"] integerValue] == 1){
             fest_Dict = JSON[@"festivals"][0];
             
             lblAddLine2.text = [NSString stringWithFormat:@"%@ | %@",fest_Dict[@"city"],fest_Dict[@"place_name"]];
             lblStarCount.text = [Helper getStringORZero:fest_Dict[@"Avg_rating"]];
             viewStar.rating = [[Helper getStringORZero:fest_Dict[@"Avg_rating"]] integerValue];

         }else{
             [WebServiceCalls alert:JSON[@"message"]];
         }
     }];
}

-(void)get_Fest_Exibitors
{
    // FETIVL PRODUCER
    // http://allcool.pl/api_ios/festival/festival_categories_beer.php?fcid=4&uid=1
    
    NSString *url = [NSString stringWithFormat:@"festival/festival_producer.php"];
    
    SVHUD_START
    [WebServiceCalls POST:url parameter:@{@"id":F_ID} completionBlock:^(id JSON, WebServiceResult result)
     {
         //SVHUD_STOP
         NSLog(@"%@", JSON);
         
         @try
         {
             if ([JSON[@"success"] integerValue] == 1)
             {
                 arrExibitors = JSON[@"festivalsproducer"];
                 [tblViewFest reloadData];
             }
             else
             {
                 arrExibitors = @[];
                 /// [WebServiceCalls alert:@"Unable to fetch data. try again"];
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

-(void) get_Fest_Prog
{
    // http://allcool.pl/api_ios/festival/festival_programs.php?id=4
    
    NSString *url = [NSString stringWithFormat:@"festival/festival_programs.php?id=%@", F_ID];
    
    SVHUD_START
    [WebServiceCalls GET:url parameter:nil completionBlock:^(id JSON, WebServiceResult result)
     {
         NSLog(@"%@", JSON);
         
         @try
         {
             if ([JSON[@"success"] integerValue] == 1)
             {
                 arrProg = JSON[@"festivalsprogram"];
             }
             else
             {
                 arrProg = @[];
              //   [WebServiceCalls alert:@"Unable to fetch data. try again"];
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

-(void)get_Fest_Rating
{
    // http://allcool.pl/api_ios/festival/festival_rating.php?id=4
    
    NSString *url = [NSString stringWithFormat:@"festival/festival_rating.php?id=%@", F_ID];

    SVHUD_START
    [WebServiceCalls GET:url parameter:nil completionBlock:^(id JSON, WebServiceResult result)
     {
         //SVHUD_STOP
         NSLog(@"%@", JSON);
         
         @try
         {
             if ([JSON[@"success"] integerValue] == 1){
                 arrRating = JSON[@"comment"];
             }
             else {
                 arrRating = @[];
                 //[WebServiceCalls alert:@"Unable to fetch data. try again"];
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

-(void)get_Fest_Category
{
    
    NSString *url = [NSString stringWithFormat:@"festival/festival_categories?fid=%@", F_ID];

    SVHUD_START
    [WebServiceCalls GET:url parameter:nil completionBlock:^(id JSON, WebServiceResult result)
     {
         SVHUD_STOP
         NSLog(@"%@", JSON);
         
         @try
         {
             if ([JSON[@"success"] integerValue] == 1)
             {
                 arrCategory = JSON[@"festivalsprogram"];
                 //[tblViewFest reloadData];
             }
             else
             {
                 arrCategory = @[];
                 //[WebServiceCalls alert:@"Unable to fetch data. try again"];
             }
         }
         @catch (NSException *exception)
         {
         }
         @finally
         {
             SVHUD_STOP
         }
     }];
}

- (IBAction)tabBtnClk:(UIButton *)sender
{
    tag = sender.tag;
    
    for (int i=0; i<5; i++)
    {
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView = arrImgName[i];
        imgView.image = [UIImage imageNamed:arrImgDefault[i]];
        
        UILabel *lbl = [[UILabel alloc] init];
        lbl = arrLblName[i];
        lbl.textColor = [UIColor darkGrayColor];
    }
    
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView = arrImgName[sender.tag];
    imgView.image = [UIImage imageNamed:arrImgSelected[sender.tag]];
    
    UILabel *lbl = [[UILabel alloc] init];
    lbl = arrLblName[sender.tag];
    lbl.textColor = [UIColor colorWithRed:171/255.0 green:0/255.0 blue:0/255.0 alpha:1];
    
    if (sender.tag == 2)
    {
        imgMapPreiew.hidden = NO;
        tblViewFest.hidden = YES;
    }
    else
    {
        imgMapPreiew.hidden = YES;
        tblViewFest.hidden = NO;
        
        [tblViewFest reloadData];
    }
}

#pragma mark Table

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tag == 0)
    {
        return 60.0;
    }
    else if (tag == 1)
    {
        return 50.0;
    }
    else if (tag == 3)
    {
        return 85;
    }
    else
    {
        return 45.0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tag == 0)
    {
        return arrExibitors.count;
    }
    else if (tag == 1)
    {
        return arrProg.count;
    }
    else if (tag == 3)
    {
        return arrRating.count;
    }
    else
    {
        return arrCategory.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tag == 0) {
        ExibitorTVCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"FestCell" owner:self options:nil]objectAtIndex:tag];
        
        
        [Helper setImageOnPBotal:cell.imgPic url:arrExibitors[indexPath.row][@"image"]];
        cell.lblTitle.text = [Helper getString:arrExibitors[indexPath.row][@"producer_name"]];
        
        return cell;
    } else if (tag == 1) {
        ProgramTVCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"FestCell" owner:self options:nil]objectAtIndex:tag];
        
        cell.lblNo.text = [NSString stringWithFormat:@"%@", arrProg[indexPath.row][@"no"]];
        cell.lblDate_Days.text = [NSString stringWithFormat:@"%@ | %@", arrProg[indexPath.row][@"dat"], arrProg[indexPath.row][@"days"]];
        
        return cell;
    } else if (tag == 3) {
        
        
        RatingCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"Cells" owner:self options:nil]objectAtIndex:3];
        
        NSDictionary *dict = arrRating[indexPath.row];
        cell.lblUserName.text = [NSString stringWithFormat:@"%@",dict[@"name"]];
        cell.lblDateTime.text = [NSString stringWithFormat:@"%@",dict[@"dat"]];
        cell.lblReview.text = [NSString stringWithFormat:@"%@",dict[@"comment"]];

        cell.viewRating.rating = [dict[@"rating"] integerValue];
       
        
        return cell;
    } else {
        CategoryTVCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"FestCell" owner:self options:nil]objectAtIndex:3];
        
        cell.lblMsz.text = arrCategory[indexPath.row][@"message"];
        
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tag == 0){
        
        BraveryVC *obj = [[[NSBundle mainBundle]loadNibNamed:@"Bravery" owner:self options:nil] objectAtIndex:0];
        obj.infoDic =  arrExibitors[indexPath.row];
        [self.navigationController pushViewController:obj animated:YES];
    }else if(tag == 1){
        viewProgram.hidden = false;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)tapButtonOption:(id)sender {
    
    UIAlertController * view=   [UIAlertController
                                 alertControllerWithTitle:@""
                                 message:@""
                                 preferredStyle:UIAlertControllerStyleActionSheet];
    
    if ([fest_Dict[@"festival_visited"] integerValue] != 1)
    {
        UIAlertAction* online = [UIAlertAction
                                 actionWithTitle:@"Odwiedzony"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     // api_ios/festival/festival_visited.php
                                     
                                     NSDictionary *dict = @{@"uid":UserID, @"fid":F_ID};
                                     [self Api_URL:@"festival/festival_visited.php" Data:dict];
                                     
                                     [view dismissViewControllerAnimated:YES completion:nil];
                                 }];
        
        [online setValue:[[UIImage imageNamed:@"flag_op"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forKey:@"image"];

        [view addAction:online];
    }
    
    if ([fest_Dict[@"fav_festival"] integerValue] != 1)
    {
        UIAlertAction* offline = [UIAlertAction
                                  actionWithTitle:@"Ulubiony"
                                  style:UIAlertActionStyleDefault
                                  handler:^(UIAlertAction * action)
                                  {
                                      // api_ios/festival/favourite_festival.php
                                      
                                      NSDictionary *dict = @{@"uid":UserID, @"fid":F_ID};
                                      [self Api_URL:@"festival/favourite_festival.php" Data:dict];
                                      
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
                           style:UIAlertActionStyleDestructive
                           handler:^(UIAlertAction * action)
                           {
                               ViewAddRatingTobotal *view1 = [[[NSBundle mainBundle] loadNibNamed:@"View" owner:self options:nil]objectAtIndex:1];
                               view1.frame = CGRectMake(0, 0, WIDTH, HEIGHT);
                               view1.isF_ID_Vid = 1;
                               view1.FID = F_ID;
                               view1.selfBack = self;
                               view1.delegate = self;
                               [self.view addSubview:view1];
                               
                               [view dismissViewControllerAnimated:YES completion:nil];
                               
                           }];
    
    
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:@"Cancel"
                             style:UIAlertActionStyleCancel
                             handler:^(UIAlertAction * action)
                             {
                                 
                             }];
    
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
             [self.navigationController.view makeToast:JSON[@"message"]];

             // [WebServiceCalls alert:JSON[@"message"]];
             [self festivalDetails];
         }
         else
         {
             [WebServiceCalls alert:JSON[@"message"]];
         }
     }];
}

@end
