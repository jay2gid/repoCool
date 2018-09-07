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


+(NSString *)getStringORZero:(id)object
{
    if (object != nil)
    {
        NSString *value = [NSString stringWithFormat:@"%@",object];
        if (![value isEqualToString:@"<null>"])
        {
            return value;
        }
        return @"0";
    }
    return @"0";
}

+(void)setImageOnPBotal:(UIImageView *)image url:(id)object
{
    NSString *strUrl = [[Helper getString:object] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [image sd_setImageWithURL:[NSURL URLWithString:strUrl] placeholderImage:[UIImage imageNamed:@"noimage.jpg"]];
}


+(void)setImageOnPGlass:(UIImageView *)image url:(id)object
{
    NSString *strUrl = [[Helper getString:object] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [image sd_setImageWithURL:[NSURL URLWithString:strUrl] placeholderImage:[UIImage imageNamed:@"no_image"]];
}




+(NSString*)jsonString:(NSDictionary *) dict {
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
       return  [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
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

+ (NSString *)trimString:(NSString *)object
{
    NSString *str = [object stringByReplacingOccurrencesOfString:@" " withString:@""];
    return [str stringByReplacingOccurrencesOfString:@" " withString:@""];
}


+ (void)openUrl:(NSString *)url{
    
    NSURL *URL = [NSURL URLWithString:url];
    
    if ([[UIApplication sharedApplication] canOpenURL:URL]) {
        [[UIApplication sharedApplication] openURL:URL];
    }else{
        NSString *text = [@"http://" stringByAppendingString:url];
        URL = [NSURL URLWithString:text];
        
        if ([[UIApplication sharedApplication] canOpenURL:URL]) {
            [[UIApplication sharedApplication] openURL:URL];
        }else{
            
        }
        
    }
}


+ (void)callToNumber:(NSString *)number{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",number]]];
}


@end
