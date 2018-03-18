//
//  ViewBearRadar.h
//  AllCool.pl
//
//  Created by Sanjay on 13/02/18.
//  Copyright © 2018 Sanjay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewBearRadar : UIView
@property (strong, nonatomic) IBOutlet UIImageView *image;
@property (strong, nonatomic) IBOutlet BEMCheckBox *checkBox;
@property (strong, nonatomic) NSDictionary *info;

@end
