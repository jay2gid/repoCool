//
//  MakePostVC.m
//  AllCool.pl
//
//  Created by Sanjay on 17/12/17.
//  Copyright © 2017 Sanjay. All rights reserved.
//

#import "MakePostVC.h"

@interface MakePostVC ()

@end

@implementation MakePostVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    GET_HEADER_VIEW_WITH_BACK
    header.title.text = @"Post on pub";
    
    txtPostText.delegate = self;
    
    lblName.text = User_Name;
    [imgProfile sd_setImageWithURL:[NSURL URLWithString:USER_IMAGE_URL] placeholderImage:[UIImage imageNamed:@"noimage.jpg"]];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}



- (IBAction)tapOnCamera:(id)sender {
    [APPhotoLibrary sharedInstance].delegate = self;
    [[APPhotoLibrary sharedInstance]openPhotoFromCameraAndLibrary:self];
}


- (IBAction)tapSelectPicture:(id)sender
{
    [APPhotoLibrary sharedInstance].delegate = self;
    [[APPhotoLibrary sharedInstance]openPhotoFromCameraAndLibrary:self];
}


/////////    ****************  Post API  ****************  /////////////////

#pragma mark Post API

- (IBAction)tapPost:(id)sender {

    if ([[Helper trimString:txtPostText.text] length] == 0)
    {
        [WebServiceCalls warningAlert:@"Please enter post text first"];
        return;
    }
//    $vid = $_POST["vid"];
//    $uid = $_POST["uid"];
//    $username = $_POST["username"];
//    $post = $_POST["post"];
//    $image = basename($_FILES['file']['name']);
    

    NSDictionary *dict = [NSDictionary dictionary];
    if (!dataImg)
    {
        
        dict = @{@"vid":[Helper getString:_infoPub[@"id"]],
            @"uid":UserID,
            @"username":User_Name,
            @"post":txtPostText.text,
        };
        
        SVHUD_START
        [WebServiceCalls POST:@"vendorss/wallpost.php" parameter:dict completionBlock:^(id JSON, WebServiceResult result)
         {
             @try
             {
                 [Helper makeToast:JSON[@"message"]];

                 if ([JSON[@"success"] integerValue] == 1)
                 {
                     [self dismissViewControllerAnimated:true completion:nil];
                 }
             }
             @catch (NSException *exception){  }
             @finally{  }
             
             
             
         }];
        
    }
    else
    {
        dict = @{@"vid":[Helper getString:_infoPub[@"id"]],
                 @"uid":UserID,
                 @"username":User_Name,
                 @"post":txtPostText.text,
                 };
        SVHUD_START
        [WebServiceCalls POST:@"vendorss/wallpost.php" parameter:dict imageData:dataImg completionBlock:^(id JSON, WebServiceResult result)
         {
             
             @try
             {
                 [Helper makeToast:JSON[@"message"]];
                 SVHUD_START
                 if ([JSON[@"success"] integerValue] == 1)
                 {
                     [Helper makeToast:JSON[@"message"]];
                     [self dismissViewControllerAnimated:true completion:nil];
                 }
             }
             @catch (NSException *exception){  }
             @finally{  }
         }];
        
    }
}








#pragma mark app photo delegate

-(void)apActionSheetGetImage:(UIImage *)selectedPhoto{
    
    CGSize newSize = CGSizeMake(500,500);
    UIGraphicsBeginImageContext(newSize);
    [selectedPhoto drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    dataImg = UIImageJPEGRepresentation(newImage,0.1);
    [imgForPost setImage:newImage];
}

-(void)apActionSheetGetVideo:(NSURL *)selectedVideo{}
-(void)apActionSheetGetVideoThumbImage:(UIImage *)selectedVideoThumbImage{}


#pragma text view Delegate

- (void)textViewDidEndEditing:(UITextView *)theTextView
{
    if (![theTextView hasText])
    {
        lblPlaceHolder.hidden = NO;
    }
}

- (void) textViewDidChange:(UITextView *)textView
{
    if([[textView text] length] > 150) {
        textView.text = [textView.text substringWithRange:NSMakeRange(0, 150)];
    }
    
    if(![textView hasText]) {
        lblPlaceHolder.hidden = NO;
    }
    else{
        lblPlaceHolder.hidden = YES;
    }
}

@end
