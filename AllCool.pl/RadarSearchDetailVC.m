//
//  RadarSearchDetailVC.m
//  AllCool.pl
//
//  Created by Sanjay on 15/02/18.
//  Copyright © 2018 Sanjay. All rights reserved.
//

#import "RadarSearchDetailVC.h"

@interface RadarSearchDetailVC ()
{
    
    IBOutlet UIView *viewBotal;
    IBOutlet UIImageView *imageBottol;
    
    IBOutlet UITableView *table;
    NSArray *arrList;
    NSInteger tagIndex;
    
}
@end

@implementation RadarSearchDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    GET_HEADER_VIEW_WITH_BACK
    header.title.text = @" Piwny Radar wyniki";
    
    [imageBottol sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_arrayBotals[0][@"image"]]] placeholderImage:[UIImage imageNamed:@"noimage.jpg"]];
    tagIndex = 0;
    table.delegate = self;
    table.dataSource = self;
  
    [self loadData];
    
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:true];
    [table reloadData];
}

-(void)loadData{
//    jsObj.put("uid", loginPreferences.getString("userid", null));
//    jsObj.put("lat", lat);
//    jsObj.put("products", json);
//    jsObj.put("lng", lang);
//    jsObj.put("radius", radius);

    //NSString *str;
    NSMutableArray *array = [NSMutableArray array];
    
    for (int i = 0 ;i<_arrayBotals.count ; i++){
        
        NSDictionary *dic = @{@"product_id":[Helper getString:_arrayBotals[i][@"id"]]};
        [array addObject:dic];
    }
//    lat = "53.4233";
//    lng = "14.559729000000061";
//
    NSDictionary *dict = @{@"lat":@"54.464702",
                           @"lng":@"17.01888400000007",
                           @"radius":@"500",
                           @"uid":UserID,
                           @"products":array,
                           };
    
    NSString *jsonStirng = [Helper jsonString:dict];
    jsonStirng = [jsonStirng stringByReplacingOccurrencesOfString:@" " withString:@""];
    jsonStirng = [jsonStirng stringByReplacingOccurrencesOfString:@"\n" withString:@""];

    NSDictionary *param =@{@"json_key":jsonStirng} ;
    
    SVHUD_START
    [WebServiceCalls POST:@"searchradarresult.php" parameter:param completionBlock:^(id JSON, WebServiceResult result)
     {
         SVHUD_STOP
         NSLog(@"%@", JSON);
         @try  {
             if ([JSON[@"success"] integerValue] == 1) {
                
                 
             }else {
                 [Helper makeToast:[Helper getString:JSON[@"message"]]];
             }
         }
         @catch (NSException *exception) { }
         @finally { }
     }];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)tapLeftButton:(id)sender {
   
    if (tagIndex>0) {
        tagIndex--;
        [imageBottol sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_arrayBotals[tagIndex][@"image"]]] placeholderImage:[UIImage imageNamed:@"noimage.jpg"]];
    }
    
}

- (IBAction)tapRightButton:(id)sender {
   
    if (tagIndex<_arrayBotals.count-1) {
        tagIndex++;
        [imageBottol sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_arrayBotals[tagIndex][@"image"]]] placeholderImage:[UIImage imageNamed:@"noimage.jpg"]];
        
    }}

#pragma mark Table

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(CGFloat)tableView:(UITableView* )tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 200;
    }
    return 140;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    return arrList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        UITableViewCell *cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"nothing"];
        
        [cell addSubview:viewBotal];
        
        return  cell;
        
    }else{
       
        BraveryCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"Cells" owner:self options:nil]objectAtIndex:1];
        
        cell.lbl_name.text = [NSString stringWithFormat:@"%@",arrList[indexPath.row][@"name"]];
        cell.lblType.text = [NSString stringWithFormat:@"%@",arrList[indexPath.row][@"business_name"]];
        cell.lblCity.text = [NSString stringWithFormat:@"%@",arrList[indexPath.row][@"street_name"]];
        cell.lblAvgRating.text = [NSString stringWithFormat:@"%@",arrList[indexPath.row][@"Avg_rating"]];
        
        [cell.imageBravery sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",arrList[indexPath.row][@"img"]]]   placeholderImage:[UIImage imageNamed:@"noimage.jpg"]];
        
        
        //    [cell.btnDaduj addTarget:self action:@selector(methodDauj:) forControlEvents:UIControlEventTouchUpInside];
        //    cell.btnDaduj.tag = indexPath.row;
        //    [cell.btnNottaki addTarget:self action:@selector(methodNottaki:) forControlEvents:UIControlEventTouchUpInside];
        //    cell.btnNottaki.tag = indexPath.row;
        //    [cell.btnKasuj addTarget:self action:@selector(methodKasuj:) forControlEvents:UIControlEventTouchUpInside];
        cell.btnKasuj.tag = indexPath.row;
        
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PubVC *obj = [[PubVC alloc]initWithNibName:@"PubVC" bundle:nil];
    obj.infoDic = arrList[indexPath.row];
    obj.from = @"flist";
    [self.navigationController pushViewController:obj animated:YES];
}

@end
