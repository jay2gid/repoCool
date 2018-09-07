//
//  BraveryList.h
//  AllCool.pl
//
//  Created by Sanjay on 27/12/17.
//  Copyright © 2017 Sanjay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BraveryList : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,readwrite) BOOL isBack;
@property(nonatomic,readwrite) int apiTag;

@end
