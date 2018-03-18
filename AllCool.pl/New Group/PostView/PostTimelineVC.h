//
//  PostTimelineVC.h
//  AllCool.pl
//
//  Created by Sanjay on 17/12/17.
//  Copyright © 2017 Sanjay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostTimelineVC : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property  (nonatomic, strong) NSDictionary *infoPub;

@end
