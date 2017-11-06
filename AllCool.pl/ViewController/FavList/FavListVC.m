//
//  FavListVC.m
//  AllCool.pl
//
//  Created by Sanjay on 08/09/17.
//  Copyright © 2017 Sanjay. All rights reserved.
//

#import "FavListVC.h"

@class ACFloatingTextfield;

@interface FavListVC ()
{
    IBOutlet UIButton *btn;
    IBOutlet UIScrollView *scrollData;
    IBOutlet UIView *viewPopup;
    
    IBOutlet ACFloatingTextfield *txtPodasName;
    
    NSMutableArray *arrayImegs;
    NSMutableArray *arrayTitles;
}

@end

@implementation FavListVC

- (void)viewDidLoad{
    [super viewDidLoad];
    
    GET_HEADER_VIEW
    header.title.text = @"Inne Listy";
    
    scrollData.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1];

    btn.layer.borderWidth = 1;
    btn.layer.borderColor = APP_COLOR_RED.CGColor;
    btn.layer.cornerRadius = 2;
    
    [self loadData];
    
}

-(void)loadData
{
    arrayImegs = [NSMutableArray arrayWithArray:@[@"listbeertaste",@"listpubvisit",@"listbrewery",@"listfavbrewer",@"listpubvisit",@"listvisitfestvial",@"listcustom"]];
    arrayTitles = [NSMutableArray arrayWithArray:@[@"Piwa spróbowane",@"Odwiedzone bary",@"Odwiedzone browary",@"Ulubione browary",@"Ulubione festiwale",@"Odwiedzone festiwale",@"Sztosy spróbowane"]];
    
    
    NSDictionary *param =@{@"uid": UserID} ;
    
    
    SVHUD_START
    [WebServiceCalls POST:@"get_customlist.php" parameter:param completionBlock:^(id JSON, WebServiceResult result)
     {
         SVHUD_STOP
         NSLog(@"%@", JSON);
         
         @try
         {
             if ([JSON[@"success"] integerValue] == 1)
             {
                 for (int i = 0; i< [JSON[@"custom"] count]; i++) {
                     [arrayTitles addObject:JSON[@"custom"][i][@"region"]];
                     [arrayImegs addObject:@"listcustom"];
                 }
                 
                 
                 for (int i = 0; i<arrayImegs.count; i++)
                 {
                     int wd = WIDTH/3;
                     
                     UIView *view = [[UIView alloc]initWithFrame:CGRectMake(wd*(i%3), 57 + wd * (int)(i/3),wd,wd)];
                     [scrollData addSubview:view];
                     view.backgroundColor = WHITE_COLOR;
                     view.layer.borderColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1].CGColor;
                     view.layer.borderWidth = 1;
                     
                     UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(wd/6+5,10,wd-wd/3-10,wd- wd/3-10)];
                     [view addSubview:image];
                     image.image = [UIImage imageNamed:arrayImegs[i]];
                     
                     UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(5,wd-40,wd-10,40)];
                     lbl.numberOfLines = 0;
                     lbl.text = arrayTitles[i];
                     [view addSubview:lbl];
                     lbl.textAlignment = NSTextAlignmentCenter;
                     lbl.font = [UIFont systemFontOfSize:14];
                     lbl.textColor = APP_COLOR_RED;
                     
                     UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, wd, wd)];
                     [view addSubview:btn];
                     [btn addTarget: self action:@selector(tapBtn:) forControlEvents:UIControlEventTouchUpInside];
                     btn.tag = i;
                 }
             }
             else
             {
             }
         }
         @catch (NSException *exception)
         {
         }
         @finally
         {
         }
     }];
}

-(void)tapBtn:(UIButton *)sender
{
    if (sender.tag == 0)
    {
        FavBearVC *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"FavBearVC"];
        obj.isBack = true;
        obj.apiTag = 1;
        [self.navigationController pushViewController:obj animated:YES];
    }
    else if (sender.tag == 2 || sender.tag == 3)
    {
        FavBravery *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"FavBravery"];
        obj.isBack = true;
        obj.apiTag = (int)sender.tag - 1;
        [self.navigationController pushViewController:obj animated:YES];
    }
    else if (sender.tag == 4 || sender.tag == 5)
    {
        FestivalListVC *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"FestivalListVC"];
        obj.isBack = true;
        obj.apiTag = (int)sender.tag - 3;
        [self.navigationController pushViewController:obj animated:YES];
    }
    else if (sender.tag == 6)
    {
       
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)tapDodaj:(id)sender {
    
    viewPopup.hidden = false;
}

- (IBAction)tapCroll:(id)sender {
    
    viewPopup.hidden = true;
}

- (IBAction)tapAddList:(id)sender
{
    viewPopup.hidden = true;
}

@end
