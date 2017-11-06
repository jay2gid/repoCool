//
//  WebServiceCalls.m
//  Ponder_remake
//
//  Created by Yudiz Solutions on 04/07/13.
//  Copyright (c) 2013 Yudiz Solutions. All rights reserved.
//

#import "WebServiceCalls.h"
#import "AFNetworking.h"

#define BASE_URL @"http://allcool.pl/api_ios/"

static AFHTTPRequestOperationManager *manager;

@interface WebServiceCalls(){
    
}
@end

static NSString *getuserphone;

@implementation WebServiceCalls

+ (void)initialize
{
    manager = [[AFHTTPRequestOperationManager alloc] init];
    manager.securityPolicy.allowInvalidCertificates = YES;//This is for https
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
}

+ (void)POSTJSON:(NSString *)url parameter:(NSString *)parameter completionBlock:(WebCallBlock)block
{
    @try
    {
        if([WebServiceCalls isNetwork]==YES)
        {
            NSData *postData = [parameter dataUsingEncoding:NSASCIIStringEncoding];
            NSURL *urlStr=  [NSURL URLWithString:[[NSString stringWithFormat:@"%@%@",BASE_URL,url] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:urlStr];
            
            [request setHTTPBody:postData];
            [request setHTTPMethod:@"POST"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            
            NSError *error = NULL;
            NSURLResponse *response = NULL;
            NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error ];
            id responce = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            block(responce,WebServiceResultSuccess);
        }
    }
    @catch (NSException *exception)
    {
        block(@"1",WebServiceResultFail);
    }
}


+ (void)POST:(NSString *)url parameter:(NSDictionary *)parameter completionBlock:(WebCallBlock)block
{
    if ([self isNetwork])
    {
        @try
        {
            NSString *URLSTRING = [NSString stringWithFormat:@"%@%@",BASE_URL,url];
            [manager POST:[URLSTRING stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] parameters:parameter constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
             {}
             success:^(AFHTTPRequestOperation *operation, id responseObject)
             {
                 NSMutableArray * responseJson = [[NSMutableArray alloc]init];
                 responseJson = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
                
                 if (responseJson)
                     block(responseJson,WebServiceResultSuccess);
                 else
                     block(@{@"message":@"Error : Could not getting proper responce"},WebServiceResultFail);

             }
            failure:^(AFHTTPRequestOperation *operation, NSError* error)
             {
                 [SVProgressHUD dismiss];
                  block(@{@"message":@"Error : Server Problem"},WebServiceResultFail);
             }];
        }
        @catch (NSException *exception)
        {
            block(@{@"message":@"Error"},WebServiceResultFail);
        }
    }
}

+ (void)POST:(NSString *)url parameter:(NSDictionary *)parameter imageData:(NSData *)imageData completionBlock:(WebCallBlock)block
{
    
    @try
    {
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
        manager.securityPolicy.allowInvalidCertificates = YES;//This is for https
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        [manager POST:url parameters:parameter constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
         {
             [formData appendPartWithFileData:imageData name:@"userImage" fileName:@"userImage.jpg" mimeType:@"image/jpeg"];
         }
              success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             
             NSMutableArray * responseJson = [[NSMutableArray alloc]init];
             responseJson = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
             block(responseJson,WebServiceResultSuccess);
             
         }
         
              failure:^(AFHTTPRequestOperation *operation, NSError* error)
         {
             block(@"1",WebServiceResultSuccess);
             
         }];
        
    }
    @catch (NSException *exception)
    {
        block(@"1",WebServiceResultSuccess);
    }
    
}

+ (void)GET:(NSString *)url parameter:(NSDictionary *)parameter completionBlock:(WebCallBlock)block
{
    
    
    @try
    {
        
        NSString *URLSTRING = [NSString stringWithFormat:@"%@%@",BASE_URL,url];
        [manager GET:[URLSTRING stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject)
         {
             [SVProgressHUD dismiss];
             NSMutableArray * responseJson = [[NSMutableArray alloc]init];
             responseJson = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
             block(responseJson,WebServiceResultSuccess);
             
         } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
             [SVProgressHUD dismiss];
             block(@"1",WebServiceResultSuccess);
             
         }];
        
        /*NSURL *urlStr=  [NSURL URLWithString:[[NSString stringWithFormat:@"%@%@",BASE_URL,url] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
         NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:urlStr];
         NSError *error = NULL;
         NSURLResponse *response = NULL;
         NSData *data  = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error ];
         NSDictionary *vehicel_dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
         block(vehicel_dic,WebServiceResultSuccess);*/
        
    }
    @catch (NSException *exception)
    {
        block(@"1",WebServiceResultSuccess);
        UIAlertView *aler = [[UIAlertView alloc]initWithTitle:@"Network Error" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [aler show];
    }
    
}

+(void)warningAlert:(NSString *)alertString
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert !" message:alertString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}
+(void)alert:(NSString *)alertString
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:alertString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

+(void)alertTitle:(NSString *)title message:(NSString *)alertString
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title message:alertString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}
+(void)validataionAlert:(NSString *)alertString
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert !" message:alertString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

+(BOOL)isNetwork
{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable)
    {
        SVHUD_STOP
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Network Error" message:@"Check internet connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }
    else
    {
        return YES;
    }
}

+(NSString *)getCurrentDate
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    return [dateFormatter stringFromDate:[NSDate date]];
}

+(BOOL)isValidEmail:(NSString *)email
{
    NSString *emailRegEx =
    @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
    BOOL isvalid =[emailTest evaluateWithObject:email];
    return isvalid;
}

+(BOOL)isValidPhone:(NSString *)phone;
{
    NSString *phoneRegex = @"[0-9]{6,14}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    
    BOOL isvalid =[phoneTest evaluateWithObject:phone];
    return isvalid;
}

+(UIColor*)colorWithHexString:(NSString*)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}


+ (NSString *)dateFromString:(NSString *)date
{
    //    2018-04-26T09:13:27.452Z
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate * timeNotFormatted = [dateFormatter dateFromString:[date substringWithRange:NSMakeRange(0, 10)]];
    
    [dateFormatter setDateFormat:@"dd MMMM yyyy"];
    return  [dateFormatter stringFromDate:timeNotFormatted];
    
}

+ (NSString *)dateStringForDate:(NSString *)date
{
    @try
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        NSDate * timeNotFormatted = [dateFormatter dateFromString:date];
        
        [dateFormatter setDateFormat:@"dd MMMM yyyy  HH:mm a"];
        NSString *timeStampS = [dateFormatter stringFromDate:timeNotFormatted];
        
        return timeStampS;
        
        /*
         NSDate * current = [dateFormatter dateFromString:timeStampS];
         NSString *timeStamp = @"";
         NSCalendarUnit units = NSCalendarUnitSecond | NSCalendarUnitMinute | NSCalendarUnitHour | NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitWeekday | NSCalendarUnitWeekOfYear;
         
         NSCalendar *calendar = [NSCalendar currentCalendar];
         NSDateComponents *components = [calendar components:units fromDate:timeNotFormatted toDate:current options:NSCalendarWrapComponents];
         
         if (components.year >= 1) {
         
         if (components.year == 1)
         {
         timeStamp = @"Last year";
         }
         else
         {
         timeStamp = [NSString stringWithFormat:@"%ld years ago", (long)components.year];
         }
         }
         else if (components.month >= 1) {
         
         if (components.month == 1)
         {
         timeStamp = @"Last month";
         }
         else
         {
         timeStamp = [NSString stringWithFormat:@"%ld months ago", (long)components.month];
         }
         }
         else if (components.weekOfYear >= 1)
         {
         
         }
         if (components.weekOfYear == 1)
         {
         timeStamp = @"Last Week";
         }
         else {
         timeStamp = [NSString stringWithFormat:@"%ld weeks ago", (long)components.weekOfYear];
         }
         }
         else if (components.day >= 1) {
         
         if (components.day == 1) {
         timeStamp = @"Yesterday";
         }
         else {
         timeStamp = [NSString stringWithFormat:@"%ld days ago", (long)components.day];
         }
         }
         else if (components.hour >= 1) {
         
         if (components.hour == 1) {
         timeStamp = @"An hour ago";
         }
         else {
         timeStamp = [NSString stringWithFormat:@"%ld hours ago", (long)components.hour];
         }
         }
         else if (components.minute >= 1) {
         
         if (components.minute == 1) {
         timeStamp = @"A minute ago";
         }
         else {
         timeStamp = [NSString stringWithFormat:@"%ld minutes ago", (long)components.minute];
         }
         }
         else if (components.second > 15) {
         timeStamp = [NSString stringWithFormat:@"%ld seconds ago", (long)components.second];
         }
         else {
         timeStamp = @"Just Now";
         }
         
         return timeStamp;
         
         */
        
    } @catch (NSException *exception) { } @finally { }
}

+(void)showMbError:(NSString *)message con:(UIViewController *)con
{
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:con.navigationController.view];
    [con.navigationController.view addSubview:HUD];
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_check.png"]];
    HUD.mode = MBProgressHUDModeCustomView;
    
    // HUD.delegate = self;
    HUD.labelText = message;
    
    [HUD show:YES];
    [HUD hide:YES afterDelay:2];
}

@end
