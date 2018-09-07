//
//  CommentsVC.m
//  AllCool.pl
//
//  Created by Sanjay on 17/01/18.
//  Copyright © 2018 Sanjay. All rights reserved.
//

#import "CommentsVC.h"

@interface CommentsVC ()
{
    
    IBOutlet UIView *viewTextField;
    IBOutlet UITextField *txtComment;
    IBOutlet UITableView *table;
 
    NSMutableArray *arrayData;
    CGPoint point;
    
}
@end

@implementation CommentsVC

- (void)viewDidLoad {

    [super viewDidLoad];
    [self getComments];
    point = viewTextField.center;
    txtComment.delegate = self;

}

-(void)getComments{
    
    NSString *url = [NSString stringWithFormat:@"vendorss/get_wallpostcomment.php?wallid=%@",_infoPost[@"id"]];
    SVHUD_START
    [WebServiceCalls POST:url parameter:nil completionBlock:^(id JSON, WebServiceResult result) {
        SVHUD_STOP
        // NSLog(@"%@", JSON);
        @try
        {
            if ([JSON[@"success"] integerValue] == 1)  {
          
                arrayData = JSON[@"comment"];
                table.delegate = self;
                table.dataSource = self;
                [table reloadData];
                
            } else {
                [WebServiceCalls alert:JSON[@"message"]];
            }
        }
        @catch (NSException *exception){  }
        @finally{  }
    }];
    
}
- (IBAction)tapBack:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//http://allcool.pl/api_ios/vendorss/get_wallpostcomment.php
//http://allcool.pl/api_ios/vendorss/add_comment.php

- (IBAction)clickToPostComment:(id)sender {

    if ([[Helper trimString:txtComment.text] length] > 0){
        NSDictionary *param = @{@"userid":UserID,
                                @"wallid":[Helper getString:_infoPost[@"id"]],
                                @"comment":txtComment.text};
        SVHUD_START
        [WebServiceCalls POST:@"vendorss/add_comment.php" parameter:param completionBlock:^(id JSON, WebServiceResult result) {
            
            SVHUD_STOP
            NSLog(@"%@", JSON);
            @try
            {
                if ([JSON[@"success"] integerValue] == 1) {
                    
                } else
                {
                    [WebServiceCalls alert:JSON[@"message"]];
                }
            }
            @catch (NSException *exception){  }
            @finally{  }
        }];
        
    }else{
        [Helper makeToast:@"Enter comment first."];
    }
}




#pragma mark Table

-(CGFloat)tableView:(UITableView* )tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
        return 70;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arrayData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"CellPT" owner:self options:nil]objectAtIndex:1];
    
     NSDictionary *dic = [arrayData objectAtIndex:indexPath.row];
    
    UILabel *lblName = [cell viewWithTag:1];
    UILabel *lblCommnt = [cell viewWithTag:3];
    UIImageView *img = [cell viewWithTag:2];
  
    lblName.text = [Helper getString:dic[@"username"]];
    lblCommnt.text = [Helper getString:dic[@"comment"]];
 
    [img sd_setImageWithURL:[NSURL URLWithString:[Helper getString:dic[@"usr_img"]]] placeholderImage:[UIImage imageNamed:@"noimage.jpg"]];

    
    return cell;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
   HIDE_KEY
    return true;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    return YES;
}


- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    [self.view endEditing:YES];
    viewTextField.center  = point;

    return YES;
}


- (void)keyboardDidShow:(NSNotification *)notification
{
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    viewTextField.center = CGPointMake(viewTextField.center.x, point.y-keyboardSize.height);
}


-(void)keyboardDidHide:(NSNotification *)notification
{
    viewTextField.center  = point;
}

HIDE_KEY_ON_TOUCH
@end
