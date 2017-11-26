//
//  PubVC.m
//  AllCool.pl
//
//  Created by Sanjay on 25/11/17.
//  Copyright © 2017 Sanjay. All rights reserved.
//

#import "PubVC.h"
#import "FirstPubCell.h"

@interface PubVC ()
{
    IBOutlet UIImageView *imgVerified;
    IBOutlet UILabel *lblAvgRating;
    
    IBOutlet UIImageView *imgLogo;
    IBOutlet StarRatingControl *avg_rating;
    IBOutlet UILabel *lblPub_name;
    IBOutlet UILabel *lblPub_type;
 
    IBOutlet UITableView *table;
    
    /// sanja
}

@end

@implementation PubVC

- (void)viewDidLoad {
    [super viewDidLoad];

    
    [self loadPubDetail];
    
}

-(void)loadPubDetail
{
    
    table.delegate = self;
    table.dataSource = self;
    [table reloadData];
}
// ----  Segment Button Click
// ----  Segment Button Click

#pragma mark Segment Button Click

- (IBAction)tapSegment:(UIButton *)sender
{

    if (sender.tag == 1) {
        
    }
    else   if (sender.tag == 2){
        
    }
    else if (sender.tag == 3){
        
    }
    else if (sender.tag == 4){
        
    }

}




// ----  Table View Delgates
// ----  Table View Delgates

#pragma mark Table Delegates

-(CGFloat)tableView:(UITableView* )tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return 425;
    }
    else
        return 80;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 1;
    }
    else
        return 5;

    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
            
        FirstPubCell *myCell = [[[NSBundle mainBundle]loadNibNamed:@"PubCell" owner:self options:nil]objectAtIndex:0];
            
        return myCell;
    }
    else
    {
            RatingCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"Cells" owner:self options:nil]objectAtIndex:3];
            
        //    NSDictionary *dict; ///= dict_Brewary[@"comment"][indexPath.row-1];
            
//            cell.lblUserName.text = [NSString stringWithFormat:@"%@",dict[@"name"]];
//            
//            cell.lblDateTime.text = [NSString stringWithFormat:@"%@",dict[@"dat"]];
//            
//            cell.lblReview.text = [NSString stringWithFormat:@"%@",dict[@"comment"]];
//            
//            cell.viewRating.rating = [dict[@"rating"] integerValue];
            
            return cell;
        }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
