//
//  MapViewAnnotation.h
//  BuddyMe
//
//  Created by A001MLBLR on 23/07/15.
//  Copyright (c) 2015 3rd Eye. All rights reserved.
//

@import Foundation;
#import <MapKit/MapKit.h>

/**
 *  Custom annotation for Busslr map view.
 */
@interface MapViewAnnotation : NSObject <MKAnnotation>

@property (nonatomic, copy) NSString *title;

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

-(id)initWithTitle:(NSString *) title AndCoordinate:(CLLocationCoordinate2D)coordinate;

@end
