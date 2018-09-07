//
//  BearCell.h
//  AllCool.pl
//
//  Created by Sanjay on 07/09/17.
//  Copyright © 2017 Sanjay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BearCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *imgBeerLogo;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet StarRatingControl *viewStarRating;
@property (strong, nonatomic) IBOutlet UILabel *lbl_IBU_ABV_BLG;


@property(nonatomic,strong)IBOutlet UIButton *btnDaduj;
@property(nonatomic,strong)IBOutlet UIButton *btnKasuj;
@property(nonatomic,strong)IBOutlet UIButton *btnNottaki;

@end
