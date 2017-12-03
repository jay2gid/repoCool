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

+(NSInteger )getIntegerDefaultZero:(id)object;

+(void)makeToast:(NSString *)message;

+ (UIViewController*)topViewController;


@end
