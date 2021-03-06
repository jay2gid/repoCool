//
//  DrewerVeiw.m
//  AllCool.pl
//
//  Created by Sanjay on 07/09/17.
//  Copyright © 2017 Sanjay. All rights reserved.
//

#import "DrewerVeiw.h"
#import "ProfilVC.h"
#import "ActivityVC.h"
@implementation DrewerVeiw
{
    NSArray *imageArray,*titleArray;
}
@synthesize tap_view,table,backSelf;
- (void)drawRect:(CGRect)rect {
    
    
    self.frame = CGRectMake(-WIDTH, 0, WIDTH, HEIGHT);
    [UIView animateWithDuration:0.2 animations:^{
        self.frame = backSelf.view.frame;
    }];
    
    titleArray = @[@"Mapa",@"Ulubione bary",@"Ulubione piwa",@"Browary",@"Festiwale piwne",@"Inne listy",@"Radar",@"Aktywność",@"Profil",@"Ustawienia",@"Wyloguj się"];
    
    imageArray = @[@"route",@"favpub",@"favbeer",@"barrel",@"rock_and_roll",@"otherlist",@"radarr",@"activity",@"useredit",@"settingss",@"circle_logout"];
    
    table.delegate = self;
    table.dataSource = self;
    [table reloadData];
    table.showsVerticalScrollIndicator = false;
    table.bounces = false;
}


#pragma mark Table

-(CGFloat)tableView:(UITableView* )tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return titleArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"DrewerView" owner:self options:nil]objectAtIndex:1];
    
    
    UIImageView *image = [cell viewWithTag:1];
    image.image = [UIImage imageNamed:[imageArray objectAtIndex:indexPath.row]];
    
    image.image = [image.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [image setTintColor:[UIColor grayColor]];
    
    
    UILabel *lbl = [cell viewWithTag:2];
    
    lbl.text = [NSString stringWithFormat:@"%@",[titleArray objectAtIndex:indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UIStoryboard *storyBorad = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    NSArray *array = @[@"FirstVC",@"FavBravery",@"FavBearVC",@"BrowaryVC",@"FestivalListVC",@"FavListVC",@"RadarVC",@"",@"",@"SettingVC",@"LoginVC"];
    if (indexPath.row < 7)
    {
        if (indexPath.row == 0)
            [self.backSelf.navigationController popToRootViewControllerAnimated:true];
        
        UIViewController *con = [storyBorad instantiateViewControllerWithIdentifier:array[indexPath.row]];
        
        [self.backSelf.navigationController pushViewController:con animated:YES];
    }
    else if (indexPath.row == 7 )
    {
        ActivityVC *obj = [[ActivityVC alloc]initWithNibName:@"ActivityVC" bundle:nil];
        [self.backSelf.navigationController pushViewController:obj animated:YES];
    }
    else if ( indexPath.row == 8)
    {
        ProfilVC *obj = [[ProfilVC alloc]initWithNibName:@"ProfilVC" bundle:nil];
        [self.backSelf.navigationController pushViewController:obj animated:YES];
    }
    else if (indexPath.row == 9)
    {
        UIViewController *con = [storyBorad instantiateViewControllerWithIdentifier:array[indexPath.row]];
        [self.backSelf.navigationController pushViewController:con animated:YES];
    }
    else
    {
        [self logOut];
    }
}

-(void)logOut{
    
    UIAlertController * view = [UIAlertController
                                alertControllerWithTitle:@"Log out!!"
                                message:@""
                                preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* yes = [UIAlertAction
                          actionWithTitle:@"Yes"
                          style:UIAlertActionStyleDefault
                          handler:^(UIAlertAction * action)
                          {
                              [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userid"];
                              UIViewController *con = [self.backSelf.storyboard instantiateViewControllerWithIdentifier:@"LoginVC"];
                              [self.backSelf.navigationController pushViewController:con animated:NO];
                              
                          }];
    
    UIAlertAction* cancel = [UIAlertAction
                              actionWithTitle:@"No"
                              style:UIAlertActionStyleCancel
                              handler:^(UIAlertAction * action)
                              {  }];
                             
                             
     [view addAction:yes];
     [view addAction:cancel];
     [self.backSelf presentViewController:view animated:YES completion:nil];
                             
                             
                             
}


- (IBAction)tap:(id)sender {
    
    [UIView animateWithDuration:0.2 animations:^{
        self.frame = CGRectMake(-WIDTH, 0, WIDTH, HEIGHT);
    }];
    
}


@end
