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

@interface FestivalViewVC ()

@end

@implementation FestivalViewVC
{
    NSArray *arrImgSelected, *arrImgDefault, *arrImgName, *arrLblName;
    
    NSInteger tag;
    
    NSArray *arrExibitors, *arrProg, *arrRating, *arrCategory;
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
    
    [self get_Fest_Exibitors];
    [self get_Fest_Prog];
    [self get_Fest_Rating];
    [self get_Fest_Category];
    
    [tblViewFest reloadData];
}

-(void) get_Fest_Exibitors
{
    // http://allcool.pl/api_ios/festival/festival_categories_beer.php?fcid=4&uid=1
    
    NSString *url = [NSString stringWithFormat:@"festival/festival_categories_beer.php?fcid=%@&uid=%@", F_ID, UserID];
    
    SVHUD_START
    [WebServiceCalls GET:url parameter:nil completionBlock:^(id JSON, WebServiceResult result)
     {
         //SVHUD_STOP
         NSLog(@"%@", JSON);
         
         @try
         {
             if ([JSON[@"success"] integerValue] == 1)
             {
                 arrExibitors = JSON[@"beer_details"];
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
         //SVHUD_STOP
         NSLog(@"%@", JSON);
         
         @try
         {
             if ([JSON[@"success"] integerValue] == 1)
             {
                 arrProg = JSON[@"festivalsprogram"];
                 [tblViewFest reloadData];
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

-(void) get_Fest_Rating
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
             if ([JSON[@"success"] integerValue] == 1)
             {
                 arrRating = JSON[@"beer_details"];
                 [tblViewFest reloadData];
             }
             else
             {
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

-(void) get_Fest_Category
{
    // http://allcool.pl/api_ios/festival/festival_review.php?id=4
    
    NSString *url = [NSString stringWithFormat:@"festival/festival_review.php?id=%@", F_ID];

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
                 [tblViewFest reloadData];
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
        return 65.0;
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
    if (tag == 0)
    {
        ExibitorTVCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"FestCell" owner:self options:nil]objectAtIndex:tag];
        
        [cell.imgPic sd_setImageWithURL:[NSURL URLWithString:arrExibitors[indexPath.row][@"image"]] placeholderImage:[UIImage imageNamed:@"noimage.jpg"]];
        
        cell.lblTitle.text = arrExibitors[indexPath.row][@"title"];
        
        return cell;
    }
    else if (tag == 1)
    {
        ProgramTVCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"FestCell" owner:self options:nil]objectAtIndex:tag];
        
        cell.lblNo.text = [NSString stringWithFormat:@"%@", arrProg[indexPath.row][@"no"]];
        cell.lblDate_Days.text = [NSString stringWithFormat:@"%@ | %@", arrProg[indexPath.row][@"dat"], arrProg[indexPath.row][@"days"]];
        
        return cell;
    }
    else if (tag == 3)
    {
        RatingTVCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"FestCell" owner:self options:nil]objectAtIndex:2];
        
        cell.lblName.text = arrRating[indexPath.row][@"name"];
        
        NSInteger star = [arrRating[indexPath.row][@"name"] integerValue];
        cell.viewStar.rating = star;
        
        cell.lblDate.text = arrRating[indexPath.row][@"dat"];
        
        return cell;
    }
    else
    {
        CategoryTVCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"FestCell" owner:self options:nil]objectAtIndex:3];
        
        cell.lblMsz.text = arrCategory[indexPath.row][@"message"];
        
        return cell;
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
    
    UIAlertAction* online = [UIAlertAction
                             actionWithTitle:@"Odwiedzony"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [view dismissViewControllerAnimated:YES completion:nil];
                             }];
    UIAlertAction* offline = [UIAlertAction
                              actionWithTitle:@"Ulubiony"
                              style:UIAlertActionStyleDefault
                              handler:^(UIAlertAction * action)
                              {
                                  [view dismissViewControllerAnimated:YES completion:nil];
                                  
                              }];
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
                               [view dismissViewControllerAnimated:YES completion:nil];
                               
                           }];
    
    
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:@"Cancel"
                             style:UIAlertActionStyleCancel
                             handler:^(UIAlertAction * action)
                             {
                                 
                             }];
    
    [online setValue:[[UIImage imageNamed:@"flag_op"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forKey:@"image"];
    [offline setValue:[[UIImage imageNamed:@"like_op"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forKey:@"image"];
    [doNotDistrbe setValue:[[UIImage imageNamed:@"star_op"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forKey:@"image"];
    [away setValue:[[UIImage imageNamed:@"star_op"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forKey:@"image"];
    
    [view addAction:online];
    [view addAction:offline];
    [view addAction:doNotDistrbe];
    [view addAction:away];
    [view addAction:cancel];
    
    [self presentViewController:view animated:YES completion:nil];
}


@end
