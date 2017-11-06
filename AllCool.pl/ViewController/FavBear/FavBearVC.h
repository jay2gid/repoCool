//
//  FavBearVC.h
//  AllCool.pl
//
//  Created by Sanjay on 07/09/17.
//  Copyright © 2017 Sanjay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FavBearVC : UIViewController
{
    IBOutlet UITableView *tblViewBeer;
}
@property(nonatomic,readwrite) BOOL isBack;
@property(nonatomic,readwrite) int apiTag;

@end
