//
//  ViewAddRatingTobotal.h
//  AllCool.pl
//
//  Created by Sanjay on 26/09/17.
//  Copyright © 2017 Sanjay. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ratingSuccessDelegate <NSObject>
-(void)didSuccessRating;
@end;


@interface ViewAddRatingTobotal : UIView <UITextFieldDelegate>
{
    IBOutlet ACFloatingTextfield *txtNameVender;
    IBOutlet ACFloatingTextfield *txtAddressVender;
    
}
@property (nonatomic, strong)IBOutlet ACFloatingTextfield *txtName;
@property (nonatomic, strong)IBOutlet ACFloatingTextfield *txtEmail;
@property (nonatomic, strong)IBOutlet ACFloatingTextfield *txtComment;
@property (nonatomic, strong)IBOutlet StarRatingControl *viewStarRating;

@property (nonatomic, strong) NSDictionary *dictBear;

@property (strong, nonatomic) id<ratingSuccessDelegate> delegate;


@property (nonatomic, strong) NSString *BID;
@property (nonatomic, strong) UIViewController *selfBack;

@property (nonatomic, strong) NSString *FID;
@property (nonatomic, strong) NSString *VID;
@property (nonatomic, strong) NSString *PID;

@property (nonatomic, readwrite) BOOL isUpdate;

@property (nonatomic, readwrite) NSInteger isF_ID_Vid;
@property (strong, nonatomic) IBOutlet UIButton *btnOk;

@end
