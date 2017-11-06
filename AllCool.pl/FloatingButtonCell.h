//
//  FloatingButtonCell.h
//  AllCool.pl
//
//  Created by Sanjay on 14/10/17.
//  Copyright © 2017 Sanjay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FloatingButtonCell : UIView
@property (strong, nonatomic) IBOutlet UIView *view_icon;
@property (strong, nonatomic) IBOutlet UILabel *lbl_title;
@property (strong, nonatomic) IBOutlet UIButton *btn_tap;

@end
