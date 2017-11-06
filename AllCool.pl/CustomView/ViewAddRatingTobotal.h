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


@interface ViewAddRatingTobotal : UIView<UITextFieldDelegate>
{
    IBOutlet StarRatingControl *viewStarRating;
    IBOutlet ACFloatingTextfield *txtName;
    IBOutlet ACFloatingTextfield *txtEmail;
    IBOutlet ACFloatingTextfield *txtComment;
}
@property (nonatomic, strong) NSDictionary *dictBear;

@property (strong, nonatomic) id<ratingSuccessDelegate> delegate;


@property (nonatomic, strong) NSString *BID;
@property (nonatomic, strong) UIViewController *selfBack;

@end
