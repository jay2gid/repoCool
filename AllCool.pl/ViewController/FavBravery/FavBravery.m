//
//  FavBravery.m
//  AllCool.pl
//
//  Created by Sanjay on 07/09/17.
//  Copyright © 2017 Sanjay. All rights reserved.
//

#import "FavBravery.h"
#import "BraveryCell.h"
@interface FavBravery ()
{
    IBOutlet UITableView *tblList;
    NSMutableArray  *arrList;
    
    ViewAddDodaj *viewAddNote;
    int index;
    NSString *bid;
}
@end

@implementation FavBravery

- (void)viewDidLoad {
    [super viewDidLoad];

    if (_isBack)
    {
        GET_HEADER_VIEW_WITH_BACK
        if (_apiTag == 1) {
            header.title.text = @"Odwiedzone browary";

        }
        else if (_apiTag == 2) {
            header.title.text = @"Ulubione browary";
        }
    }
    else
    {
        GET_HEADER_VIEW
        header.title.text = @"Ulubione bary";
    }

    [self getData];
    
    
}
-(void)getData
{
    SVHUD_START
    NSDictionary *dict = @{@"uid":UserID};
    NSString *url = @"wishlist_favourite_record_vendor.php";
    
    if (_apiTag == 1) {
        url= @"get_brewery_visited.php";
    }
    else if (_apiTag == 1) {
        url = @"wishlist_favourite_record_brewery.php";
    }
    

    
    
    [WebServiceCalls POST:url parameter:dict completionBlock:^(id JSON, WebServiceResult result)
     {
         SVHUD_STOP
         NSLog(@"%@", JSON);
         @try
         {
             if ([JSON[@"success"] integerValue] == 1)
             {
                 arrList = [NSMutableArray arrayWithArray:JSON[@"user_details"]] ;
                 [tblList reloadData];
             }
             else
             {
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
    return arrList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BraveryCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"Cells" owner:self options:nil]objectAtIndex:1];
    

    cell.lbl_name.text = [NSString stringWithFormat:@"%@",arrList[indexPath.row][@"name"]];
    cell.lblType.text = [NSString stringWithFormat:@"%@",arrList[indexPath.row][@"business_name"]];
    cell.lblCity.text = [NSString stringWithFormat:@"%@",arrList[indexPath.row][@"street_name"]];
    cell.lblAvgRating.text = [NSString stringWithFormat:@"%@",arrList[indexPath.row][@"Avg_rating"]];

    [cell.imageBravery sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",arrList[indexPath.row][@"img"]]]   placeholderImage:[UIImage imageNamed:@"noimage.jpg"]];

    
    [cell.btnDaduj addTarget:self action:@selector(methodDauj:) forControlEvents:UIControlEventTouchUpInside];
    cell.btnDaduj.tag = indexPath.row;
    [cell.btnNottaki addTarget:self action:@selector(methodNottaki:) forControlEvents:UIControlEventTouchUpInside];
    cell.btnNottaki.tag = indexPath.row;
    [cell.btnKasuj addTarget:self action:@selector(methodKasuj:) forControlEvents:UIControlEventTouchUpInside];
    cell.btnKasuj.tag = indexPath.row;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  //    BotalVC *OBJ = [self.storyboard instantiateViewControllerWithIdentifier:@"BotalVC"];
  //    OBJ.dictBeer = arrBeer[indexPath.row];
  //    [self.navigationController pushViewController:OBJ animated:YES];
}

-(void)methodDauj:(UIButton*)sender
{
    index = (int)sender.tag;
    bid = [NSString stringWithFormat:@"%@",arrList[sender.tag][@"id"]];
    viewAddNote = [[[NSBundle mainBundle] loadNibNamed:@"View" owner:self options:nil]objectAtIndex:0];
    viewAddNote.frame = CGRectMake(0, 0, WIDTH, HEIGHT);
    [self.view addSubview:viewAddNote];
    [viewAddNote.btnOK addTarget:self action:@selector(tapAddNote) forControlEvents:UIControlEventTouchUpInside];
}

-(void)tapAddNote
{
    if (viewAddNote.txtNote.text.length > 0)
    {
        NSDictionary *param =@{@"uid": UserID, @"vid":bid,   @"comment":viewAddNote.txtNote.text };
        
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
    obj.tagFOR = 2;
    obj.dict = arrList[sender.tag];
    [self.view addSubview:obj];
}

-(void)methodKasuj:(UIButton *)sender
{
    bid = [NSString stringWithFormat:@"%@",arrList[sender.tag][@"mid"]];
    
    UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Sure want to delete from list" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"Yes"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action)
                                {
                                    
                                    NSDictionary *param =@{@"mid": bid, @"del_concept":@"2" };
                                    
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
                                                 [arrList removeObjectAtIndex:index];
                                                 [tblList reloadData];
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
