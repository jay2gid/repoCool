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

@property  (nonatomic, strong) NSDictionary *infoDic;

@end
