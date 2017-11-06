//
//  ViewAddDodaj.m
//  AllCool.pl
//
//  Created by Sanjay on 25/09/17.
//  Copyright © 2017 Sanjay. All rights reserved.
//

#import "ViewAddDodaj.h"

@implementation ViewAddDodaj
{
    UILabel *lbl;
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    lbl = [[UILabel alloc] initWithFrame:CGRectMake(8.0, 0.0,_txtNote.frame.size.width - 10.0, 34.0)];
    
    
    [lbl setText:@"Enter Note"];
    [lbl setBackgroundColor:[UIColor clearColor]];
    [lbl setTextColor:[UIColor lightGrayColor]];
    
    [_txtNote addSubview:lbl];
    _txtNote.delegate  = self;
}

- (IBAction)btnSendClk:(id)sender
{
    
}

- (IBAction)tapCancel:(UIButton *)sender
{
    [self removeFromSuperview];
}
- (void)textViewDidEndEditing:(UITextView *)theTextView
{
    if (![theTextView hasText]) {
        lbl.hidden = NO;
    }
}

- (void) textViewDidChange:(UITextView *)textView
{
    if(![textView hasText]) {
        lbl.hidden = NO;
    }
    else{
        lbl.hidden = YES;
    }
}



@end
