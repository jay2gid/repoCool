//
//  FestListTVCell.h
//  AllCool.pl
//
//  Created by Upendra Singh Shekhawat on 29/09/17.
//  Copyright © 2017 Sanjay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FestListTVCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *imgFestLogo;
@property (strong, nonatomic) IBOutlet UILabel *lblFestName;
@property (strong, nonatomic) IBOutlet UILabel *lblPlaceName;
@property (strong, nonatomic) IBOutlet UILabel *lblDates;

@end
