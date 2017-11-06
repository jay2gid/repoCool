//
//  FavBearVC.m
//  AllCool.pl
//
//  Created by Sanjay on 07/09/17.
//  Copyright © 2017 Sanjay. All rights reserved.
//

#import "FavBearVC.h"
#import "BotalVC.h"
#import "BearCell.h"

@interface FavBearVC ()<UITableViewDataSource,UITableViewDelegate>
{
    ViewAddDodaj *viewAddNote;
    int index;
    NSString *bid;
    NSMutableArray *arrBeer;
}
@end

@implementation FavBearVC


- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (_isBack)
    {
        GET_HEADER_VIEW_WITH_BACK
        header.title.text = @"Piwa spróbowane";
    }
    else
    {
        GET_HEADER_VIEW
        header.title.text = @"Ulubione piwa";
    }

    [self get_Data];
}

-(void)get_Data
{
    // http://allcool.pl/api_ios/wishlist_favourite_record_beer.php
    
    SVHUD_START
    NSDictionary *dict = @{@"uid":UserID};
    NSString *url = @"wishlist_favourite_record_beer.php";
   
    if (_apiTag == 1) {
        url = @"get_beertasted.php";
    }
   
    
    [WebServiceCalls POST:url parameter:dict completionBlock:^(id JSON, WebServiceResult result)
     {
         SVHUD_STOP
         NSLog(@"%@", JSON);
         
         @try
         {
             if ([JSON[@"success"] integerValue] == 1)
             {
                 if(JSON[@"beer_details"])
                 {
                     arrBeer = [NSMutableArray array];
                     
                     for (int i = 0; i < [JSON[@"beer_details"] count]; i++) {
                         
                         NSString *idstr =  [NSString stringWithFormat:@"%@",JSON[@"beer_details"][i][@"id"]];
                         if (![idstr isEqualToString:@"<null>"])
                         {
                             [arrBeer addObject: JSON[@"beer_details"][i]];
                         }
                     }
                     
                     [tblViewBeer reloadData];
                 }
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Table

-(CGFloat)tableView:(UITableView* )tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 140;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrBeer.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BearCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"Cells" owner:self options:nil]objectAtIndex:0];
    
    cell.btnDaduj.tag = indexPath.row;
    
    
    [cell.imgBeerLogo sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",arrBeer[indexPath.row][@"image"]]] placeholderImage:[UIImage imageNamed:@"noimage.jpg"]];
    
    cell.lblTitle.text = arrBeer[indexPath.row][@"title"];
    
    NSInteger star_count = [arrBeer[indexPath.row][@"Avg_rating"] integerValue];
    cell.viewStarRating.rating = star_count;
    
    cell.lbl_IBU_ABV_BLG.text = [NSString stringWithFormat:@"IBU %@ | ABV %@ | BLG %@", arrBeer[indexPath.row][@"ibu"], arrBeer[indexPath.row][@"alcohole_per"], arrBeer[indexPath.row][@"ekstrakt"]];
    
    [cell.btnDaduj addTarget:self action:@selector(methodDauj:) forControlEvents:UIControlEventTouchUpInside];
    cell.btnDaduj.tag = indexPath.row;
    [cell.btnNottaki addTarget:self action:@selector(methodNottaki:) forControlEvents:UIControlEventTouchUpInside];
    cell.btnNottaki.tag = indexPath.row;
    [cell.btnKasuj addTarget:self action:@selector(methodKasuj:) forControlEvents:UIControlEventTouchUpInside];
    cell.btnKasuj.tag = indexPath.row;
    
    if (_apiTag == 1)
    {
        cell.btnKasuj.hidden = true;
        cell.btnDaduj.frame = cell.btnKasuj.frame;
    }
        
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BotalVC *OBJ = [self.storyboard instantiateViewControllerWithIdentifier:@"BotalVC"];
    OBJ.dictBeer = arrBeer[indexPath.row];
    [self.navigationController pushViewController:OBJ animated:YES];
}

-(void)methodDauj:(UIButton*)sender
{
    index = (int)sender.tag;
    bid = [NSString stringWithFormat:@"%@",arrBeer[sender.tag][@"id"]];
    viewAddNote = [[[NSBundle mainBundle] loadNibNamed:@"View" owner:self options:nil]objectAtIndex:0];
    viewAddNote.frame = CGRectMake(0, 0, WIDTH, HEIGHT);
    [self.view addSubview:viewAddNote];
    [viewAddNote.btnOK addTarget:self action:@selector(tapAddNote) forControlEvents:UIControlEventTouchUpInside];
}

-(void)tapAddNote
{
    if (viewAddNote.txtNote.text.length > 0)
    {
        NSDictionary *param =@{@"uid": UserID, @"bid":bid,   @"comment":viewAddNote.txtNote.text };
        
        SVHUD_START
        [WebServiceCalls POST:@"add_notes.php" parameter:param completionBlock:^(id JSON, WebServiceResult result)
         {
             [viewAddNote removeFromSuperview];
             SVHUD_STOP
             
             if (result == WebServiceResultFail) {

                 if (JSON)
                 {
                     [self.navigationController.view makeToast:JSON[@"message"]];
                 }
             }
             else
             {
                 if ([JSON[@"success"] integerValue] == 1)
                 {
                     [self.navigationController.view makeToast:@"Note Added"];
                 }
                 else
                 {
                     [self.navigationController.view makeToast:@"Error"];
                 }
             }
         }];
    }
    else
    {
        [self.navigationController.view makeToast:@"Enter Note First."];
        // [WebServiceCalls alert:@"Enter Note First."];
    }
}

-(void)methodNottaki:(UIButton *)sender
{
    ViewNotesList *obj = [[[NSBundle mainBundle] loadNibNamed:@"ViewNotesList" owner:self options:nil] objectAtIndex:0];
    obj.selfBack = self;
    obj.tagFOR = 1;
    obj.dict = arrBeer[sender.tag];
    [self.view addSubview:obj];
}

-(void)methodKasuj:(UIButton *)sender
{
    bid = [NSString stringWithFormat:@"%@",arrBeer[sender.tag][@"mid"]];
           
    UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Sure want to delete from list" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"Yes"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action)
                                {
                                    
                                    NSDictionary *param =@{@"mid": bid, @"del_concept":@"1" };
                                    
                                    SVHUD_START
                                    [WebServiceCalls POST:@"deletefavbeer.php" parameter:param completionBlock:^(id JSON, WebServiceResult result)
                                     {
                                         [viewAddNote removeFromSuperview];
                                         SVHUD_STOP
                                         
                                         if (result == WebServiceResultFail) {
                                             
                                             if (JSON)
                                             {
                                                 [self.navigationController.view makeToast:JSON[@"message"]];
                                             }
                                         }
                                         else
                                         {
                                             if ([JSON[@"success"] integerValue] == 1)
                                             {
                                                 [self.navigationController.view makeToast:@"Favorite Item Deleted"];
                                                 // SVHUD_START
                                                 [arrBeer removeObjectAtIndex:index];
                                                 [tblViewBeer reloadData];
                                             }
                                             else
                                             {
                                                 [self.navigationController.view makeToast:@"Error"];
                                             }
                                         }
                                     }];
                                    
                                }];
    
    UIAlertAction* noButton = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)  {  }];
   
    [alert addAction:yesButton];
    [alert addAction:noButton];
    
    [self presentViewController:alert animated:YES completion:nil];
}
@end
