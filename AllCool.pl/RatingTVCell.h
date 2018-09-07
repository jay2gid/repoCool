//
//  RatingTVCell.h
//  AllCool.pl
//
//  Created by Upendra Singh Shekhawat on 26/09/17.
//  Copyright © 2017 Sanjay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RatingTVCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *lblName;
@property (strong, nonatomic) IBOutlet StarRatingControl *viewStar;
@property (strong, nonatomic) IBOutlet UILabel *lblDate;

@end
