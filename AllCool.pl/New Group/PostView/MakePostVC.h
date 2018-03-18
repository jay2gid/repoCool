//
//  MakePostVC.h
//  AllCool.pl
//
//  Created by Sanjay on 17/12/17.
//  Copyright © 2017 Sanjay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MakePostVC : UIViewController<APPhotoPickerDelegate,UITextViewDelegate> {
  
    IBOutlet UILabel *lblPlaceHolder;
    IBOutlet UILabel *lblName;
    IBOutlet UITextView *txtPostText;
    
    IBOutlet UIImageView *imgProfile;
    IBOutlet UIImageView *imgForPost;
    
    NSData *dataImg;
}
@property  (nonatomic, strong) NSDictionary *infoPub;

@end
