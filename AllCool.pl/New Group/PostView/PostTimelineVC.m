//
//  PostTimelineVC.m
//  AllCool.pl
//
//  Created by Sanjay on 17/12/17.
//  Copyright © 2017 Sanjay. All rights reserved.
//

#import "PostTimelineVC.h"
#import "MakePostVC.h"
#import "CellPT.h"
#import "CommentsVC.h"
#import "ProfilVC.h"

@interface PostTimelineVC ()
{
    IBOutlet UIView *viewForHeader;
    
    
    IBOutlet UITableView *table;
    NSArray *arrayData;
}
@end

@implementation PostTimelineVC
@synthesize infoPub;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    GET_HEADER_VIEW_WITH_BACK
    header.title.text = @"Post       ";
    [viewForHeader addSubview:header];
    header.frame = CGRectMake(0, 0, WIDTH, 64);
    
    table.delegate = self;
    table.dataSource = self;
}

-(void)viewDidAppear:(BOOL)animated{
    
    [self getWallPost];
}

-(void)getWallPost
{
    NSString *url = [NSString stringWithFormat:@"get_wallpost.php?id=%@",infoPub[@"id"]];
    //   NSString *url = [NSString stringWithFormat:@"get_wallpost.php?id=174"];

    SVHUD_START
    [WebServiceCalls GET:url parameter:nil completionBlock:^(id JSON, WebServiceResult result) {
        
        SVHUD_STOP
        NSLog(@"%@", JSON);
        @try
        {
            if ([JSON[@"success"] integerValue] == 1)
            {
                if (JSON[@"wallposts"]) {
                    arrayData = JSON[@"wallposts"];
                }
                [table reloadData];
            }
            else
            {
                [WebServiceCalls alert:JSON[@"message"]];
            }
        }
        @catch (NSException *exception){  }
        @finally{  }
    }];
}


- (IBAction)tapToPost:(id)sender {
    MakePostVC *obj = [[MakePostVC alloc]initWithNibName:@"MakePostVC" bundle:nil];
    obj.infoPub = infoPub;
    [self presentViewController:obj animated:YES completion:nil];
}


#pragma mark Table

-(CGFloat)tableView:(UITableView* )tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *cmnt = [NSString stringWithFormat:@"%@",arrayData[indexPath.row][@"comment"]];

    if ([[Helper getString:arrayData[indexPath.row][@"image"]] length] > 10) {
        if ([cmnt isEqualToString:@"<null>"]) {
            return 504;
        }
        return 504;
        return 624;
    } else {
        if ([cmnt isEqualToString:@"<null>"]) {
            return 180;
        }
        return 324;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arrayData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CellPT *cell = [[[NSBundle mainBundle] loadNibNamed:@"CellPT" owner:self options:nil]objectAtIndex:0];
  
    NSDictionary *dic = [arrayData objectAtIndex:indexPath.row];
    
    [cell.btnProfile addTarget:self action:@selector(tapUserProfile:) forControlEvents:UIControlEventTouchUpInside];
    cell.btnProfile.tag = indexPath.row;
    
    cell.lblText.text = [Helper getString:dic[@"post"]];
    cell.lblPosterName.text = [Helper getString:dic[@"username"]];
    cell.lblPostDate.text = [Helper getString:dic[@"dat"]];

    
    
    NSString *url = [Helper getString:dic[@"usr_img"]];
    [cell.imgPosterImage sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"noimage.jpg"]];
    url = [Helper getString:dic[@"image"]];
    
    if (url.length > 0) {
        [cell.imgPosted sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"noimage.jpg"]];
    }else{
        cell.heightPostedImg.constant = 0;
    }

    NSString *cmnt = [NSString stringWithFormat:@"%@",dic[@"comment"]];
    
    cell.viewComment1.hidden = true;
    cell.viewComment2.hidden = true;
    if ([cmnt isEqualToString:@"<null>"]) {
        cell.viewComment1.hidden = true;
        cell.viewComment2.hidden = true;
    }
    
    [cell.btnComment addTarget:self action:@selector(tapComment:) forControlEvents:UIControlEventTouchUpInside];
    cell.btnComment.tag = indexPath.row;
    [cell setNeedsDisplay];
    return cell;
}

-(void)tapUserProfile:(UIButton*)sender{
    
    ProfilVC *obj = [[ProfilVC alloc]initWithNibName:@"ProfilVC" bundle:nil];
    obj.idUser =[Helper getString:arrayData[sender.tag][@"uid"]];
    [self.navigationController pushViewController:obj animated:YES];
}




-(void)tapComment:(UIButton *)sender{
    CommentsVC *vc = [[CommentsVC alloc]initWithNibName:@"CommentsVC" bundle:nil];
    vc.infoPost = [arrayData objectAtIndex:sender.tag];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
