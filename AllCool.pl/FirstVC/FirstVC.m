//
//  FirstVC.m
//  AllCool.pl
//
//  Created by Sanjay on 06/09/17.
//  Copyright © 2017 Sanjay. All rights reserved.
//

#import "FirstVC.h"
@interface FirstVC ()

@end

@implementation FirstVC
{
    NSArray *arrVendor_Festivals;
    GMSMapView *mapView;
    CLLocationManager *lmanager;
}

- (void)viewDidLoad{
    
    [super viewDidLoad];
   
    self.navigationController.viewControllers = @[self];

    
    HIDE_NAV_BAR
    GET_HEADER_VIEW
    
    header.title.text = @"Mapa";
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:0
                                                            longitude:0
                                                                 zoom:10];
    mapView = [GMSMapView mapWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64) camera:camera];
    mapView.delegate = self;
    mapView.myLocationEnabled = YES;
    [self.view addSubview:mapView];
    mapView.settings.myLocationButton = true;

    // mapView.delegate = self;
    
    [self get_Vendor_and_Festivals];
    
    GESTURE_POP
    
    // current location
    
    lmanager = [[CLLocationManager alloc]init];
    [lmanager startUpdatingLocation];
    [lmanager requestWhenInUseAuthorization];
    lmanager.delegate = self;
    
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {

    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:lmanager.location.coordinate.latitude
                                                            longitude:lmanager.location.coordinate.longitude
                                                                 zoom:10];
    
    mapView.camera = camera;
    [lmanager stopUpdatingLocation];
}

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
        float lon = [arrVendor_Festivals[i][@"longitude"] floatValue];
        
        marker.position = CLLocationCoordinate2DMake(lat, lon);
        marker.title = [Helper getString:arrVendor_Festivals[i][@"name"]];
        marker.snippet = [Helper getString:arrVendor_Festivals[i][@"bar_type"]];
        marker.zIndex = i;
        
        
        if ([[[Helper getString:arrVendor_Festivals[i][@"bar_type"]] uppercaseString] isEqualToString:@"PUB"]){
            marker.icon = [UIImage imageNamed:@"smallmappin.png"];
        } else {
            marker.icon = [UIImage imageNamed:@"map_yello.png"];
        }
        
        marker.map = mapView;
        mapView.delegate = self;
        
//        if (i == 0)
//        {
//            GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:lat longitude:lon zoom:5];
//            mapView.camera = camera;
//
//        }
    }
}
-(void)mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(GMSMarker *)marker
{
    PubVC *obj = [[PubVC alloc]initWithNibName:@"PubVC" bundle:nil];
    obj.infoDic = arrVendor_Festivals[marker.zIndex];
    [self.navigationController pushViewController:obj animated:YES];
   
//    if ([[[Helper getString:arrVendor_Festivals[marker.zIndex][@"bar_type"]] uppercaseString] isEqualToString:@"PUB"]){
//
//        PubVC *obj = [[PubVC alloc]initWithNibName:@"PubVC" bundle:nil];
//        obj.infoDic = arrVendor_Festivals[marker.zIndex];
//        [self.navigationController pushViewController:obj animated:YES];
//
//    }else{
//        UIStoryboard *storybord = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        FestivalViewVC *obj = [storybord instantiateViewControllerWithIdentifier:@"FestivalViewVC"];
//        obj.F_ID = [Helper getString:arrVendor_Festivals[marker.zIndex][@"id"]];
//        [self.navigationController pushViewController:obj animated:YES];
//    }
}
- (IBAction)tapCurrentLocation:(id)sender {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


GESTURE_POP_DELEGATE
@end
