//
//  MyCellView.h
//  AllCool.pl
//
//  Created by Sanjay on 12/11/17.
//  Copyright © 2017 Sanjay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCellView : UIView
@property (strong, nonatomic) IBOutlet UIImageView *imgBoatal;
@property (strong, nonatomic) IBOutlet UILabel *lglName;
@property (strong, nonatomic) IBOutlet StarRatingControl *rating;

@property (strong, nonatomic) id infoDict;


@end
