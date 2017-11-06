//
//  FloatingButton.h
//  AllCool.pl
//
//  Created by Sanjay on 14/10/17.
//  Copyright © 2017 Sanjay. All rights reserved.
//




#import <UIKit/UIKit.h>
@class FloatingButton;

@protocol floatingButtonDelegate <NSObject>
-(void)didTapOnButtonTag:(NSInteger)tag;

@end;

@interface FloatingButton : UIView
@property (strong, nonatomic) id<floatingButtonDelegate> delegate;


@property(nonatomic,strong)NSArray *array_images;
@property(nonatomic,strong)NSArray *array_titles;

@property(nonatomic,strong)UIView *viewAnimation;
@property(readwrite,nonatomic)float pointAnimateFrom;

@end
