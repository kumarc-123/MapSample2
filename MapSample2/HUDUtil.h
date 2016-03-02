//
//  UIUtil.h
//  BuddyMe
//
//  Created by Kumar C on 1/27/16.
//  Copyright © 2016 3rd Eye. All rights reserved.
//

@import Foundation;

@import UIKit;

/// Utility for showing progress HUD on a view. Used throughout the application for showing activity indication.
@interface HUDUtil : NSObject

+ (HUDUtil *) sharedUtil;

/// Blocks the user interations for the view controller and shows HUD.
+ (void) showBlockingHUD : (UIViewController *) viewController;

/// Shows non-blocking small HUD.
+ (void) showMiniHUDInView : (UIView *) view;

/// Shows blocking HUD
+ (void) showBlockingHUDInView : (UIView *) view;

/// Shows non-blocking HUD
+ (void) showProgressHUD : (UIViewController *) viewController;

/// Removes the HUD from the view controller and enables user interation.
+ (void) hideProgressHUD : (UIViewController *) viewController;

/// Shows non-blocking HUD.
+ (void) showProgressHUDInView : (UIView *) view;

/// Hides the HUD.
+ (void) hideProgressHUDInView : (UIView *) view;

@end
