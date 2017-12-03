//
//  Helper.m
//  AllCool.pl
//
//  Created by Sanjay on 29/11/17.
//  Copyright © 2017 Sanjay. All rights reserved.
//

#import "Helper.h"

@implementation Helper

+(NSString *)getString:(id)object
{
    if (object != nil)
    {
        NSString *value = [NSString stringWithFormat:@"%@",object];
        if (![value isEqualToString:@"<null>"])
        {
            return value;
        }
        return @"";
    }
    return @"";
}


+(NSInteger)getIntegerDefaultZero:(id)object;
{
    if (object)
    {
        NSString *value = [NSString stringWithFormat:@"%@",object];
        if (![value isEqualToString:@"<null>"])
        {
            return [value integerValue];
        }
        return 0;
    }
    return 0;
}


+(void)makeToast:(NSString *)message
{
    [[AppDelegate delegate].navigationController.view makeToast:message];;
}

+ (UIViewController*)topViewController
{
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
    
    return topController;
}



@end
