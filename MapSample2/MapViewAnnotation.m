//
//  MapViewAnnotation.m
//  BuddyMe
//
//  Created by A001MLBLR on 23/07/15.
//  Copyright (c) 2015 3rd Eye. All rights reserved.
//

#import "MapViewAnnotation.h"

@implementation MapViewAnnotation

@synthesize coordinate=_coordinate;

@synthesize title=_title;

-(id) initWithTitle:(NSString *) title AndCoordinate:(CLLocationCoordinate2D)coordinate{
    
    self = [super init];
    
    _title = title;
    
    _coordinate = coordinate;
    
    return self;
    
}
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    static NSString * const identifier = @"identifier";
    MKPinAnnotationView *pinView = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    if (pinView ==nil) {
        pinView = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:identifier];
        pinView.animatesDrop = YES;
        pinView.draggable = YES;
    }
    return pinView;
}

@end
