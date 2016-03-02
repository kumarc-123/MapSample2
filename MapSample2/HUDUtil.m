//
//  UIUtil.m
//  BuddyMe
//
//  Created by Kumar C on 1/27/16.
//  Copyright © 2016 3rd Eye. All rights reserved.
//

#import "HUDUtil.h"
#import "Spinner.h"

@interface HUDUtil ()

@property (nonatomic, strong) NSMutableArray <Spinner *> *hudList;

@end

@implementation HUDUtil

+ (HUDUtil *) sharedUtil
{
    static HUDUtil *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype) init
{
    self = [super init];
    if (self) {
        _hudList = [NSMutableArray new];
    }
    return self;
}

- (NSMutableArray*)  CreateNonRetainingMutableArray {
    return (NSMutableArray *)CFBridgingRelease(CFArrayCreateMutable(nil, 0, nil));
}

- (void) showHUDInView : (UIView *) view
{
    [self hideInView:view];
    Spinner *spinner = [Spinner showInView:view isMini:NO];
    [_hudList addObject:spinner];
}

- (void) showMiniHUDInView : (UIView *) view
{
    [self hideInView:view];
    Spinner *spinner = [Spinner showInView:view isMini:YES];
    [_hudList addObject:spinner];
}


- (void) hideInView : (UIView *) view
{
    Spinner *spinner = nil;
    for (Spinner *spinnerObj in _hudList) {
        UIView *superview = nil;
        @try {
            superview = [spinnerObj superview];
        }
        @catch (NSException *exception) {
            continue;
        }
        if (superview && superview == view) {
            spinnerObj.superview.userInteractionEnabled = YES;
//            spinner.removeFromSuperViewOnHide = YES;
//            spinner.hidesWhenStopped = YES;
            [spinnerObj stopAnimating];
            spinner = spinnerObj;
            break;
        }
    }
    if (spinner) {
        [_hudList removeObject:spinner];
    }
}

+ (void) showBlockingHUD:(UIViewController *)viewController
{
    [[self sharedUtil] showHUDInView:viewController.view];
    viewController.view.userInteractionEnabled = NO;
}

+ (void) showBlockingHUDInView:(UIView *)view
{
    [[self sharedUtil] showHUDInView:view];
    view.userInteractionEnabled = NO;
}

+ (void) showProgressHUD:(UIViewController *)viewController
{
    [[self sharedUtil] showHUDInView:viewController.view];
}

+ (void) showProgressHUDInView:(UIView *)view
{
    [[self sharedUtil] showHUDInView:view];
}

+ (void) hideProgressHUD:(UIViewController *)viewController
{
    [[self sharedUtil] hideInView:viewController.view];
}

+ (void) hideProgressHUDInView:(UIView *)view
{
    [[self sharedUtil] hideInView:view];
}

+ (void) showMiniHUDInView:(UIView *)view
{
    [[self sharedUtil] showMiniHUDInView:view];
}

@end
