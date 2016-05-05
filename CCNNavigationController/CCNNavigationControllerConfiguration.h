//
//  Created by Frank Gregor on 27/04/16.
//  Copyright © 2016 cocoa:naut. All rights reserved.
//

/*
 The MIT License (MIT)
 Copyright © 2016 Frank Gregor, <phranck@cocoanaut.com>
 http://cocoanaut.mit-license.org

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the “Software”), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 */

#import <AppKit/AppKit.h>
#import <QuartzCore/QuartzCore.h>

/**
 *  Constant indicating the transition behaviour of push operations.
 */
typedef NS_ENUM(NSUInteger, CCNNavigationControllerTransition) {
    /**
     *  Designates that a pushed view controller's view will be shifted from right to left.
     */
    CCNNavigationControllerTransitionToLeft = 0,
    /**
     *  Designates that a pushed view controller's view will be shifted from left to right.
     */
    CCNNavigationControllerTransitionToRight,
    /**
     *  Designates that a pushed view controller's view will be shifted from top to the bottom.
     */
    CCNNavigationControllerTransitionToDown,
    /**
     *  Designates that a pushed view controller's view will be shifted from the bottom upwards.
     */
    CCNNavigationControllerTransitionToUp
};

/**
 *  Constants indicating the transition style of push operations.
 */
typedef NS_ENUM(NSUInteger, CCNNavigationControllerTransitionStyle) {
    /**
     *  Designates that a popped view controller's view will be shifted out during a push operation while the new view is about beeing shown.
     */
    CCNNavigationControllerTransitionStyleShift = 0,
    /**
     *  Designates that the pushed view will overlap the current visible view controller's view.
     */
    CCNNavigationControllerTransitionStyleStack,
    /**
     *  Designates that the pushed view will be visibly warped out while the next view fades in on its end position.
     *
     *  Selecting this transition style will left the `transition` value without any effect.
     */
    CCNNavigationControllerTransitionStyleWarp
};

@interface CCNNavigationControllerConfiguration : NSObject

/**
 *  Creates and returns a `CCNNavigationControllerConfiguration` object with default values.
 *
 *  @return The newly created configuration container.
 */
+ (instancetype)defaultConfiguration;

/**
 *  The background color of the navigation controller.
 *
 *  This color will be injected to every pushed viewController. The default is: `[NSColor windowBackgroundColor]`.
 */
@property (nonatomic, strong) NSColor *backgroundColor;

/**
 *  Property that controls the transition of push and pop of view controllers.
 *
 *  The default value is `CCNNavigationControllerTransitionToLeft`.
 *
 *  @see CCNNavigationControllerTransition
 */
@property (nonatomic, assign) CCNNavigationControllerTransition transition;

/**
 *  Property that controls the transition style of push and pop of view controllers.
 *
 *  The default value is `CCNNavigationControllerTransitionStyleShift`.
 *
 *  @see CCNNavigationControllerTransitionStyle
 */
@property (nonatomic, assign) CCNNavigationControllerTransitionStyle transitionStyle;

/**
 *  Property that controls the duration of any transition orpartion.
 *
 *  The default value is `0.35` seconds.
 */
@property (assign, nonatomic) NSTimeInterval transitionDuration;

/**
 *  Property that controls the timing function that has to be used during transition.
 */
@property (nonatomic, copy) CAMediaTimingFunction *mediaTimingFunction;

@end
