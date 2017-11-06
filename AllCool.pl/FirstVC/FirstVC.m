//
//  FirstVC.m
//  AllCool.pl
//
//  Created by Sanjay on 06/09/17.
//  Copyright © 2017 Sanjay. All rights reserved.
//

#import "FirstVC.h"
@import GoogleMaps;
@import GooglePlaces;

@interface FirstVC ()

@end

@implementation FirstVC
{
    NSArray *arrVendor_Festivals;
    GMSMapView *mapView;
}

- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    HIDE_NAV_BAR
    GET_HEADER_VIEW
    
    header.title.text = @"Map";
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:28.33
                                                            longitude:77.100
                                                                 zoom:7];
    mapView = [GMSMapView mapWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64) camera:camera];
    
    mapView.myLocationEnabled = YES;
    [self.view addSubview:mapView];
    // mapView.delegate = self;
    
    [self get_Vendor_and_Festivals];
    //[self performSelector:@selector(set_Camera) withObject:nil afterDelay:2];
}

/*-(void) set_Camera
{
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:mapView.myLocation.coordinate.latitude
                                                            longitude:mapView.myLocation.coordinate.longitude
                                                                 zoom:7];
    mapView = [GMSMapView mapWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64) camera:camera];
}*/

-(void) get_Vendor_and_Festivals
{
    // http://allcool.pl/api_ios/vendorss/vendor_and_festivals.php
    
    SVHUD_START
    [WebServiceCalls GET:@"vendorss/vendor_and_festivals.php" parameter:nil completionBlock:^(id JSON, WebServiceResult result)
     {
         SVHUD_STOP
         NSLog(@"%@", JSON);
         
         @try
         {
             if ([JSON[@"success"] integerValue] == 1)
             {
                 arrVendor_Festivals = JSON[@"products"];
                 [self AddMarker];
             }
             else
             {
                 //[WebServiceCalls alert:@"Unable to fetch data. try again"];
             }
         }
         @catch (NSException *exception)
         {
         }
         @finally
         {
         }
     }];
}

-(void) AddMarker
{
    for (int i=0; i<=arrVendor_Festivals.count; i++)
    {
        // Creates a marker in the center of the map.
        GMSMarker *marker = [[GMSMarker alloc] init];
        
        float lat = [arrVendor_Festivals[i][@"latitude"] floatValue];
        float lon = [arrVendor_Festivals[i][@"latitude"] floatValue];
        
        marker.position = CLLocationCoordinate2DMake(lat, lon);
        marker.title = arrVendor_Festivals[i][@"name"];
        marker.snippet = arrVendor_Festivals[i][@"bar_type"];
        
        if ([arrVendor_Festivals[i][@"usertype"] integerValue] == 1)
        {
            marker.icon = [UIImage imageNamed:@"smallmappin.png"];
        }
        else
        {
            marker.icon = [UIImage imageNamed:@"map_yello.png"];
        }
        
        marker.map = mapView;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
