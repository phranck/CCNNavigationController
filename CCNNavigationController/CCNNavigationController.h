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
- (void)viewWillAppear:(BOOL)animated;
- (void)viewDidAppear:(BOOL)animated;
- (void)viewWillDisappear:(BOOL)animated;
- (void)viewDidDisappear:(BOOL)animated;
@end




#pragma mark - CCNNavigationControllerDelegate
@protocol CCNNavigationControllerDelegate <NSObject>
@optional
// Every delegate method will automatically fire its related notification regardless if the delegate is set or not.
- (void)navigationController:(CCNNavigationController *)navigationController willShowViewController:(__kindof NSViewController *)viewController animated:(BOOL)animated;
- (void)navigationController:(CCNNavigationController *)navigationController didShowViewController:(__kindof NSViewController *)viewController animated:(BOOL)animated;
- (void)navigationController:(CCNNavigationController *)navigationController willPopViewController:(__kindof NSViewController *)viewController animated:(BOOL)animated;
- (void)navigationController:(CCNNavigationController *)navigationController didPopViewController:(__kindof NSViewController *)viewController animated:(BOOL)animated;
@end




@interface CCNNavigationController : NSViewController

#pragma mark - Creating Navigation Controllers
- (instancetype)initWithRootViewController:(__kindof NSViewController *)viewController NS_DESIGNATED_INITIALIZER;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)coder NS_UNAVAILABLE;
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil NS_UNAVAILABLE;

@property (weak) id<CCNNavigationControllerDelegate> delegate;

@property (nonatomic, strong) CCNNavigationControllerConfiguration *configuration;

#pragma mark - Accessing Items on the Navigation Stack
@property (nonatomic, readonly, strong) __kindof NSViewController *topViewController;
@property (nonatomic, readonly, strong) __kindof NSViewController *visibleViewController;
@property (nonatomic, copy) NSArray<__kindof NSViewController *> *viewControllers;


#pragma mark - Pushing and Popping Stack Items
- (void)setViewControllers:(NSArray<__kindof NSViewController *> *)viewControllers animated:(BOOL)animated;
- (void)pushViewController:(__kindof NSViewController *)viewController animated:(BOOL)animated;
- (__kindof NSViewController *)popViewControllerAnimated:(BOOL)animated;
- (NSArray<__kindof NSViewController *> *)popToRootViewControllerAnimated:(BOOL)animated;
- (NSArray<__kindof NSViewController *> *)popToViewController:(__kindof NSViewController *)viewController animated:(BOOL)animated;

@end



#pragma mark - NSViewController+CCNNavigationController
@interface NSViewController (CCNNavigationController)
@property (nonatomic, weak) CCNNavigationController *navigationController;
@end


// Each notification contains the navigation controller as notification object.
// Each notification has a `userInfo` dictionary containing one object (the handled viewController) which is accessible via `CCNNavigationControllerNotificationUserInfoKey`.
FOUNDATION_EXPORT NSString *const CCNNavigationControllerWillShowViewControllerNotification;
FOUNDATION_EXPORT NSString *const CCNNavigationControllerDidShowViewControllerNotification;
FOUNDATION_EXPORT NSString *const CCNNavigationControllerWillPopViewControllerNotification;
FOUNDATION_EXPORT NSString *const CCNNavigationControllerDidPopViewControllerNotification;
FOUNDATION_EXPORT NSString *const CCNNavigationControllerNotificationUserInfoKey;
