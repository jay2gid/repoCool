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
-(void)didSuccessVenderSuggest;
@end;


@interface ViewAddRatingTobotal : UIView<UITextFieldDelegate>
{
    IBOutlet StarRatingControl *viewStarRating;
    IBOutlet ACFloatingTextfield *txtName;
    IBOutlet ACFloatingTextfield *txtEmail;
    IBOutlet ACFloatingTextfield *txtComment;
    
    
    IBOutlet ACFloatingTextfield *txtNameVender;
    IBOutlet ACFloatingTextfield *txtAddressVender;
    
}
@property (nonatomic, strong) NSDictionary *dictBear;

@property (strong, nonatomic) id<ratingSuccessDelegate> delegate;


@property (nonatomic, strong) NSString *BID;
@property (nonatomic, strong) UIViewController *selfBack;

@property (nonatomic, strong) NSString *FID;
@property (nonatomic, strong) NSString *VID;

@property (nonatomic, readwrite) NSInteger isF_ID_Vid;

@end
