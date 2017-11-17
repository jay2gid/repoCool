//
//  ViewAddRatingTobotal.m
//  AllCool.pl
//
//  Created by Sanjay on 26/09/17.
//  Copyright © 2017 Sanjay. All rights reserved.
//

#import "ViewAddRatingTobotal.h"

@implementation ViewAddRatingTobotal

@synthesize BID,delegate, FID, VID, isF_ID_Vid;

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    txtName.text = User_Name;
    txtEmail.text = User_Email;
    
    txtComment.delegate  = self;
    txtNameVender.delegate  = self;
    txtAddressVender.delegate  = self;
}

- (IBAction)btnSendClk:(id)sender
{
    if (txtComment.text.length > 0)
    {
        if (isF_ID_Vid != 1)
        {
            [self add_Comment];
        }
        else
        {
            [self add_Comment2];
        }
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

-(void) add_Comment2
{
    
    NSString *star = [NSString stringWithFormat:@"%ld", viewStarRating.rating];
    
    NSString *ID, *url;
    NSDictionary *dict;

    if (FID)
    {
        // api_ios/festival/festival_review.php

        ID = FID;
        url = @"festival/festival_review.php";
        dict = @{@"uid":UserID, @"fid":ID, @"rating":star, @"comment":txtComment.text};
    }
    else
    {
        // >> http://allcool.pl/api_ios/vendorss/rat_brewery.php
        
        ID = VID;
        url = @"vendorss/rat_brewery.php";
        dict = @{@"userid":UserID, @"pid":ID, @"name":User_Name, @"email":User_Email, @"rating":star, @"comment":txtComment.text};
    }
    
    SVHUD_START
    [WebServiceCalls POST:url parameter:dict completionBlock:^(id JSON, WebServiceResult result)
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



#pragma mark Suggest Vender API
/// Suggest Vender API

- (IBAction)tapSuggestVender:(id)sender
{
    
    
    if (txtNameVender.text.length > 0 && txtAddressVender.text.length > 0)
    {
        NSDictionary *dict = @{@"endusername":UserID,
                               @"endemail":User_Email,
                               @"vendor_name":txtNameVender.text,
                               @"v_address":txtAddressVender.text};
        
        
        SVHUD_START
        [WebServiceCalls POST:@"vendorss/suggest_vendor.php" parameter:dict completionBlock:^(id JSON, WebServiceResult result)
    
    NSDictionary *dict = @{@"endusername":UserID,
                           @"endemail":User_Email,
                           @"vendor_name":txtNameVender.text,
                           @"v_address":txtAddressVender.text};
   
    SVHUD_START
    [WebServiceCalls POST:@"vendorss/suggest_vendor.php" parameter:dict completionBlock:^(id JSON, WebServiceResult result)
     {
         SVHUD_STOP
         NSLog(@"%@", JSON);
         @try
         {
             if([JSON[@"success"] integerValue] == 1)
             {
                 [self removeFromSuperview];
                 [self.selfBack.navigationController.view makeToast:@"Data Submitted"];
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
    
}




@end
