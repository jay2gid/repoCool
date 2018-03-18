//
//  ActivityVC.m
//  AllCool.pl
//
//  Created by Sanjay on 04/01/18.
//  Copyright © 2018 Sanjay. All rights reserved.
//

#import "ActivityVC.h"
#import "CellAcfirst.h"
#import "CellActivity.h"
#import "ActivityDetail.h"
@interface ActivityVC (){
    IBOutlet UITableView *table;
    NSArray *arrayData;
    NSDictionary *completeResponce;

}
@end

@implementation ActivityVC

- (void)viewDidLoad {
    [super viewDidLoad];

    GET_HEADER_VIEW
    header.title.text = @"Activity";
  
    
    table.delegate = self;
    table.dataSource = self;
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:true];
    [self getMyActivityData];
}

-(void)getMyActivityData{
   
    NSDictionary *param =@{@"uid": UserID} ;
    
    SVHUD_START
    [WebServiceCalls POST:@"myactivity.php" parameter:param completionBlock:^(id JSON, WebServiceResult result)
     {
         SVHUD_STOP
         NSLog(@"%@", JSON);
         
         @try
         {
             [Helper makeToast:[Helper getString:JSON[@"message"]]];
             
             if ([JSON[@"success"] integerValue] == 1)
             {
                 if (JSON[@"recents_activity"]) {
                     arrayData = JSON[@"recents_activity"];
                     completeResponce = JSON;
                     [table reloadData];
                 }
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
}




#pragma mark Table

-(CGFloat)tableView:(UITableView* )tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return  284;
    }
    return 70;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
           return 1;
    }
    return arrayData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
     
        CellAcfirst *cell = [[[NSBundle mainBundle] loadNibNamed:@"CellActivity" owner:self options:nil]objectAtIndex:0];
        
        
        NSURL  *url = [NSURL URLWithString:[Helper getString:completeResponce[@"usr_img"]]];
        [cell.imgProfile sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"noimage.jpg"]];
        
        cell.lblPiwaCount.text = [Helper getString:completeResponce[@"user_beer_tested"]];
        cell.lblPunCount.text = [Helper getString:completeResponce[@"user_pub_visited"]];
        cell.lblBarowCount.text = [Helper getString:completeResponce[@"user_total_earn"]];
        cell.lblBrowerCount.text = [Helper getString:completeResponce[@"user_brewery_visited"]];
     
        return cell;
    }
    else {
        
        CellActivity *cell = [[[NSBundle mainBundle] loadNibNamed:@"CellActivity" owner:self options:nil]objectAtIndex:1];
        
        NSDictionary *dic = [arrayData objectAtIndex:indexPath.row];
        cell.lblDate.text = [Helper getString:dic[@"dat"]];
        NSString *activity_type = [Helper getString:dic[@"activity_type"]];
        
        NSString *msg = [Helper getString:dic[@"msg"]];
        NSString *name = [Helper getString:dic[@"name"]];
        NSString *detail = [NSString stringWithFormat:@"%@ %@",msg,name];
        
        NSMutableAttributedString *detailAtributed = [[NSMutableAttributedString alloc]initWithString:detail];
        
        [detailAtributed addAttribute:NSForegroundColorAttributeName
                                value:[UIColor darkGrayColor]
                                range:NSMakeRange(0, msg.length )];
        [detailAtributed addAttribute:NSForegroundColorAttributeName
                                value:[UIColor redColor]
                                range:NSMakeRange(msg.length + 1, name.length)];
        
        cell.lblDetail.attributedText = detailAtributed;
        cell.lblData.text =  [NSString stringWithFormat:@"(+%@ punktow)",[Helper getString:dic[@"point"]]];

        if ([activity_type isEqualToString:@"rate_vendor"] || [activity_type isEqualToString:@"rat_brewery"] || [activity_type isEqualToString:@"rate_beer"] || [activity_type isEqualToString:@"rate_festival"] ) {
            cell.lblTag.text = @"Zobacz / Edytuj";
        } else{
            cell.lblTag.text = @"";
        }
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
      
        NSDictionary *dic = [arrayData objectAtIndex:indexPath.row];
        NSString *activity_type = [Helper getString:dic[@"activity_type"]];

        if ([activity_type isEqualToString:@"rate_beer"] || [activity_type isEqualToString:@"rat_brewery"] || [activity_type isEqualToString:@"rate_vendor"] || [activity_type isEqualToString:@"vendor_wallpost"] ) {
            
            ActivityDetail *obj = [[ActivityDetail alloc]initWithNibName:@"ActivityDetail" bundle:nil];
            obj.infoDic = dic;
            [self.navigationController pushViewController:obj animated:YES];
        }
    }
  
}

@end
