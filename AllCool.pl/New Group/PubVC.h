//
//  PubVC.h
//  AllCool.pl
//
//  Created by Sanjay on 25/11/17.
//  Copyright © 2017 Sanjay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PubVC : UIViewController<UITableViewDelegate,UITableViewDataSource,ratingSuccessDelegate,UIScrollViewDelegate>

@property  (nonatomic, strong) NSDictionary *infoDic;
@property  (nonatomic, strong) NSString *from;

@end
