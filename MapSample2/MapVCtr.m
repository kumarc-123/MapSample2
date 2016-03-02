//
//  MapVCtr.m
//  MapSample2
//
//  Created by Kumar C on 3/2/16.
//  Copyright © 2016 Kumar C. All rights reserved.
//

#import "MapVCtr.h"
#import <MapKit/MapKit.h>

#import "LocationUtil.h"
#import "MapViewAnnotation.h"
#import "HUDUtil.h"

@interface MapVCtr () <UITextFieldDelegate, MKMapViewDelegate>

@property (nonatomic, weak) IBOutlet MKMapView *mapView;

@property (nonatomic, weak) IBOutlet UIButton *searchButton;

@property (nonatomic, weak) IBOutlet UITextField *searchField;

@property (nonatomic, assign) CLLocationCoordinate2D location2D;

@property (nonatomic, strong) CLGeocoder *geocoder;

@property (nonatomic, strong) CLPlacemark *placemark;

@property (nonatomic, strong) MapViewAnnotation *previousAnnotation;

@property (nonatomic, strong) MKLocalSearch *localSearch;


- (IBAction)searchTapped:(id)sender;

- (IBAction)cancelapped:(id)sender;


@end

@implementation MapVCtr

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    __weak MapVCtr *weakSelf = self;
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


- (IBAction)searchTapped:(id)sender
{
    if (_searchField.text.length > 0) {
        [self searchMap];
    }
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    return YES;
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
    
    __weak MapVCtr *weakSelf = self;
    
    [HUDUtil showBlockingHUD:weakSelf];
    [_geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error)
     {
         [HUDUtil hideProgressHUD:weakSelf];
         if (error == nil && [placemarks count] > 0)
         {
             weakSelf.placemark = [placemarks lastObject];
             
             weakSelf.searchField.text=[NSString stringWithFormat:@" %@,%@ %@,%@,%@", self.placemark.thoroughfare,self.placemark.postalCode, self.placemark.locality,self.placemark.administrativeArea,self.placemark.country];
             
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

- (void) searchMap
{
    if (_localSearch && _localSearch.isSearching) {
        [_localSearch cancel];
    }
    
    CLLocationCoordinate2D userLocation = [[LocationUtil sharedUtil] userLocation];
    
    MKCoordinateRegion newRegion;
    newRegion.center.latitude = userLocation.latitude;
    newRegion.center.longitude = userLocation.longitude;
    
    
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    request.naturalLanguageQuery = _searchField.text;
    request.region = newRegion;
    
    newRegion.span.latitudeDelta = 0.112872;
    newRegion.span.longitudeDelta = 0.109863;
    
    
    _localSearch = [[MKLocalSearch alloc] initWithRequest:request];
    
    [HUDUtil showBlockingHUD:self];
    
    [_localSearch startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
        __block MapViewAnnotation *firstAnnotation;
        [HUDUtil hideProgressHUD:self];
        [_mapView setUserInteractionEnabled:YES];
        
        if (error) {
            [[[UIAlertView alloc] initWithTitle:@"Message" message:[[LocationUtil sharedUtil] getErrorMessageForMKError:[error code]] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            return;
        }
        
        if (response.mapItems.count == 0)
        {
            NSLog(@"No Matches");
            [[[UIAlertView alloc] initWithTitle:@"Message" message:@"The search did not yield any results." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
        else
        {
            [response.mapItems enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                
                if (idx == 0) {
                    
                    MKMapItem *item = obj;
                    
                    _placemark = [item placemark];
                    
                    [self reverseGeocode:_placemark.location.coordinate createAnnotation:YES setLocation:NO];
                    
                    return;
                }
            }];
        }
        
        [self.mapView selectAnnotation:firstAnnotation animated:YES];
    }];
}


- (IBAction)cancelapped:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
