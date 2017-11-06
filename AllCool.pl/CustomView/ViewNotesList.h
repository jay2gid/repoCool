//
//  ViewNotesList.h
//  AllCool.pl
//
//  Created by Sanjay on 13/10/17.
//  Copyright © 2017 Sanjay. All rights reserved.
//

#import <UIKit/UIKit.h>




@interface ViewNotesList : UIView<UITableViewDelegate,UITableViewDataSource>

@property(strong,nonatomic)UIViewController *selfBack;
@property (strong, nonatomic) IBOutlet UITableView *tableList;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;

@property (readwrite, nonatomic) NSInteger tagFOR;

@property (strong , nonatomic) NSDictionary *dict;
@end
