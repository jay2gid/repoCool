//
//  FestivalListVC.m
//  AllCool.pl
//
//  Created by Sanjay on 08/09/17.
//  Copyright © 2017 Sanjay. All rights reserved.
//

#import "FestivalListVC.h"
#import "FestListTVCell.h"

@interface FestivalListVC ()
{
    IBOutlet UITableView *tableList;
    IBOutlet UIButton *btnRight;
    IBOutlet UIButton *btnLeft;
    IBOutlet UIView *viewUpButtons;
    
    int tag;
    
    NSArray *arrFest, *arrNewFest, *arrOldFest;
}
@end

@implementation FestivalListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (_isBack)
    {
        GET_HEADER_VIEW_WITH_BACK
        if (_apiTag == 1) {
            header.title.text = @"Ulubione festiwale";
        }
        else if (_apiTag == 2) {
            header.title.text = @"Odwiedzone festiwale";
        }

        viewUpButtons.hidden = true;
        tableList.frame = CGRectMake(0, 0, WIDTH, HEIGHT - 64);
   
    }
    else
    {
        GET_HEADER_VIEW
        header.title.text = @"Festiwale piwne";
    }
    viewUpButtons.layer.borderColor = APP_COLOR_RED.CGColor;
    viewUpButtons.layer.borderWidth = 1;
    
    tag = 1;
    
    [self get_New_Festival];
    [self get_Old_Festival];
    
    arrFest = arrNewFest;
    [tableList reloadData];
    
}

-(void) get_New_Festival
{
    SVHUD_START
    
    NSString *url = @"festival/new_in_festival.php";

    if (_apiTag == 1) {
        url= [NSString stringWithFormat:@"festival/get_favourite_festival.php?uid=%@",UserID];
    }
    else if (_apiTag == 2) {
        url= [NSString stringWithFormat:@"festival/get_visited_festival.php?uid=%@",UserID];
    }
    
    [WebServiceCalls GET:url parameter:nil completionBlock:^(id JSON, WebServiceResult result)
     {
         SVHUD_STOP
         NSLog(@"%@", JSON);
         
         @try
         {
             if ([JSON[@"success"] integerValue] == 1)
             {
                 arrNewFest = JSON[@"festivals"];
                 [tableList reloadData];
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

-(void) get_Old_Festival
{
    // http://allcool.pl/api_ios/festival/out_festival.php
    
    SVHUD_START
    [WebServiceCalls GET:@"festival/out_festival.php" parameter:nil completionBlock:^(id JSON, WebServiceResult result)
     {
         SVHUD_STOP
         NSLog(@"%@", JSON);
         
         @try
         {
             if ([JSON[@"success"] integerValue] == 1)
             {
                 arrOldFest = JSON[@"festivals"];
                 [tableList reloadData];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)tapButtons:(UIButton *)sender {
    
    btnLeft.backgroundColor = CLEAR_COLOR;
    btnRight.backgroundColor = CLEAR_COLOR;
    [btnRight setTitleColor:APP_COLOR_RED forState:UIControlStateNormal];
    [btnLeft setTitleColor:APP_COLOR_RED forState:UIControlStateNormal];
    
    sender.backgroundColor = APP_COLOR_RED;
    [sender setTitleColor:WHITE_COLOR forState:UIControlStateNormal];
    
    tag = (int)sender.tag;
    [tableList reloadData];
}

#pragma mark Table

-(CGFloat)tableView:(UITableView* )tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tag == 1)
    {
        arrFest = arrNewFest;
        
        return arrFest.count;
    }
    
    arrFest = arrOldFest;
    
    return arrFest.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FestListTVCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"Cells" owner:self options:nil]objectAtIndex:2];
    
    [cell.imgFestLogo sd_setImageWithURL:[NSURL URLWithString:arrFest[indexPath.row][@"f_logo"]] placeholderImage:[UIImage imageNamed:@"noimage.jpg"]];
    
    cell.lblFestName.text = arrFest[indexPath.row][@"f_name"];
    
    cell.lblPlaceName.text = [NSString stringWithFormat:@"%@ %@, %@", arrFest[indexPath.row][@"street_name"], arrFest[indexPath.row][@"street_num"], arrFest[indexPath.row][@"city"]];
    
    cell.lblDates.text = [NSString stringWithFormat:@"%@-%@", arrFest[indexPath.row][@"start_Date"], arrFest[indexPath.row][@"end_Date"]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *storybord = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    FestivalViewVC *obj = [storybord instantiateViewControllerWithIdentifier:@"FestivalViewVC"];
    obj.F_ID = arrFest[indexPath.row][@"id"];
    [self.navigationController pushViewController:obj animated:YES];
}

@end
