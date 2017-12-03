//
//  FirstPubCell.h
//  AllCool.pl
//
//  Created by Sanjay on 26/11/17.
//  Copyright © 2017 Sanjay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstPubCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *lblDesc;
@property (strong, nonatomic) IBOutlet UILabel *lblPubName;
@property (strong, nonatomic) IBOutlet UILabel *lblTiming;
@property (strong, nonatomic) IBOutlet UILabel *lblPhoneNo;
@property (strong, nonatomic) IBOutlet UILabel *lblLocAddress;
@property (strong, nonatomic) IBOutlet UIView *viewPubImages;
@property (strong, nonatomic) IBOutlet UIButton *btnCall;
@property (strong, nonatomic) IBOutlet UIButton *btnDesc;

@property (strong, nonatomic) IBOutlet UIImageView *imageOne;
@property (strong, nonatomic) IBOutlet UIImageView *imageTwo;

@property (strong, nonatomic) IBOutlet UIView *viewDesc;

@end
