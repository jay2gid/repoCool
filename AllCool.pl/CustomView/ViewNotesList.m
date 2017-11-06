//
//  ViewNotesList.m
//  AllCool.pl
//
//  Created by Sanjay on 13/10/17.
//  Copyright © 2017 Sanjay. All rights reserved.
//

#import "ViewNotesList.h"

@implementation ViewNotesList
{
    NSArray *arrayData;
}
- (void)drawRect:(CGRect)rect {

    self.frame = CGRectMake(0, HEIGHT, WIDTH, HEIGHT);
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.frame = CGRectMake(0, 0, WIDTH, HEIGHT);
        
    } completion:^(BOOL finished) {
        
    }];
    
    NSDictionary *param;
    
    if (_tagFOR == 1)
    {
      param =@{@"uid": UserID, @"bid":[NSString stringWithFormat:@"%@",_dict[@"id"]] };
    }
    if (_tagFOR == 2)
    {
        param =@{@"uid": UserID, @"vid":[NSString stringWithFormat:@"%@",_dict[@"id"]] };
    }
    
    SVHUD_START
    [WebServiceCalls POST:@"get_notes.php" parameter:param completionBlock:^(id JSON, WebServiceResult result)
     {
         SVHUD_STOP
         NSLog(@"%@", JSON);
         
         @try
         {
             if ([JSON[@"success"] integerValue] == 1)
             {
                 arrayData = [NSMutableArray arrayWithArray:JSON[@"notes_details"]] ;
               
                 _tableList.delegate = self;
                 _tableList.dataSource = self;
                 [_tableList reloadData];
                 
             }
             else
             {
                 [self.selfBack.navigationController.view makeToast:@"Notes not found."];
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

- (IBAction)tapBack:(id)sender {
    
    [UIView animateWithDuration:0.3 animations:^{
       
        self.frame = CGRectMake(0, HEIGHT, WIDTH, HEIGHT);
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
    }];
}

#pragma mark Table

-(CGFloat)tableView:(UITableView* )tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 81;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrayData.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"ViewNotesList" owner:self options:nil]objectAtIndex:1];
    
    UITextView *txt = [cell viewWithTag:1];
    txt.text = [NSString stringWithFormat:@"%@",arrayData[indexPath.row][@"comment"]];
    
    UILabel *lblDate = [cell viewWithTag:2];
    lblDate.text = [NSString stringWithFormat:@"Date : %@",arrayData[indexPath.row][@"dat"]];
  
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

@end
