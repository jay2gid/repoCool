//
//  Helper.h
//  AllCool.pl
//
//  Created by Sanjay on 29/11/17.
//  Copyright © 2017 Sanjay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Helper : NSObject

+(NSString *)getString:(id)object;
+(NSString *)getStringORZero:(id)object;

+(NSInteger )getIntegerDefaultZero:(id)object;

+(void)makeToast:(NSString *)message;

+ (UIViewController*)topViewController;
+ (NSString *)trimString:(NSString *)object;

+(NSString*)jsonString:(NSDictionary *) dict;

+(void)setImageOnPBotal:(UIImageView *)image url:(id)object;
+(void)setImageOnPGlass:(UIImageView *)image url:(id)object;

+ (void)openUrl:(NSString *)url;
+ (void)callToNumber:(NSString *)number;

@end
