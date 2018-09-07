//
//  PubVC.m
//  AllCool.pl
//
//  Created by Sanjay on 25/11/17.
//  Copyright © 2017 Sanjay. All rights reserved.
//

#import "PubVC.h"
#import "FirstPubCell.h"
#import "MyCellView.h"
#import "PosterCellPub.h"
#import "PostTimelineVC.h"

@interface PubVC ()
{
    
    IBOutlet UILabel *lblFavCount;
    IBOutlet UILabel *menuSelectionLine;
    
    IBOutlet UIImageView *imgBG;
    
    IBOutlet UIImageView *imgVerified;
    IBOutlet UILabel *lblAvgRating;
    
    IBOutlet UIImageView *imgLogo;
    IBOutlet StarRatingControl *avg_rating;
    IBOutlet UILabel *lblPub_name;
    IBOutlet UILabel *lblPub_type;
 
    IBOutlet UITableView *table;
    
    IBOutlet UIView *viewBotals;
    IBOutlet UILabel *scrollableLine;
    IBOutlet UIScrollView *scrollHorBotals;

    NSDictionary *dicPub;
    
    NSArray *arrayComments,*arrayPromotions,*arrayEvents;
    
    NSUInteger tableFlag;
    
    BOOL isPremium;
    
    NSString *idPub;
    int pubVisited,isFav;
}

@end



@implementation PubVC
@synthesize infoDic;
- (void)viewDidLoad {
    [super viewDidLoad];

    GET_HEADER_VIEW_WITH_BACK
    header.title.text = @"Allcool.pl";
    header.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    
    idPub = [Helper getString:infoDic[@"id"]];
    if ([_from isEqualToString:@"other"]) {
        idPub = [Helper getString:infoDic[@"vid"]];
    }
    
    if ([_from isEqualToString:@"flist"]){

        lblAvgRating.text = [Helper getString:infoDic[@"Avg_rating"]];
        lblPub_name.text = [Helper getString:infoDic[@"name"]];
        lblPub_type.text = [Helper getString:infoDic[@"bar_type"]];
        avg_rating.rating = [[Helper getString:infoDic[@"Avg_rating"]] integerValue];
    
        [Helper setImageOnPGlass:imgLogo url:infoDic[@"img"]];
        [Helper setImageOnPGlass:imgBG url:infoDic[@"img"]];

    }
    tableFlag = 1;
    [self loadPubDetail];
    [self gatBearBotals];
    [self getEventsAndPromotions];
    
    lblAvgRating.layer.cornerRadius = 2;
    lblAvgRating.layer.borderColor = WHITE_COLOR.CGColor;
    lblAvgRating.layer.borderWidth = 0.5;
    scrollHorBotals.delegate = self;
}


-(void)loadPubDetail
{
    
    NSString *url = [NSString stringWithFormat:@"vendorss/myProfile.php?id=%@&uid=%@", idPub,UserID];
    SVHUD_START
    [WebServiceCalls GET:url parameter:nil completionBlock:^(id JSON, WebServiceResult result)
    {
        
         SVHUD_STOP
         NSLog(@"%@", JSON);

        dicPub = JSON;
        
        if( JSON[@"products"])
        {
            if( [JSON[@"products"] count] > 0)
            {
                NSDictionary *dic = JSON[@"products"][0];
                lblFavCount.text = [Helper getStringORZero:JSON[@"count"]];
             
                pubVisited =  [dic[@"pub_visited"] intValue];
                isFav = [dic[@"fav_vendor"] intValue];
                
                if ([dic[@"premium"] integerValue] == 1)
                    isPremium = true;
                else
                    isPremium = false;
                
                if (isPremium)
                    imgVerified.hidden = false;
            }
        }
        
        if(JSON[@"comment"]){
            arrayComments = JSON[@"comment"];
        }
        
        table.delegate = self;
        table.dataSource = self;
        [table reloadData];
    }];
    
}

// ----  Bear Bottal Detail Apis
// ----  Bear Bottal Detail Apis

#pragma mark Bear Bottal Detail Apis

-(void)gatBearBotals
{
// http://allcool.pl/api/vendorss/beerbottelnew.php


    [scrollHorBotals setContentSize:CGSizeMake(WIDTH*2, scrollHorBotals.frame.size.height)];
    
    NSDictionary *dict = @{@"id":idPub,@"uid":UserID};
    
    [WebServiceCalls POST:@"vendorss/beerbottelnew.php" parameter:dict completionBlock:^(id JSON, WebServiceResult result)
     {
         float cellHeight = HEIGHT/3;

         if ([Helper getIntegerDefaultZero:JSON[@"success"]] == 1)
         {
             UIScrollView *scroll_1 = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, scrollHorBotals.frame.size.height)];
             [scrollHorBotals addSubview:scroll_1];
             scroll_1.backgroundColor = WHITE_COLOR;
             
             NSArray *arrBeer;
             if(JSON[@"products"])
                arrBeer = JSON[@"products"] ;
           
             if (arrBeer.count>0) {
                 scroll_1.backgroundColor = WHITE_COLOR;
             }
             
             for (int i = 0; i < arrBeer.count ; i++)
             {
                 MyCellView *myCell = [[[NSBundle mainBundle]loadNibNamed:@"MyCell" owner:self options:nil]objectAtIndex:1];
                 myCell.frame = CGRectMake(WIDTH/2* (float)(i%2), i/2 *cellHeight, WIDTH/2, cellHeight);
                 [scroll_1 addSubview:myCell];
                 
                NSString *url = [NSString stringWithFormat:@"%@", arrBeer[i][@"image"]];
                [myCell.imgBoatal sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"noimage.jpg"]];
                
                 myCell.infoDict = arrBeer[i];

                         myCell.lglName.text = [NSString stringWithFormat:@"%@", arrBeer[i][@"product_name"]];
                 
                         myCell.rating.rating = [arrBeer[i][@"Avg_rating"] integerValue];
                 
                         [scroll_1 addSubview:myCell];
                 
                         UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(0, (i/2 + 1)*cellHeight, WIDTH, 0.5)];
                         lbl.backgroundColor = [UIColor lightGrayColor];
                         [scroll_1 addSubview:lbl];
                 
                         lbl = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH/2, i/2 *cellHeight, 0.5, cellHeight)];
                         lbl.backgroundColor = [UIColor lightGrayColor];
                         [scroll_1 addSubview:lbl];
             }
             
             
             [scroll_1 setContentSize:CGSizeMake(WIDTH, cellHeight * 3)];
         }
         else
         {
            //    [Helper makeToast:[Helper getString:JSON[@"message"]]];
         }
         
         
         
         [WebServiceCalls POST:@"vendorss/beerbarallnew.php" parameter:dict completionBlock:^(id JSON, WebServiceResult result)
          {
              float cellHeight = HEIGHT/3;
              
              
              if ([Helper getIntegerDefaultZero:JSON[@"success"]] == 1)
              {
              
                  UIScrollView *scroll_2 = [[UIScrollView alloc]initWithFrame:CGRectMake(WIDTH, 0, WIDTH, scrollHorBotals.frame.size.height)];
                  [scrollHorBotals addSubview:scroll_2];
                  
                  
                  cellHeight = HEIGHT/3;
                  NSArray *arrBeer;
                  if(JSON[@"products"])
                      arrBeer = JSON[@"products"];
                  
                  if (arrBeer.count>0) {
                      scroll_2.backgroundColor = WHITE_COLOR;

                  }
                  
                  
              for (int i = 0; i < arrBeer.count ; i++)
              {
                  MyCellView *myCell = [[[NSBundle mainBundle]loadNibNamed:@"MyCell" owner:self options:nil]objectAtIndex:1];
                  myCell.frame = CGRectMake(WIDTH/2* (float)(i%2), i/2 *cellHeight, WIDTH/2, cellHeight);
                  [scroll_2 addSubview:myCell];
                  
                          NSString *url = [NSString stringWithFormat:@"%@", arrBeer[i][@"image"]];
                          [myCell.imgBoatal sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"noimage.jpg"]];
                  
                          myCell.lglName.text = [NSString stringWithFormat:@"%@", arrBeer[i][@"product_name"]];
                  
                          myCell.rating.rating = [arrBeer[i][@"Avg_rating"] integerValue];
                  
                          [scroll_2 addSubview:myCell];
                  
                  UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(0, (i/2 + 1)*cellHeight, WIDTH, 0.5)];
                  lbl.backgroundColor = [UIColor lightGrayColor];
                  [scroll_2 addSubview:lbl];
                  
                  lbl = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH/2, i/2 *cellHeight, 0.5, cellHeight)];
                  lbl.backgroundColor = [UIColor lightGrayColor];
                  [scroll_2 addSubview:lbl];
                  myCell.infoDict = arrBeer[i];
              }
              
              [scroll_2 setContentSize:CGSizeMake(WIDTH, cellHeight * 3)];
              }
          }];
         
         
     }];
 
}


// ----  getEventsAndPromotions
// ----  getEventsAndPromotions

#pragma mark EventsAndPromotions API

-(void)getEventsAndPromotions
{
    
    [scrollHorBotals setContentSize:CGSizeMake(WIDTH*2, scrollHorBotals.frame.size.height)];
    
    NSString *url = [NSString stringWithFormat:@"vendorss/event.php?id=%@",idPub];
    
    [WebServiceCalls GET:url parameter:nil completionBlock:^(id JSON, WebServiceResult result)  {
        
         if ([Helper getIntegerDefaultZero:JSON[@"success"]] == 1)
         {
             arrayEvents = JSON[@"products"];
         }
         else
         {
             //    [Helper makeToast:[Helper getString:JSON[@"message"]]];
         }
         
     }];
    
    url = [NSString stringWithFormat:@"vendorss/promotions.php?id=%@",idPub];

    [WebServiceCalls GET:url parameter:nil completionBlock:^(id JSON, WebServiceResult result)  {
        
        if ([Helper getIntegerDefaultZero:JSON[@"success"]] == 1)
        {
            arrayPromotions = JSON[@"products"];
        }
        else
        {
            //    [Helper makeToast:[Helper getString:JSON[@"message"]]];
        }
    }];
    
}



// ----  Segment Button Click
// ----  Segment Button Click

#pragma mark Segment Button Click

- (IBAction)tapSegment:(UIButton *)sender
{

    if (sender.tag == 1) {
        
        tableFlag = 1;
        table.hidden = NO;
        viewBotals.hidden = YES;
        [table reloadData];
    }
    else   if (sender.tag == 2){

        table.hidden = YES; 
        viewBotals.hidden = NO;
    }
    else if (sender.tag == 3){
        
        tableFlag = 3;
        table.hidden = NO;
        viewBotals.hidden = YES;
        [table reloadData];
    }
    else if (sender.tag == 4){

        tableFlag = 4;
        table.hidden = NO;
        viewBotals.hidden = YES;
        [table reloadData];

    }
    
    [UIView animateWithDuration:0.2 animations:^{
        menuSelectionLine.center = CGPointMake((sender.tag-1)*WIDTH/4 + WIDTH/8 , menuSelectionLine.center.y);
    }];

}


// ----  Table View Delgates
// ----  Table View Delgates

#pragma mark Table Delegates

-(CGFloat)tableView:(UITableView* )tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableFlag == 1){
        
        float height;
        if (indexPath.section == 0){
            if ([self isWallpaper])
                height = 425;
            else
                height =  260;
            
           NSString *strDes = [Helper getString:dicPub[@"products"][0][@"pub_desc"]];
            if ([strDes isEqualToString:@""]) {
                height -= 60;
            }
            return height;
        }
        else
            return 80;
    } else  if (tableFlag == 3){
        return 395;
        
    } else  if (tableFlag == 4){
        return 260;
    }
    else {
        return 100;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableFlag == 1) {
        return 2;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableFlag == 1)
    {
        if (section == 0)
        {
            return 1;
        }
        else
            return arrayComments.count;
        
    }
    else if (tableFlag == 3)
        return arrayEvents.count;
    else if (tableFlag == 4)
        return arrayPromotions.count;
    else
        return 1;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableFlag == 1) {

    if (indexPath.section == 0) {
            
        FirstPubCell *myCell = [[[NSBundle mainBundle]loadNibNamed:@"PubCell" owner:self options:nil]objectAtIndex:0];
        
        if (![self isWallpaper])
        {
            myCell.viewPubImages.hidden = YES;
            myCell.viewDesc.center = CGPointMake(myCell.viewDesc.center.x, myCell.viewPubImages.frame.origin.y + myCell.viewDesc.frame.size.height/2) ;
        }

        
        myCell.lblPubName.text = lblPub_name.text;
        myCell.lblPhoneNo.text = [Helper getString:dicPub[@"products"][0][@"phone"]];
        myCell.lblLocAddress.text = [NSString stringWithFormat:@"%@ %@ %@ ",infoDic[@"street_name"],infoDic[@"street_number"],infoDic[@"city"]];
        myCell.selfBack = self;
        myCell.infoPub = dicPub;

        NSString *strDes = [Helper getString:dicPub[@"products"][0][@"pub_desc"]];
        myCell.lblDesc.text = strDes;
        
        if(dicPub[@"opening"]){
            
            if([dicPub[@"opening"] count] > 0) {
             
                NSString *str = @"";
                
                for (int i =0; i < [dicPub[@"opening"] count]; i++) {
                    
                    str = [NSString stringWithFormat:@"%@ %@",str,[Helper getString:dicPub[@"opening"][i][@"day"]]];
                }
                
                myCell.lblTiming.text = str;
            }
        }
        
        return myCell;
    }
    else
    {
          RatingCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"Cells" owner:self options:nil]objectAtIndex:3];
            
          NSDictionary *dict = arrayComments[indexPath.row];

          cell.lblUserName.text = [NSString stringWithFormat:@"%@",dict[@"name"]];
        
          cell.lblDateTime.text = [NSString stringWithFormat:@"%@",dict[@"dat"]];

          cell.lblReview.text = [NSString stringWithFormat:@"%@",dict[@"comment"]];
        
          cell.viewRating.rating = [dict[@"rating"] integerValue];
        
        return cell;
    }
    }
    
    else if (tableFlag == 3) {
        PosterCellPub *posterCell = [[[NSBundle mainBundle]loadNibNamed:@"PubCell" owner:self options:nil]objectAtIndex:1];
        NSDictionary *dict = arrayEvents[indexPath.row];
        
        posterCell.lblDay.text = [Helper getString:dict[@"event_date"]];
        posterCell.lblMonth.text = [Helper getString:dict[@"event_month"]];
        posterCell.lblTime.text = [Helper getString:dict[@"event_time"]];
        posterCell.lblDetail.text = [Helper getString:dict[@"price"]];
        posterCell.lblTitle.text = [Helper getString:dict[@"name"]];
        posterCell.lblInfo.text = [Helper getString:dict[@"desc"]];

        
        NSString *url = [NSString stringWithFormat:@"%@", dict[@"img"]];
        [posterCell.imgEvent sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"noimage.jpg"]];
        
        return posterCell;
    }
    else
    {
        UITableViewCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"PubCell" owner:self options:nil]objectAtIndex:2];
        UIImageView *image = [cell viewWithTag:1];
        
        NSString *url = [NSString stringWithFormat:@"%@", arrayPromotions[indexPath.row][@"img"]];
        [image sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"noimage.jpg"]];
        
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (IBAction)tapOnBotolSegments:(UIButton *)sender {

    [scrollHorBotals setContentOffset:CGPointMake(WIDTH*(sender.tag - 1), 0) animated:true];
    
}




- (IBAction)tapONPlus:(id)sender {
    
    
    UIAlertController * view = [UIAlertController
                                alertControllerWithTitle:@""
                                message:@""
                                preferredStyle:UIAlertControllerStyleActionSheet];
    
    
    if (pubVisited == 0)
    {
        UIAlertAction* visit = [UIAlertAction
                                 actionWithTitle:@"Odwiedzony"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     pubVisited = 1;
                                     NSDictionary *dict = @{@"uid":UserID, @"vid":idPub};
                                     [self Api_URL:@"pub_visited.php" Data:dict];
                                     
                                     [view dismissViewControllerAnimated:YES completion:nil];
                                 }];
        
        [visit setValue:[[UIImage imageNamed:@"flag_op"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forKey:@"image"];
        
        [view addAction:visit];
    }
    
    if (isFav == 0)
    {
        UIAlertAction* fav = [UIAlertAction
                                  actionWithTitle:@"Ulubiony"
                                  style:UIAlertActionStyleDefault
                                  handler:^(UIAlertAction * action)
                                  {
                                      // http://allcool.pl/api_ios/favourite_brewery.php
                                      isFav = 1;
                                      NSDictionary *dict = @{@"uid":UserID, @"vid":infoDic[@"id"]};
                                      [self Api_URL:@"favourite_vendor.php" Data:dict];
                                      
                                      [view dismissViewControllerAnimated:YES completion:nil];
                                  }];
        
        [fav setValue:[[UIImage imageNamed:@"like_op"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forKey:@"image"];
        
        [view addAction:fav];
    }
    
    
    
    UIAlertAction* postAction = [UIAlertAction
                                   actionWithTitle:@"Dodaj wpis"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action)
                                   {
                                       PostTimelineVC *obj = [[PostTimelineVC alloc]initWithNibName:@"PostTimelineVC" bundle:nil];
                                       obj.infoPub = infoDic;
                                       [self.navigationController pushViewController:obj animated:YES];
                                   }];
    [postAction setValue:[[UIImage imageNamed:@"send_op"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forKey:@"image"];
    [view addAction:postAction];
    
    
    
    
    
    UIAlertAction* refer = [UIAlertAction
                                   actionWithTitle:@"Zaproponuj bar"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action)
                                   {
                                       ViewAddRatingTobotal *view1 = [[[NSBundle mainBundle] loadNibNamed:@"View" owner:self options:nil]objectAtIndex:2];
                                       view1.frame = CGRectMake(0, 0, WIDTH, HEIGHT);
                                       view1.selfBack = self;
                                       //view1.delegate = self;
                                       [self.view addSubview:view1];
                                       // view1.PID = idPub;
                                       
                                       [view dismissViewControllerAnimated:YES completion:nil];
                                       
                                   }];
    
    
    
    
    UIAlertAction* rating = [UIAlertAction
                           actionWithTitle:@"Ocen ten bar"
                           style:UIAlertActionStyleDefault
                           handler:^(UIAlertAction * action)
                           {
                               ViewAddRatingTobotal *view1 = [[[NSBundle mainBundle] loadNibNamed:@"View" owner:self options:nil]objectAtIndex:1];
                               view1.frame = CGRectMake(0, 0, WIDTH, HEIGHT);
                               view1.isF_ID_Vid = 1;
                               view1.PID = idPub;
                               view1.selfBack = self;
                               view1.delegate = self;
                               [self.view addSubview:view1];
                               
                               [view dismissViewControllerAnimated:YES completion:nil];
                           }];
    
    
    
    
    UIAlertAction* direction = [UIAlertAction
                           actionWithTitle:@"Pokaz drog"
                           style:UIAlertActionStyleDefault
                           handler:^(UIAlertAction * action)
                           {
                             
                           }];
    
    
    
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:@"Cancel"
                             style:UIAlertActionStyleCancel
                             handler:^(UIAlertAction * action)
                             {  }];
    
    
    
    
    [refer setValue:[[UIImage imageNamed:@"box_op"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forKey:@"image"];
    [rating setValue:[[UIImage imageNamed:@"star_op"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forKey:@"image"];
    [direction setValue:[[UIImage imageNamed:@"dir_op"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forKey:@"image"];

    [view addAction:refer];
    [view addAction:rating];
    [view addAction:direction];

    [view addAction:cancel];
    
    [self presentViewController:view animated:YES completion:nil];
    
}

-(void)didSuccessRating
{
    [self loadPubDetail];
}



-(void)Api_URL:(NSString *)url Data:(NSDictionary *)dict
{
    SVHUD_START
    [WebServiceCalls POST:url parameter:dict completionBlock:^(id JSON, WebServiceResult result)
     {
         SVHUD_STOP
         // NSLog(@"%@", JSON);
         
         if ([JSON[@"success"] integerValue] == 1)
         {
             [self.navigationController.view makeToast:JSON[@"message"]];
             [self viewDidAppear:NO];
         }
         else
         {
             [self.navigationController.view makeToast:JSON[@"message"]];
         }
     }];
}

///// --- Scroll View Delegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    scrollableLine.frame = CGRectMake(scrollView.contentOffset.x/2, scrollableLine.frame.origin.y, scrollableLine.frame.size.width , scrollableLine.frame.size.height);
    
//    scrollableLine.center = CGPointMake(WIDTH/2*(sender.tag - 1) + WIDTH/4, scrollableLine.center.y);

}


///// --- supporting metthos

-(BOOL)isWallpaper
{
    if (isPremium) {
        
        if (dicPub[@"gallery"])
        {
            if ([dicPub[@"gallery"] count] > 0)
            {
                return true;
            }
        }
        return false;

    } else {
        return false;
    }
    
}



@end
