//
//  ViewController.m
//  MapSample2
//
//  Created by Kumar C on 3/2/16.
//  Copyright © 2016 Kumar C. All rights reserved.
//

#import "ViewController.h"
#import "LocationUtil.h"
#import <MapKit/MapKit.h>

#import "HUDUtil.h"
#import "MapViewAnnotation.h"

@interface ViewController () <UITextFieldDelegate, MKMapViewDelegate>

@property (nonatomic, weak) IBOutlet MKMapView *mapView;

@property (nonatomic, weak) IBOutlet UITextField *locationField;

@property (nonatomic, assign) CLLocationCoordinate2D location2D;

@property (nonatomic, strong) CLGeocoder *geocoder;

@property (nonatomic, strong) CLPlacemark *placemark;

@property (nonatomic, strong) MapViewAnnotation *previousAnnotation;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    __weak ViewController *weakSelf = self;
    [[LocationUtil sharedUtil] getCurrentLocationWithCompletion:^(BOOL success, CLLocationCoordinate2D fromLocation, CLLocationCoordinate2D toLocation, NSString * _Nullable errorMessage) {
        if (success) {
            [weakSelf reverseGeocode:toLocation createAnnotation:YES setLocation:YES];
        }
        else
        {
            [[[UIAlertView alloc] initWithTitle:@"Message" message:errorMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
    }];
    
}

- (void) reverseGeocode : (CLLocationCoordinate2D) location2D createAnnotation : (BOOL) createAnnotation setLocation : (BOOL) setLocation
{
    _location2D = CLLocationCoordinate2DMake (location2D.latitude, location2D.longitude);
    
    MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:MKCoordinateRegionMakeWithDistance(location2D, 800, 800)];
    [self.mapView setRegion:adjustedRegion animated:YES];
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:location2D.latitude longitude:location2D.longitude];
    
    if (_geocoder == nil) {
        _geocoder = [CLGeocoder new];
    }
    
    __weak ViewController *weakSelf = self;
    
    [HUDUtil showBlockingHUD:weakSelf];
    [_geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error)
     {
         [HUDUtil hideProgressHUD:weakSelf];
         if (error == nil && [placemarks count] > 0)
         {
             weakSelf.placemark = [placemarks lastObject];
             
             weakSelf.locationField.text=[NSString stringWithFormat:@" %@,%@ %@,%@,%@", self.placemark.thoroughfare,self.placemark.postalCode, self.placemark.locality,self.placemark.administrativeArea,self.placemark.country];
             
             if (createAnnotation) {
                 MapViewAnnotation *dropPin = [[MapViewAnnotation alloc] initWithTitle:[NSString stringWithFormat:@" %@,%@, %@,%@,%@", self.placemark.thoroughfare,self.placemark.postalCode, self.placemark.locality,self.placemark.administrativeArea,self.placemark.country] AndCoordinate:location2D];
                 
                 if (_previousAnnotation) {
                     [_mapView removeAnnotation:_previousAnnotation];
                     _previousAnnotation = nil;
                 }
                 _previousAnnotation = dropPin;
                 
                 [self.mapView addAnnotation:dropPin];
                 
                 CLLocationCoordinate2D startCoord = CLLocationCoordinate2DMake( location2D.latitude, location2D.longitude);
                 MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:MKCoordinateRegionMakeWithDistance(startCoord, 800, 800)];
                 [self.mapView setRegion:adjustedRegion animated:YES];
             }
         }
         else
         {
             [[[UIAlertView alloc] initWithTitle:@"Message" message:[[LocationUtil sharedUtil] getErrorMessageForCLError:[error code]] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
         }
     }];
}


- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField
{
    [self performSegueWithIdentifier:@"vctr_map_modal" sender:nil];
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
