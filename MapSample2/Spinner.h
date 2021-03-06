//
//  Spinner.h
//  BuddyMe
//
//  Created by Kumar C on 1/18/16.
//  Copyright © 2016 3rd Eye. All rights reserved.
//

@import UIKit;

/// A UIView subclass for showing progress HUD. 
@interface Spinner : UIView

/** Sets the line width of the spinner's circle. */
@property (nonatomic) CGFloat lineWidth;

/** Sets whether the view is hidden when not animating. */
@property (nonatomic) BOOL hidesWhenStopped;

/** Specifies the timing function to use for the control's animation. Defaults to kCAMediaTimingFunctionEaseInEaseOut */
@property (nonatomic, strong) CAMediaTimingFunction *timingFunction;

/** Property indicating whether the view is currently animating. */
@property (nonatomic, readonly) BOOL isAnimating;

@property (nonatomic, assign) BOOL removeFromSuperViewOnHide;

/**
 *  Convenience function for starting & stopping animation with a boolean variable instead of explicit
 *  method calls.
 *
 *  @param animate true to start animating, false to stop animating.
 @note This method simply calls the startAnimating or stopAnimating methods based on the value of the animate parameter.
 */
- (void)setAnimating:(BOOL)animate;

/**
 *  Starts animation of the spinner.
 */
- (void)startAnimating;

/**
 *  Stops animation of the spinnner.
 */
- (void)stopAnimating;

- (void) hide;

+ (Spinner *) showInView:(UIView *)view isMini : (BOOL) isMIni;

+ (BOOL)hideSpinnerForView:(UIView *)view;

+ (NSUInteger)hideAllHUDsForView:(UIView *)view;

@end
