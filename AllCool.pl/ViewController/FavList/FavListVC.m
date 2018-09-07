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
    NSInteger selectedIndex;
    
    BOOL isEdit;
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
    arrayImegs = [NSMutableArray arrayWithArray:@[@"listbeertaste",@"listpubvisit",@"listbrewery",@"listfavbrewer",@"listpubvisit",@"listvisitfestvial"]];
    arrayTitles = [NSMutableArray arrayWithArray:@[@"Piwa spróbowane",@"Odwiedzone bary",@"Odwiedzone browary",@"Ulubione browary",@"Ulubione festiwale",@"Odwiedzone festiwale"]];

    for (int i = 0; i<arrayImegs.count; i++)
    {
        [self addCustomList:i];
    }
    
    
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
                 
                 
                 for (int i = 6; i<arrayImegs.count; i++)
                 {
                     [self addCustomList:i];
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
    else if (sender.tag == 1 )
    {
        FavBravery *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"FavBravery"];
        obj.isBack = true;
        obj.apiTag = (int)sender.tag ;
        [self.navigationController pushViewController:obj animated:YES];
    }
    
    else if (sender.tag == 2 || sender.tag == 3)
    {
            BraveryList *obj =[[BraveryList alloc]initWithNibName:@"BraveryList" bundle:nil];
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
    else
    {
        FavBearVC *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"FavBearVC"];
        obj.isBack = true;
        obj.apiTag = 2;
        obj.customListName = arrayTitles[sender.tag ];
        [self.navigationController pushViewController:obj animated:YES];
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
//    $userid = $_POST["uid"];
//    $cus_listname = $_POST["listname"];
    
    if (txtPodasName.text.length < 3) {
        [Helper makeToast:@"Enter valid name"];
        return;
    }
    
    
    if (isEdit) {
        isEdit = false;
         //txtPodasName.text = [self ]
         //
        
        NSDictionary *param =@{@"uid": UserID,
                               @"editlistname":txtPodasName.text,
                               @"oldlistname":arrayTitles[selectedIndex]} ;
       
        HIDE_KEY
        SVHUD_START
        [WebServiceCalls POST:@"edit_customlist_recod.php" parameter:param completionBlock:^(id JSON, WebServiceResult result)
         {
             SVHUD_STOP
             NSLog(@"%@", JSON);
             
             
             @try
             {
                 [Helper makeToast:[Helper getString:JSON[@"message"]]];
                 if ([JSON[@"success"] integerValue] == 1)
                 {
                     [arrayTitles replaceObjectAtIndex:selectedIndex withObject:txtPodasName.text];
                     txtPodasName.text = @"";
                     [self addCustomList:selectedIndex];
                 }
                 else
                 {
                     
                 }
             }
             @catch (NSException *exception) {
             }
             @finally {
             }
             
         }];
    }
    else
    {
    
        NSDictionary *param =@{@"uid": UserID,@"listname":txtPodasName.text} ;

    SVHUD_START
    [WebServiceCalls POST:@"add_customlist.php" parameter:param completionBlock:^(id JSON, WebServiceResult result)
     {
         SVHUD_STOP
         NSLog(@"%@", JSON);
         
         
         @try
         {
             [Helper makeToast:[Helper getString:JSON[@"message"]]];
             if ([JSON[@"success"] integerValue] == 1)
             {
                 [arrayTitles addObject:txtPodasName.text];
                 [arrayImegs addObject:@"listcustom"];
                 txtPodasName.text = @"";
                
                 [self addCustomList:arrayTitles.count-1];

             }
             else
             {
                 
             }
         }
         @catch (NSException *exception) {
         }
         @finally {
         }
     }];
    }
    viewPopup.hidden = true;

}

-(void)addCustomList:(NSInteger )index
{
    int wd = WIDTH/3;

    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(wd*(index%3), 57 + wd * (int)(index/3),wd,wd)];
    [scrollData addSubview:view];
    view.backgroundColor = WHITE_COLOR;
    view.layer.borderColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1].CGColor;
    view.layer.borderWidth = 1;
    view.tag = index + 1000;
    
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(wd/6+5,10,wd-wd/3-10,wd- wd/3-10)];
    [view addSubview:image];
    image.image = [UIImage imageNamed:arrayImegs[index]];
    
    UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(5,wd-40,wd-10,40)];
    lbl.numberOfLines = 0;
    lbl.text = arrayTitles[index];
    [view addSubview:lbl];
    lbl.textAlignment = NSTextAlignmentCenter;
    lbl.font = [UIFont systemFontOfSize:14];
    lbl.textColor = APP_COLOR_RED;
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, wd, wd)];
    [view addSubview:btn];
    [btn addTarget: self action:@selector(tapBtn:) forControlEvents:UIControlEventTouchUpInside];
    btn.tag = index;
    
    if (index > 5){
    btn = [[UIButton alloc]initWithFrame:CGRectMake(wd-30, 0, 30, 30)];
    [view addSubview:btn];
        [btn addTarget: self action:@selector(tapOption:) forControlEvents:UIControlEventTouchUpInside];
    btn.tag = index;
    [btn setImage:[UIImage imageNamed:@"three_dot"] forState:UIControlStateNormal];
    }
}


-(void)tapOption:(UIButton *)sender
{
    selectedIndex = sender.tag;
    
    UIAlertController * view = [UIAlertController
                                alertControllerWithTitle:@""
                                message:@""
                                preferredStyle:UIAlertControllerStyleActionSheet];
    
    
    
    
    
    UIAlertAction* action1 = [UIAlertAction
                              actionWithTitle:@"Powiel liste"
                              style:UIAlertActionStyleDefault
                              handler:^(UIAlertAction * action)
                              {
                                 // txtPodasName.text = [self ]
                              }];
    
    
    UIAlertAction* action2 = [UIAlertAction actionWithTitle:@"Skasuj liste"  style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * action)  {
                                  
                                  
                                  NSDictionary *param =@{@"uid": UserID,@"listname":txtPodasName.text} ;
                                  
                                  
                                  SVHUD_START
                                  [WebServiceCalls POST:@"delete_customlistrecod.php" parameter:param completionBlock:^(id JSON, WebServiceResult result)
                                   {
                                       SVHUD_STOP
                                       NSLog(@"%@", JSON);
                                       
                                       @try
                                       {
                                           [Helper makeToast:[Helper getString:JSON[@"message"]]];
                                           if ([JSON[@"success"] integerValue] == 1)
                                           {
                                               UIView *view = [scrollData viewWithTag:arrayTitles.count-1+1000];
                                               [view removeFromSuperview];
                                               [arrayImegs removeObjectAtIndex:selectedIndex];
                                               [arrayTitles removeObjectAtIndex:selectedIndex];
                                               
                                               for (int i = 6; i<arrayImegs.count; i++) {
                                                   UIView *view = [scrollData viewWithTag:i+1000];
                                                   [view removeFromSuperview];

                                                   [self addCustomList:i];
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
                                  
                                  
                                  
                              }];
    
    
    UIAlertAction* action3 = [UIAlertAction actionWithTitle:@"Edytuj liste" style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * action)
                              {
                                  isEdit = true;
                                  txtPodasName.text = [arrayTitles objectAtIndex:selectedIndex];
                                  [self tapDodaj:@""];
                              }];
    
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel
                                                   handler:^(UIAlertAction * action)
                             {
                                 
                                 
                             }];
    
    [view addAction:action1];
    [view addAction:action2];
    [view addAction:action3];
    
    [view addAction:cancel];
    [self presentViewController:view animated:YES completion:nil];
}





@end
