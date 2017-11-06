//
//  BotalVC.h
//  AllCool.pl
//
//  Created by Sanjay on 18/09/17.
//  Copyright © 2017 Sanjay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewAddRatingTobotal.h"
@interface BotalVC : UIViewController<UITableViewDelegate,UITableViewDataSource,ratingSuccessDelegate>

@property (nonatomic, strong) NSDictionary *dictBeer;

@end
