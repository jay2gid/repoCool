//
//  ViewAddRatingTobotal.m
//  AllCool.pl
//
//  Created by Sanjay on 26/09/17.
//  Copyright © 2017 Sanjay. All rights reserved.
//

#import "ViewAddRatingTobotal.h"

@implementation ViewAddRatingTobotal

@synthesize BID,delegate;

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    txtName.text = User_Name;
    txtEmail.text = User_Email;
    
    txtComment.delegate  = self;
}

- (IBAction)btnSendClk:(id)sender
{
    if (txtComment.text.length > 0)
    {
        [self add_Comment];
    }
    else
    {
        [WebServiceCalls alert:@"Enter comment first."];
    }
}

-(void) add_Comment
{
    // http://allcool.pl/api_ios/festival/singlebeer_rating.php

    NSString *star = [NSString stringWithFormat:@"%ld", viewStarRating.rating];
    
    SVHUD_START
    NSDictionary *dict = @{@"uid":UserID,@"name":User_Name,@"bid":BID, @"rating":star, @"comment":txtComment.text, @"email":User_Email, @"type":[NSString stringWithFormat:@"%@",_dictBear[@"type"]]};
    
//    $uid = $_POST['uid'];
//    $bid = $_POST['bid'];
//    $name = $_POST['name'];
//    $email = $_POST['email'];
//    $rating = $_POST['rating'];
//    $comment = $_POST['comment'];
//    $type = $_POST['type'];
    
    [WebServiceCalls POST:@"vendorss/singlebeer_rating.php" parameter:dict completionBlock:^(id JSON, WebServiceResult result)
     {
         SVHUD_STOP
         NSLog(@"%@", JSON);
         @try
         {
             if ([JSON[@"success"] integerValue] == 1)
             {
                 [self removeFromSuperview];
                 [self.selfBack.navigationController.view makeToast:@"Rating Submitted"];
                 [delegate didSuccessRating];
             }
             else
             {
                 if (JSON[@"message"])
                     [WebServiceCalls alert:JSON[@"message"]];
                 
                 
             }
         }
         @catch (NSException *exception)
         {
            // [WebServiceCalls alert:@"Unable to fetch data. try again"];
         }
         @finally
         {
         }
     }];
}

- (IBAction)tapCross:(id)sender
{
    [self removeFromSuperview];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
   if( textField.text.length == 30)
       return false;
    
   else return true;
}


@end
