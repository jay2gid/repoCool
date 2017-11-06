//
//  UserSession.m
//  Friendsy
//
//  Created by Ashish Kumar Sharma on 13/07/16.
//  Copyright © 2016 Ashish Kumar Sharma. All rights reserved.
//

#import "UserSession.h"

@implementation UserSession
@synthesize Email,FLLastName,FLFirstName,FLIdentificationNumber,City,Password,MobileNum,SPUserNameID,WebsiteAddress,MembershipId,MembershipEndDate,MembershipStartDate,identity,UserName,image_data,CompanyName,IsCompany,CompanyAddress,ProviderBioProfile;

-(void)saveSession
{
    [[NSUserDefaults standardUserDefaults]setObject:Email forKey:@"Email"];
    [[NSUserDefaults standardUserDefaults]setObject:FLLastName forKey:@"FLLastName"];
    [[NSUserDefaults standardUserDefaults]setObject:FLFirstName forKey:@"FLFirstName"];
    [[NSUserDefaults standardUserDefaults]setObject:UserName forKey:@"UserName"];
    [[NSUserDefaults standardUserDefaults]setObject:image_data forKey:@"image_data"];
    
    [[NSUserDefaults standardUserDefaults]setObject:FLIdentificationNumber forKey:@"FLIdentificationNumber"];
    [[NSUserDefaults standardUserDefaults]setObject:City forKey:@"City"];
    [[NSUserDefaults standardUserDefaults]setObject:Password forKey:@"Password"];
    
    [[NSUserDefaults standardUserDefaults]setObject:MobileNum forKey:@"MobileNum"];
    [[NSUserDefaults standardUserDefaults]setObject:SPUserNameID forKey:@"SPUserNameID"];
    [[NSUserDefaults standardUserDefaults]setObject:WebsiteAddress forKey:@"WebsiteAddress"];
    [[NSUserDefaults standardUserDefaults]setObject:MembershipId forKey:@"MembershipId"];
    [[NSUserDefaults standardUserDefaults]setObject:MembershipEndDate forKey:@"MembershipEndDate"];
    [[NSUserDefaults standardUserDefaults]setObject:MembershipStartDate forKey:@"MembershipStartDate"];
    
    [[NSUserDefaults standardUserDefaults]setObject:identity forKey:@"identity"];
    
    [[NSUserDefaults standardUserDefaults]setObject:IsCompany forKey:@"IsCompany"];
    [[NSUserDefaults standardUserDefaults]setObject:CompanyAddress forKey:@"CompanyAddress"];
    [[NSUserDefaults standardUserDefaults]setObject:ProviderBioProfile forKey:@"ProviderBioProfile"];
    [[NSUserDefaults standardUserDefaults]setObject:CompanyName forKey:@"CompanyName"];

}

- (instancetype)initWithSession
{
    Email = [[NSUserDefaults standardUserDefaults]objectForKey:@"Email"];
    FLLastName = [[NSUserDefaults standardUserDefaults]objectForKey:@"FLLastName"];
    FLFirstName = [[NSUserDefaults standardUserDefaults]objectForKey:@"FLFirstName"];
    UserName = [[NSUserDefaults standardUserDefaults]objectForKey:@"UserName"];
    image_data = [[NSUserDefaults standardUserDefaults]objectForKey:@"image_data"];
    
    FLIdentificationNumber = [[NSUserDefaults standardUserDefaults]objectForKey:@"FLIdentificationNumber"];
    City = [[NSUserDefaults standardUserDefaults]objectForKey:@"City"];
    Password = [[NSUserDefaults standardUserDefaults]objectForKey:@"Password"];
    MobileNum = [[NSUserDefaults standardUserDefaults]objectForKey:@"MobileNum"];
    SPUserNameID = [[NSUserDefaults standardUserDefaults]objectForKey:@"SPUserNameID"];
    WebsiteAddress = [[NSUserDefaults standardUserDefaults]objectForKey:@"WebsiteAddress"];
    MembershipId = [[NSUserDefaults standardUserDefaults]objectForKey:@"MembershipId"];
    
    MembershipEndDate = [[NSUserDefaults standardUserDefaults]objectForKey:@"MembershipEndDate"];
    MembershipStartDate = [[NSUserDefaults standardUserDefaults]objectForKey:@"MembershipStartDate"];
    
    identity = [[NSUserDefaults standardUserDefaults]objectForKey:@"identity"];
    
    CompanyAddress = [[NSUserDefaults standardUserDefaults]objectForKey:@"MembershipId"];
    CompanyName = [[NSUserDefaults standardUserDefaults]objectForKey:@"MembershipEndDate"];
    IsCompany = [[NSUserDefaults standardUserDefaults]objectForKey:@"MembershipStartDate"];
    
    identity = [[NSUserDefaults standardUserDefaults]objectForKey:@"identity"];

    
    return self;
}

+(void)removeSession
{
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"SPUserNameID"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"email"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"userid"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"password"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"username"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"userData"];
}

+(void)saveNewCart:(NSDictionary *)dic;
{
    NSMutableArray *arr = [NSMutableArray array];
    
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"ArrCart"])
    {
        arr = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults]objectForKey:@"ArrCart"]];
    }
    
    [arr addObject:dic];
    [[NSUserDefaults standardUserDefaults]setObject:arr forKey:@"ArrCart"];
}

+(NSArray*)getPreCart
{
    return [[NSUserDefaults standardUserDefaults]objectForKey:@"ArrCart"];
}

+(void)updateCart:(NSArray *)array
{
    [[NSUserDefaults standardUserDefaults]setObject:array forKey:@"ArrCart"];
}

+(void)removeCartValues
{
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"ArrCart"];
}

+(void)updateData:(NSDictionary *)array
{
    [[NSUserDefaults standardUserDefaults]setObject:array forKey:@"data"];
}

+(NSDictionary *)getPreData
{
    return [[NSUserDefaults standardUserDefaults]objectForKey:@"data"];
}

@end
