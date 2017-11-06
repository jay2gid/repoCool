//
//  FestivalViewVC.h
//  AllCool.pl
//
//  Created by Upendra Singh Shekhawat on 25/09/17.
//  Copyright © 2017 Sanjay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FestivalViewVC : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    
    IBOutlet UIImageView *imgFest;
    IBOutlet UILabel *lblFestName;
    IBOutlet StarRatingControl *viewStar;
    IBOutlet UILabel *lblStarCount;
    IBOutlet UILabel *lblAddLine1;
    IBOutlet UILabel *lblAddLine2;
    IBOutlet UILabel *lblFestDate;
    IBOutlet UIButton *btnCall;
    
    IBOutlet UIImageView *imgExibitors;
    IBOutlet UILabel *lblExibitors;
    
    IBOutlet UIImageView *imgProg;
    IBOutlet UILabel *lblProg;
    
    IBOutlet UIImageView *imgMap;
    IBOutlet UILabel *lblMap;
    
    IBOutlet UIImageView *imgRating;
    IBOutlet UILabel *lblRating;
    
    IBOutlet UIImageView *imgCategory;
    IBOutlet UILabel *lblCategory;
    
    IBOutlet UITableView *tblViewFest;
    IBOutlet UIImageView *imgMapPreiew;
}

@property (nonatomic, strong) NSString *F_ID;

@end
