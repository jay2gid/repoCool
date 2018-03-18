//
//  CommentsVC.h
//  AllCool.pl
//
//  Created by Sanjay on 17/01/18.
//  Copyright © 2018 Sanjay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentsVC : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property(nonatomic,strong) NSDictionary *infoPost;
@end
