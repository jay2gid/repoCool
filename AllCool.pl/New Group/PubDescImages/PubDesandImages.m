//
//  PubDesandImages.m
//  AllCool.pl
//
//  Created by Sanjay on 27/11/17.
//  Copyright © 2017 Sanjay. All rights reserved.
//

#import "PubDesandImages.h"

@interface PubDesandImages ()
{
    IBOutlet UIScrollView *ScrollView;
    IBOutlet UILabel *lblDesc;
    
    NSArray *arrayImages;
    NSInteger heightLabel;
    
}
@end

@implementation PubDesandImages

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)loadImges
{
    float width = ( WIDTH - 3) / 2;
    
    for (int i = 0; i < arrayImages.count ; i++)
    {
        
        UIImage *image ;
        
        UIButton *buttonImage = [[UIButton alloc]initWithFrame:CGRectMake((1 + width) * (i%2),heightLabel + ( width + 1)* i/2 , width, width)];
        [buttonImage setImage:image forState:UIControlStateNormal];
        buttonImage.tag = i;
        [buttonImage addTarget:self action:@selector(tapButtonImage:) forControlEvents:UIControlEventTouchUpInside];
        [ScrollView addSubview:buttonImage];
        
    }
}

-(void)tapButtonImage:(UIButton *)sender
{
    
}

@end
