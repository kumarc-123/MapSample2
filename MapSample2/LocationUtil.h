//
//  LocationUtil.h
//  BuddyMe
//
//  Created by Kumar C on 12/29/15.
//  Copyright © 2015 3rd Eye. All rights reserved.
//

@import Foundation;
@import CoreLocation;
@import MapKit;

typedef void (^GetCurrentLocationhandler) (BOOL success, CLLocationCoordinate2D fromLocation, CLLocationCoordinate2D toLocation, NSString * _Nullable errorMessage);

@interface LocationUtil : NSObject

@property (nonatomic, assign) CLLocationCoordinate2D userLocation;

/// Returns current user location on completion.
- (void) getCurrentLocationWithCompletion : (nonnull GetCurrentLocationhandler) completion;

+ (nonnull LocationUtil *) sharedUtil;

/// Decodes location service errors from error code.
- (nonnull NSString *) getErrorMessageForCLError : (CLError) errorCode;

/// Decodes Map related errors from error code.
- (nonnull NSString *) getErrorMessageForMKError : (MKErrorCode) errorCode;
@end
