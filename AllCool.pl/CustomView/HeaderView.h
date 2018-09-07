//
//  HeaderView.h
//  AllCool.pl
//
//  Created by Sanjay on 06/09/17.
//  Copyright © 2017 Sanjay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeaderView : UIView

@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) UIViewController *selfBack;

@property (strong, nonatomic) IBOutlet UIView *viewBack;

@property (strong, nonatomic) IBOutlet UIButton *btnMenu;
@property (strong, nonatomic) IBOutlet UIImageView *imgMenu;

@end
