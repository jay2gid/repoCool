//
//  BraveryCell.h
//  AllCool.pl
//
//  Created by Sanjay on 07/09/17.
//  Copyright © 2017 Sanjay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BraveryCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imageBravery;
@property (strong, nonatomic) IBOutlet UILabel *lbl_name;
@property (strong, nonatomic) IBOutlet UILabel *lblCity;
@property (strong, nonatomic) IBOutlet UILabel *lblType;
@property (strong, nonatomic) IBOutlet UILabel *lblAvgRating;



@property (strong, nonatomic) IBOutlet UIButton *btnDaduj;
@property (strong, nonatomic) IBOutlet UIButton *btnKasuj;
@property (strong, nonatomic) IBOutlet UIButton *btnNottaki;
@end
