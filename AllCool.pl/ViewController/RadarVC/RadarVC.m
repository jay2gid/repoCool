//
//  RadarVC.m
//  AllCool.pl
//
//  Created by Sanjay on 16/09/17.
//  Copyright © 2017 Sanjay. All rights reserved.
//
//
//Rahul, 13:41
//api/profileAttribute.php
//
//http://allcool.pl/api/radar.php
//
//Radar ----- (1).http://allcool.pl/api/radar.php
//
//-------(2). http://allcool.pl/api/searchradarresult.php
//
//For next and previous
//
//http://allcool.pl/api/searchradarnavnext.php

//http://allcool.pl/api/searchradarnavpre.php

#import "RadarVC.h"
#import "ViewBearRadar.h"
#import "RadarSearchDetailVC.h"

@interface RadarVC ()
{
    
    IBOutlet UIView *viewMain;
    IBOutlet UITextField *txtSelectData;
    
    NSMutableArray *pickerArray;
    UIToolbar *toolBar;
    UIPickerView *picker;
    
    IBOutlet UIButton *btn1km;
    IBOutlet UIButton *btn3km;
    IBOutlet UIButton *btn5km;
    
    IBOutlet UIScrollView *viewScroll;
    
    NSMutableDictionary *dictCustomBears,*checkedBotals;
    NSMutableArray *arraySelectedBotals;
    NSInteger tagCustom;
    CGRect frameScroll;
    id jsonResponce;
    
    NSString *radius;
    
}
@end

@implementation RadarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    GET_HEADER_VIEW
    header.title.text = @"Radar";

    [self getRadarData];
    dictCustomBears = [NSMutableDictionary dictionary];
    checkedBotals = [NSMutableDictionary dictionary];

    txtSelectData.text = @"Wybierze Liste";
    arraySelectedBotals = [NSMutableArray array];
    radius = @"";
}

-(void)getRadarData {
    
    NSDictionary *param =@{@"uid": UserID} ;
    
    SVHUD_START
    [WebServiceCalls POST:@"radar.php" parameter:param completionBlock:^(id JSON, WebServiceResult result)
     {
         SVHUD_STOP
         NSLog(@"%@", JSON);
         @try  {
             if ([JSON[@"success"] integerValue] == 1) {
                 pickerArray = [NSMutableArray array];
                // [pickerArray addObject:@"Wybierze Liste"];
                 [pickerArray addObject:@"Ulubione piwa"];
                 
                 for (int i = 0; i<[JSON[@"custom_lists"] count]; i++) {
                     [pickerArray addObject:JSON[@"custom_lists"][i][@"list_name"]];
                 }
                 tagCustom = 1;
                 [self performSelector:@selector(getCustomBottols) withObject:nil afterDelay:0];
                 [self setPicker];
                 [self setBotals: JSON[@"beer_detail"] pickerIndex:1];
                 
                 jsonResponce = JSON;
                 
             }else {
                 [Helper makeToast:[Helper getString:JSON[@"message"]]];
             }
         }
         @catch (NSException *exception) { }
         @finally { }
     }];
}

-(void)setBotals:(NSArray *)array pickerIndex:(NSInteger )pIndex {
    
    for (int i = 0; i<array.count ; i++) {
        
        ViewBearRadar *view = [[[NSBundle mainBundle] loadNibNamed:@"ViewBearRadar" owner:self options:nil] objectAtIndex:0];
        view.frame = CGRectMake(170*i, 0, 160, 190);
        [viewScroll addSubview:view];

        [Helper setImageOnPBotal:view.image url:array[i][@"image"]];
        view.checkBox.tag = pIndex*1000+i;
        view.info = array[i];
        view.checkBox.delegate = self;
        
        if ([checkedBotals objectForKey:[NSString stringWithFormat:@"%ld",view.checkBox.tag]]) {
            [view.checkBox setOn:YES];
        }
        
    }
    [viewScroll setContentSize:CGSizeMake(200*array.count, 100)];
}
-(void)didTapCheckBox:(BEMCheckBox *)checkBox{
    
    if ([checkBox on]) {
        NSDictionary *dict;
        if (checkBox.tag < 2000 ) {
            dict = @{@"id": [Helper getString:jsonResponce[@"beer_detail"][checkBox.tag%1000][@"pid"] ],
                 @"image":[Helper getString:jsonResponce[@"beer_detail"][checkBox.tag%1000][@"image"]],
            };
            
        }else{
            dict = @{@"id": [Helper getString:dictCustomBears[pickerArray[checkBox.tag/1000]][checkBox.tag%1000][@"id"] ],
                                   @"image":[Helper getString:dictCustomBears[pickerArray[checkBox.tag/1000]][checkBox.tag%1000][@"image"]]};
            
        }
        
        [checkedBotals setObject:dict forKey:[NSString stringWithFormat:@"%ld",checkBox.tag]];
        
    }else{
        [checkedBotals removeObjectForKey:[NSString stringWithFormat:@"%ld",checkBox.tag]];
    }
}

-(void)setPicker{
    
    txtSelectData.delegate = self;
    
    picker = [[UIPickerView alloc]init];
    picker.dataSource = self;
    picker.delegate = self;
    picker.showsSelectionIndicator = YES;
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(done)];
    UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-picker.frame.size.height-50, 320, 44)];
    [toolBar setBarStyle:UIBarStyleBlackOpaque];
    NSArray *toolbarItems = [NSArray arrayWithObjects:flex, doneButton, nil];
    [toolBar setItems:toolbarItems];
    
    txtSelectData.placeholder = @"Select Category";
    
    txtSelectData.inputView = picker;
    txtSelectData.inputAccessoryView = toolBar;
}

- (IBAction)tapButton:(UIButton *)sender {
    
    btn1km.alpha =1;
    btn3km.alpha =1;
    btn5km.alpha =1;
    sender.alpha = 0.5;
    
    radius = [NSString stringWithFormat:@"%d",(int)sender.tag];
    
}


-(void)done{
    HIDE_KEY
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Picker View Data source

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [pickerArray count];
}

#pragma mark- Picker View Delegate

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    [viewScroll removeFromSuperview];
    viewScroll = [[UIScrollView alloc]initWithFrame:viewScroll.frame];
    [viewMain addSubview:viewScroll];
        [txtSelectData setText:[pickerArray objectAtIndex:row]];

    if (row == 0) {
        [self setBotals: jsonResponce[@"beer_detail"] pickerIndex:row];
    }else if (row > 0){
        [self setBotals: dictCustomBears[txtSelectData.text] pickerIndex:row];
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [pickerArray objectAtIndex:row];
}

-(void)getCustomBottols {
   
    NSString *  url = @"getbeerofcustomlist.php";
    NSDictionary * dict = @{@"uid":UserID,@"list_name":pickerArray[tagCustom]};
    
    [WebServiceCalls POST:url parameter:dict completionBlock:^(id JSON, WebServiceResult result)
     {
         SVHUD_STOP
         NSLog(@"%@", JSON);
         
         @try
         {
             if ([JSON[@"success"] integerValue] == 1) {
                 if(JSON[@"beer_details"]){
                     NSMutableArray *arrBeer = [NSMutableArray array];
                     for (int i = 0; i < [JSON[@"beer_details"] count]; i++) {
                         
                         NSString *idstr =  [NSString stringWithFormat:@"%@",JSON[@"beer_details"][i][@"id"]];
                         if (![idstr isEqualToString:@"<null>"]) {
                             [arrBeer addObject: JSON[@"beer_details"][i]];
                         }
                     }
                     
                     [dictCustomBears setObject:arrBeer forKey:pickerArray[tagCustom]];
                     tagCustom++;
                     if (tagCustom < pickerArray.count) {
                         [self performSelector:@selector(getCustomBottols) withObject:nil afterDelay:0];
                     }
                 }
             }  else {
                 // [WebServiceCalls alert:@"Unable to fetch data. try again"];
             }
         }@catch (NSException *exception) {
         }@finally {
         }
     }];
}



- (IBAction)tapSearchResult:(id)sender {
    
    for (NSString *key in checkedBotals) {
        id value = checkedBotals[key];
        [arraySelectedBotals addObject:value];
    }

    if (arraySelectedBotals.count > 0 && radius.length > 0) {
        RadarSearchDetailVC *obj = [[RadarSearchDetailVC alloc]initWithNibName:@"RadarSearchDetailVC" bundle:nil];
        [self.navigationController pushViewController:obj animated:YES];
        obj.arrayBotals = arraySelectedBotals;
    }else{
        [Helper makeToast:@"Select botal and radious both"];
    }
}


@end
