//
//  BotalVC.m
//  AllCool.pl
//
//  Created by Sanjay on 18/09/17.
//  Copyright © 2017 Sanjay. All rights reserved.
//

#import "BotalVC.h"
#import "ViewAddRatingTobotal.h"
#import "ViewWithCornerAndBorder.h"
#import "ViewFavList.h"

@interface BotalVC ()
{
    IBOutlet UILabel *lblFavCount;
    IBOutlet UILabel *lblBotalName;
    IBOutlet UILabel *lblDescroptipn;
    IBOutlet UILabel *lblAlcohotType;
    IBOutlet StarRatingControl *botalRating;
    
    IBOutlet UIScrollView *mainScroll;
    IBOutlet UIView *rview1;
    IBOutlet UIView *rview2;
    IBOutlet UIView *rview3;
    
    IBOutlet UIButton *btnOcena1;
    IBOutlet UIButton *btnOcena2;
    IBOutlet UILabel *slidingLine;
    
    IBOutlet UIButton *btnTest;
    IBOutlet ViewWithCornerAndBorder *viewBtnTst;

    NSDictionary *dictResponce;
    IBOutlet UILabel *lblBlg;
    
    IBOutlet UILabel *lblAbv;
    IBOutlet UILabel *lblIbu;
    IBOutlet UILabel *lblAromat;
    IBOutlet UILabel *lblWyglad;
    IBOutlet UILabel *lblSmak;
    IBOutlet UILabel *lblWrazenie;
    IBOutlet UILabel *lblOgolna;
    
    IBOutlet UIImageView *imageBotal;

    NSArray *arrayUserRatings;
    IBOutlet UITableView *tblRatings;
    
    ViewFavList *viewCustomList;
    
}

@end
@implementation BotalVC
@synthesize dictBeer;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    GET_HEADER_VIEW_WITH_BACK
    header.title.text = @"Reduga loss weekend";

    rview1.layer.cornerRadius = 40;
    rview2.layer.cornerRadius = 40;
    rview3.layer.cornerRadius = 40;
    
    mainScroll.contentSize = CGSizeMake(WIDTH, 900);
    [self getSingleBearDetail];
}

-(void)getSingleBearDetail
{
    SVHUD_START
    
    NSString *bearId;
    
    if ([_from isEqualToString:@"favroit"]) {
        bearId = [Helper getString:dictBeer[@"id"]];
    }
    else{
        bearId = [Helper getString:dictBeer[@"pid"]];
    }
    
    NSDictionary *dict = @{@"uid":UserID,@"pid":bearId};
    
    
    [WebServiceCalls POST:@"vendorss/singlebeer_brewary.php" parameter:dict completionBlock:^(id JSON, WebServiceResult result)
     {
         SVHUD_STOP
         @try
         {
             if ([JSON[@"success"] integerValue] == 1)
             {
                 [self.navigationController.view makeToast:JSON[@"message"]];
                 viewBtnTst.hidden = YES;
                 
                 if ([JSON[@"tested"] integerValue] == 1)
                 {
                     viewBtnTst.hidden = YES;
                 }
                 else
                 {
                     viewBtnTst.hidden = NO;
                 }
                 
                 dictResponce = JSON;
                 
                 [self showCustomList];
                 if ([JSON[@"count"] integerValue] == 1)
                 {
                     lblFavCount.text = [NSString stringWithFormat:@"%@",JSON[@"count"]];
                 }
                 
                 if ([JSON[@"products"] count] > 0)
                 {
                     NSDictionary *dic = JSON[@"products"][0];
                     if (dic[@"product_name"])
                     {
                         lblBotalName.text = [NSString stringWithFormat:@"%@",dic[@"product_name"]];
                     }
                     if (dic[@"desc"])
                     {
                         lblDescroptipn.text = [NSString stringWithFormat:@"%@",dic[@"desc"]];
                     }
                     if (dic[@"ibu"])
                     {
                         lblIbu.text = [NSString stringWithFormat:@"%@",dic[@"ibu"]];
                         lblAbv.text = [NSString stringWithFormat:@"%@",dic[@"ibu"]];

                         lblBlg.text = [NSString stringWithFormat:@"%@",dic[@"ibu"]];

                     }
                     lblAromat.text = [NSString stringWithFormat:@"%@/12",dic[@"aromat"]];
                     lblWyglad.text = [NSString stringWithFormat:@"%@/12",dic[@"wyglad"]];
                     lblWrazenie.text = [NSString stringWithFormat:@"%@/12",dic[@"ODCzuciew_ustach"]];
                     lblSmak.text = [NSString stringWithFormat:@"%@/12",dic[@"smak"]];
                     lblOgolna.text = [NSString stringWithFormat:@"%@/12",dic[@"ogolne_wrazenie"]];

                     if (dic[@"alcohole_type"])
                     {
                         lblAlcohotType.text = [NSString stringWithFormat:@"%@",dic[@"alcohole_type"]];
                     }
                     if (dic[@"Avg_rating"])
                     {
                         botalRating.rating = [[NSString stringWithFormat:@"%@",dic[@"Avg_rating"]] integerValue];
                     }
                     if (JSON[@"ratings"])
                     {
                        if( [JSON[@"ratings"] count] > 0)
                        {
                            arrayUserRatings = JSON[@"ratings"];
                            tblRatings.delegate = self;
                            tblRatings.dataSource = self;
                            [tblRatings reloadData];
                        }
                     }
                     
                     
                 
                }
             }
             else
             {
                 if ([JSON[@"message"] integerValue])
                 {
                     [self.navigationController.view makeToast:JSON[@"message"]];
                 }
             }
         }
         @catch (NSException *exception)
         {}
         @finally
         {}
     }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (IBAction)tapBtnOcena:(UIButton *)sender {
    
    [UIView animateWithDuration:0.3 animations:^{
        
        slidingLine.frame =  CGRectMake(WIDTH/2*sender.tag, 40, WIDTH/2, 2);
    }];
    
    [btnOcena1 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [btnOcena2 setTitleColor:[UIColor darkGrayColor]forState:UIControlStateNormal];
    [sender setTitleColor:APP_COLOR_RED forState:UIControlStateNormal];
}

- (IBAction)tapRating:(id)sender {
    
    ViewAddRatingTobotal *view = [[[NSBundle mainBundle] loadNibNamed:@"View" owner:self options:nil]objectAtIndex:1];
    view.frame = CGRectMake(0, 0, WIDTH, HEIGHT);
    view.BID = [NSString stringWithFormat:@"%@",dictBeer[@"id"]];
    view.selfBack = self;
    view.dictBear = dictBeer;
    view.delegate = self;
    view.isF_ID_Vid = 0;
    [self.view addSubview:view];
}

-(void)didSuccessRating
{
    [self getSingleBearDetail];
}

- (void)didSuccessVenderSuggest {
    
}



- (IBAction)tapTestBotal:(UIButton *)sender {
    
    NSDictionary *dict = @{@"uid":UserID,@"bid":[NSString stringWithFormat:@"%@",dictBeer[@"id"]]};
    [WebServiceCalls POST:@"beer_tested.php" parameter:dict completionBlock:^(id JSON, WebServiceResult result)
     {
         SVHUD_STOP
         @try
         {
             if ([JSON[@"success"] integerValue] == 1)
             {
                 [self.navigationController.view makeToast:JSON[@"message"]];
                 viewBtnTst.hidden = YES;
             }
             else
             {
                 if ([JSON[@"message"] integerValue])
                 {
                     [self.navigationController.view makeToast:JSON[@"message"]];
                 }
             }
         }
         @catch (NSException *exception)
         {}
         @finally
         {}
     }];
    
}



-(void)apiBearVisited
{
    NSDictionary *dict = @{@"uid":UserID,@"bid":[NSString stringWithFormat:@"%@",dictBeer[@"id"]]};
    [WebServiceCalls POST:@"beer_tested.php" parameter:dict completionBlock:^(id JSON, WebServiceResult result)
     {
         SVHUD_STOP
         @try
         {
             if ([JSON[@"success"] integerValue] == 1)
             {
                 [self.navigationController.view makeToast:JSON[@"message"]];
                 viewBtnTst.hidden = YES;
             }
             else
             {
                 if ([JSON[@"message"] integerValue])
                 {
                     [self.navigationController.view makeToast:JSON[@"message"]];
                 }
             }
         }
         @catch (NSException *exception)
         {}
         @finally
         {}
     }];
}

#pragma mark : Table View Delegate

-(CGFloat)tableView:(UITableView* )tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrayUserRatings.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RatingCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"Cells" owner:self options:nil]objectAtIndex:3];
    NSDictionary *dict = arrayUserRatings[indexPath.row];
    
    if (dict[@"name"])
        cell.lblUserName.text = [NSString stringWithFormat:@"%@",dict[@"name"]];
    
    if (dict[@"dat"])
        cell.lblDateTime.text = [NSString stringWithFormat:@"%@",dict[@"dat"]];
    
    if (dict[@"comment"])
        cell.lblReview.text = [NSString stringWithFormat:@"%@",dict[@"comment"]];
    
    return cell;
}





#pragma mark self created list


-(void)makeCustomList
{
    viewCustomList = [[[NSBundle mainBundle] loadNibNamed:@"ViewFavList" owner:self options:nil]objectAtIndex:0];
    viewCustomList.frame = self.view.frame;
    [self.view addSubview:viewCustomList];
    viewCustomList.hidden = YES;
    
    BEMCheckBox *box = [[BEMCheckBox alloc]initWithFrame:CGRectMake(20, 10 , 44, 44)];
    [viewCustomList.scrollCheckButtons addSubview:box];
    box.tag = 0;
    
    UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(70, 10, viewCustomList.scrollCheckButtons.frame.size.width - 70, 44)];
    lbl.text  = @"Ulubione piwa";
    [viewCustomList.scrollCheckButtons addSubview:lbl];
    
    if ([_from isEqualToString:@"favroit"])
    {
        box.on = true;
        box.userInteractionEnabled = false;
    }
    box.delegate = self;
    
    
    if ([dictResponce[@"custom_lists"] count] > 0)
    {
        [viewCustomList.scrollCheckButtons setContentSize:CGSizeMake(viewCustomList.scrollCheckButtons.frame.size.width, 40 + 60 * [dictResponce[@"custom_lists"] count]  )];
        
        for (int i = 0; i < [dictResponce[@"custom_lists"] count]; i++) {
            
            NSDictionary *dict = dictResponce[@"custom_lists"][i];
            
            
            box = [[BEMCheckBox alloc]initWithFrame:CGRectMake(20, 70 + i * 60 , 44, 44)];
            [viewCustomList.scrollCheckButtons addSubview:box];
            box.tag = i+1;
            box.delegate = self;
            
            if ([dict[@"fav_add"] integerValue] == 1) {
                
                box.userInteractionEnabled = false;
                [box on];
            }
            
            lbl = [[UILabel alloc]initWithFrame:CGRectMake(70, 70 + i * 60 , viewCustomList.scrollCheckButtons.frame.size.width - 70, 44)];
            lbl.text  =  [Helper getString:dict[@"list_name"]];
            [viewCustomList.scrollCheckButtons addSubview:lbl];
            
            
        }
        
    }
    
}

-(IBAction)showCustomList

{
    viewCustomList.hidden = NO;
}
-(void)didTapCheckBox:(BEMCheckBox *)checkBox
{
    checkBox.userInteractionEnabled = NO;
    [self custom_list_record:checkBox.tag];
}

-(void)custom_list_record:(NSInteger)tag
{
    
    NSString *listName = @"Ulubione piwa";
    
    if (tag>0)
    {
        listName = [NSString stringWithFormat:@"%@",dictResponce[@"custom_lists"][tag-1][@"list_name"]];
    }
    
    NSDictionary *dict = @{@"uid":UserID,
                           @"list_name":listName,
                           @"beer_type":@"1",
                           @"bid":[NSString stringWithFormat:@"%@",dictBeer[@"id"]]};
    SVHUD_START
    [WebServiceCalls POST:@"custom_list_record.php" parameter:dict completionBlock:^(id JSON, WebServiceResult result)
     {
         SVHUD_STOP
         @try
         {
             if ([JSON[@"success"] integerValue] == 1)
             {
                 [self.navigationController.view makeToast:JSON[@"message"]];
                 viewBtnTst.hidden = YES;
             }
             else
             {
                 if ([JSON[@"message"] integerValue])
                 {
                     [self.navigationController.view makeToast:JSON[@"message"]];
                 }
             }
         }
         @catch (NSException *exception)
         {}
         @finally
         {}
     }];
}



@end
