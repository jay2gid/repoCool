//
//  DescripionVC.h
//  AllCool.pl
//
//  Created by Pramod Kumar Sharma on 17/11/17.
//  Copyright © 2017 Sanjay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DescripionVC : UIViewController
{
    IBOutlet UITextView *txtDescription;
}

@property (nonatomic, strong) NSString *strTitle;
@property (nonatomic, strong) NSString *strDescription;

@end
