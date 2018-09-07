//
//  CellPT.h
//  AllCool.pl
//
//  Created by Sanjay on 17/12/17.
//  Copyright © 2017 Sanjay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CellPT : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *lblPosterName;
@property (strong, nonatomic) IBOutlet UILabel *lblPostDate;
@property (strong, nonatomic) IBOutlet UIImageView *imgPosterImage;

@property (strong, nonatomic) IBOutlet UILabel *lblText;
@property (strong, nonatomic) IBOutlet UIImageView *imgPosted;

@property (strong, nonatomic) IBOutlet UIView *viewComment1;
@property (strong, nonatomic) IBOutlet UIView *viewComment2;
@property (strong, nonatomic) IBOutlet UIView *viewTapComment;
@property (strong, nonatomic) IBOutlet UIButton *btnComment;
@property (strong, nonatomic) IBOutlet UIButton *btnProfile;

@property (strong, nonatomic)  UIViewController *selfBack;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *heightConCmt1;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *heightConCmt2;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *heightLbl;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *heightPostedImg;

@property (strong, nonatomic)  NSDictionary *info;


@end
