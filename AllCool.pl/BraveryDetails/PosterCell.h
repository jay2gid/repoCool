//
//  PosterCell.h
//  AllCool.pl
//
//  Created by Sanjay on 14/11/17.
//  Copyright © 2017 Sanjay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PosterCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imgPoster;
@property (strong, nonatomic) IBOutlet UILabel *lblDate;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblDesc;

@end
