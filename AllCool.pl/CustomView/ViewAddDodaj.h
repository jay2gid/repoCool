//
//  ViewAddDodaj.h
//  AllCool.pl
//
//  Created by Sanjay on 25/09/17.
//  Copyright © 2017 Sanjay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewAddDodaj : TPKeyboardAvoidingScrollView<UITextViewDelegate>

@property (strong, nonatomic) IBOutlet UIButton *btnOK;

@property (strong, nonatomic) IBOutlet UITextView *txtNote;

@end
