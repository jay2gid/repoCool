//
//  UserSession.h
//  Friendsy
//
//  Created by Ashish Kumar Sharma on 13/07/16.
//  Copyright © 2016 Ashish Kumar Sharma. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserSession : NSObject
@property(nonatomic,strong)NSString *FLFirstName;
@property(nonatomic,strong)NSString *FLLastName;
@property(nonatomic,strong)NSString *UserName;

@property(nonatomic,strong)NSString *MobileNum;
@property(nonatomic,strong)NSString *Email;
@property(nonatomic,strong)NSString *City;
@property(nonatomic,strong)NSString *SPUserNameID;
@property(nonatomic,strong)NSData   *image_data;
@property(nonatomic,strong)NSString *Password;
@property(nonatomic,strong)NSString *PostalCode;
@property(nonatomic,strong)NSString *FLIdentificationNumber;
@property(nonatomic,strong)NSString *WebsiteAddress;
@property(nonatomic,strong)NSString *MembershipId;
@property(nonatomic,strong)NSString *MembershipEndDate;
@property(nonatomic,strong)NSString *MembershipStartDate;
@property(nonatomic,strong)NSString *identity;


@property(nonatomic,strong)NSString *IsCompany;
@property(nonatomic,strong)NSString *CompanyAddress;
@property(nonatomic,strong)NSString *CompanyName;
@property(nonatomic,strong)NSString *ProviderBioProfile;


//     "IsRegAsFreelancerFlag" : true,
//     "SPUserNameID" : 67,
//     "Email" : "pankaj000gg1@gmail.com",
//     "Password" : "",
//     "City" : "Jaipur",
//        "Country" : "India",
//        "PostalCode" : "302034",
//        "MobileNum" : "0787714000",
//        "FLIdentificationNumber" : "CBSPP098734",
//        "FLLastName" : "Kumat",
//        "FLFirstName" : "Pankaj",
//        "FLIdentificationPhoto" : "",
//        "WebsiteAddress" : "TWHOUSE.com"

-(void)saveSession;
-(instancetype)initWithSession;
+(void)removeSession;

+(void)updateCart:(NSArray *)array;
+(void)saveNewCart:(NSDictionary *)dic;
+(NSArray*)getPreCart;



+(void)updateData:(NSDictionary *)array;
+(NSDictionary *)getPreData;
+(void)removeCartValues;
@end
