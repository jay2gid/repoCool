//
//  BtnCell.h
//  AllCool.pl
//
//  Created by Sanjay on 14/11/17.
//  Copyright © 2017 Sanjay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BtnCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *lblProducer_name;
@property (strong, nonatomic) IBOutlet UILabel *lblPhone;
@property (strong, nonatomic) IBOutlet UILabel *lblWebsite;
@property (strong, nonatomic) IBOutlet UILabel *lblRegion;
@property (strong, nonatomic) IBOutlet UILabel *lblBar_type;
@property (strong, nonatomic) IBOutlet UILabel *lblDescription;

@property  (nonatomic, strong) NSDictionary *infoDicBrovary;
@property  (nonatomic, strong) UIViewController *selfBack;

@end
