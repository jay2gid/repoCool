//
//  FloatingButton.m
//  AllCool.pl
//
//  Created by Sanjay on 14/10/17.
//  Copyright © 2017 Sanjay. All rights reserved.
//

#import "FloatingButton.h"
#import "FloatingButtonCell.h"
@implementation FloatingButton
@synthesize array_images,array_titles,viewAnimation;

- (void)drawRect:(CGRect)rect {

    self.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
    
    viewAnimation = [[UIView alloc]initWithFrame:CGRectMake(0,0, WIDTH, _pointAnimateFrom)];
    [self addSubview:viewAnimation];
    viewAnimation.clipsToBounds = true;
    
    for (int i = 0; i < 4 ; i++)
    {
        FloatingButtonCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"FloatingButtonCell" owner:self options:nil]objectAtIndex:0];
        cell.frame = CGRectMake(0,80*i+_pointAnimateFrom,WIDTH ,80);
        cell.btn_tap.tag = i+1;
        cell.tag = 100+i+1;
        [viewAnimation addSubview:cell];
        cell.lbl_title.text = @"Title";
        [cell.btn_tap addTarget:self action:@selector(tapOnCell:) forControlEvents:UIControlEventTouchUpInside];
    }
    [self animate];
}
-(void)animate
{
    
    [UIView animateWithDuration:0.5 animations:^{
        
        for (int i = 0; i < 4 ; i++)
        {
            FloatingButtonCell *cell = [self viewWithTag:100+i+1];
            cell.frame = CGRectMake(0,cell.frame.origin.y - 320,WIDTH ,80);
        }

    }];
}
-(void)tapOnCell:(UIButton *)sender
{
    
}

@end
