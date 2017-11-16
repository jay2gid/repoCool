//
//  BraveryVC.h
//  AllCool.pl
//
//  Created by Sanjay on 22/10/17.
//  Copyright © 2017 Sanjay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewAddRatingTobotal.h"

@interface BraveryVC : UIViewController<ratingSuccessDelegate,UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UIImageView *imgLogo;
@property (strong, nonatomic) IBOutlet StarRatingControl *avg_rating;
@property (strong, nonatomic) IBOutlet UILabel *lblProducer_name;
@property (strong, nonatomic) IBOutlet UILabel *lblBar_type;

@property  (nonatomic, strong) NSDictionary *infoDic;

@end
