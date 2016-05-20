//
//  Created by Frank Gregor on 10.01.15.
//  Copyright (c) 2015 cocoa:naut. All rights reserved.
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

#import "CCNNavigationControllerConfiguration.h"

@class CCNNavigationController;

#pragma mark CCNViewController Protocol
@protocol CCNViewController <NSObject>
@optional
/**
 *  Notifies the view controller that its view is about to be added to a view hierarchy.
 *
 *  @param animated If `YES`, the view is being added to the window using an animation.
 */
- (void)viewWillAppear:(BOOL)animated;

/**
 *  Notifies the view controller that its view was added to a view hierarchy.
 *
 *  @param animated If `YES`, the view was added to the window using an animation.
 */
- (void)viewDidAppear:(BOOL)animated;

/**
 *  Notifies the view controller that its view is about to be removed from a view hierarchy.
 *
 *  @param animated If `YES`, the disappearance of the view is being animated.
 */
- (void)viewWillDisappear:(BOOL)animated;

/**
 *  Notifies the view controller that its view was removed from a view hierarchy.
 *
 *  @param animated If `YES`, the disappearance of the view was animated.
 */
- (void)viewDidDisappear:(BOOL)animated;
@end

#pragma mark - CCNNavigationControllerDelegate
/**
 *  Every delegate call will automatically fire its related notification regardless if the delegate is set or not.
 */
@protocol CCNNavigationControllerDelegate <NSObject>
@optional
/**
 *  Called just before the navigation controller displays a view controller’s view.
 *
 *  @param navigationController The navigation controller that is showing the view.
 *  @param viewController       The view controller whose view is being shown.
 *  @param animated             `YES` to animate the transition; otherwise, `NO`.
 */
- (void)navigationController:(CCNNavigationController *)navigationController willShowViewController:(__kindof NSViewController *)viewController animated:(BOOL)animated;

/**
 *  Called just after the navigation controller displays a view controller’s view.
 *
 *  @param navigationController The navigation controller that is showing the view.
 *  @param viewController       The view controller whose view is being shown.
 *  @param animated             `YES` to animate the transition; otherwise, `NO`.
 */
- (void)navigationController:(CCNNavigationController *)navigationController didShowViewController:(__kindof NSViewController *)viewController animated:(BOOL)animated;

/**
 *  Called just before the navigation controller removes a view controller’s view.
 *
 *  @param navigationController The navigation controller that is removing the view.
 *  @param viewController       The view controller whose view has been removed.
 *  @param animated             `YES` to animate the transition; otherwise, `NO`.
 */
- (void)navigationController:(CCNNavigationController *)navigationController willPopViewController:(__kindof NSViewController *)viewController animated:(BOOL)animated;

/**
 *  Called just after the navigation controller removes a view controller’s view.
 *
 *  @param navigationController The navigation controller that has removed the view.
 *  @param viewController       The view controller whose view has been removed.
 *  @param animated             `YES` to animate the transition; otherwise, `NO`.
 */
- (void)navigationController:(CCNNavigationController *)navigationController didPopViewController:(__kindof NSViewController *)viewController animated:(BOOL)animated;
@end

@interface CCNNavigationController : NSViewController

#pragma mark - Creating Navigation Controllers

/**
 *  Initializes and returns a newly created navigation controller.
 *
 *  This is a convenience method for initializing the receiver and pushing a root view controller onto the navigation stack. Every navigation stack must have at least one view controller to act as the root.
 *
 *  @param viewController The view controller that resides at the bottom of the navigation stack.
 *
 *  @return The initialized navigation controller object or `nil` if there was a problem initializing the object.
 */
- (instancetype)initWithRootViewController:(__kindof NSViewController *)viewController NS_DESIGNATED_INITIALIZER;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)coder NS_UNAVAILABLE;
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil NS_UNAVAILABLE;

/**
 *  The delegate of the navigation controller object.
 *
 *  You can use the navigation delegate to perform additional actions in response to changes in the navigation interface.
 */
@property (weak) id<CCNNavigationControllerDelegate> delegate;

#pragma mark - Accessing Items on the Navigation Stack

/**
 *  The view controller at the top of the navigation stack. (read-only).
 *
 *  @see visibleViewController
 *  @see viewControllers
 */
@property (nonatomic, readonly, strong) __kindof NSViewController *topViewController;

/**
 *  The view controller associated with the currently visible view in the navigation interface. (read-only).
 *
 *  @see topViewController
 *  @see viewControllers
 */
@property (nonatomic, readonly, strong) __kindof NSViewController *visibleViewController;

/**
 *  The view controllers currently on the navigation stack.
 *
 *  @see topViewController
 *  @see visibleViewController
 */
@property (nonatomic, copy) NSArray<__kindof NSViewController *> *viewControllers;

#pragma mark - Pushing and Popping Stack Items

/**
 *  Replaces the view controllers currently managed by the navigation controller with the specified items.
 *
 *  The object in the viewController parameter becomes the top view controller on the navigation stack. Pushing a view controller causes its view to be embedded in the navigation interface. If the animated parameter is YES, the view is animated into position; otherwise, the view is simply displayed in its final location.
 *
 *  @param viewControllers The view controllers to place in the stack. The front-to-back order of the controllers in this array represents the new bottom-to-top order of the controllers in the navigation stack. Thus, the last item added to the array becomes the top item of the navigation stack.
 *  @param animated        If `YES`, animate the pushing or popping of the top view controller. If `NO`, replace the view controllers without any animations.
 */
- (void)setViewControllers:(NSArray<__kindof NSViewController *> *)viewControllers animated:(BOOL)animated;

/**
 *  Pushes a view controller onto the receiver’s stack and updates the display.
 *
 *  @param viewController The view controller to push onto the stack. This object cannot be a tab bar controller. If the view controller is already on the navigation stack, this method throws an exception.
 *  @param animated       Specify `YES` to animate the transition or `NO` if you do not want the transition to be animated. You might specify NO if you are setting up the navigation controller at launch time.
 */
- (void)pushViewController:(__kindof NSViewController *)viewController animated:(BOOL)animated;

/**
 *  Pops the top view controller from the navigation stack and updates the display.
 *
 *  This method removes the top view controller from the stack and makes the new top of the stack the active view controller. If the view controller at the top of the stack is the root view controller, this method does nothing. In other words, you cannot pop the last item on the stack.
 *
 *  @param animated Set this value to `YES` to animate the transition. Pass `NO` if you are setting up a navigation controller before its view is displayed.
 *
 *  @return The view controller that was popped from the stack.
 */
- (__kindof NSViewController *)popViewControllerAnimated:(BOOL)animated;

/**
 *  Pops all the view controllers on the stack except the root view controller and updates the display.
 *
 *  The root view controller becomes the top view controller.
 *
 *  @param animated Set this value to `YES` to animate the transition. Pass `NO` if you are setting up a navigation controller before its view is displayed.
 *
 *  @return An array of view controllers representing the items that were popped from the stack.
 */
- (NSArray<__kindof NSViewController *> *)popToRootViewControllerAnimated:(BOOL)animated;

/**
 *  Pops view controllers until the specified view controller is at the top of the navigation stack.
 *
 *  @param viewController The view controller that you want to be at the top of the stack. This view controller must currently be on the navigation stack.
 *  @param animated       Set this value to YES to animate the transition. Pass NO if you are setting up a navigation controller before its view is displayed.
 *
 *  @return An array containing the view controllers that were popped from the stack.
 */
- (NSArray<__kindof NSViewController *> *)popToViewController:(__kindof NSViewController *)viewController animated:(BOOL)animated;

/**
 *  A configuration container to control the appearance and behaviour of the navigation controller.
 */
@property (nonatomic, strong) CCNNavigationControllerConfiguration *configuration;

@end

#pragma mark - NSView+CCNAppKit
@interface NSView (CCNNavigationController)
- (BOOL)hasSubView:(NSView *)theSubView;
- (void)bringSubViewToFront:(NSView *)theSubView;
@end

#pragma mark - NSViewController+CCNNavigationController
@interface NSViewController (CCNNavigationController)
@property (nonatomic, strong) CCNNavigationController *navigationController;
@end

// Each notification contains the navigation controller as notification object.
// Each notification has a `userInfo` dictionary containing one object (the handled viewController) which is accessible via `CCNNavigationControllerNotificationUserInfoKey`.
FOUNDATION_EXPORT NSString *const CCNNavigationControllerWillShowViewControllerNotification;
FOUNDATION_EXPORT NSString *const CCNNavigationControllerDidShowViewControllerNotification;
FOUNDATION_EXPORT NSString *const CCNNavigationControllerWillPopViewControllerNotification;
FOUNDATION_EXPORT NSString *const CCNNavigationControllerDidPopViewControllerNotification;
FOUNDATION_EXPORT NSString *const CCNNavigationControllerNotificationUserInfoKey;
