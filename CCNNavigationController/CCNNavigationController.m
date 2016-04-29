//
//  Created by Frank Gregor on 10.01.15.
//  Copyright (c) 2015 cocoa:naut. All rights reserved.
//
//  Initial idea has been adapted from BFNavigationController, but with some improvements.
//  @see: https://github.com/bfolder/BFNavigationController/blob/master/BFNavigationController/BFNavigationController.m

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


#import <objc/runtime.h>
#import <QuartzCore/QuartzCore.h>

#import "CCNNavigationController.h"


NSString *const CCNNavigationControllerWillShowViewControllerNotification = @"CCNNavigationControllerWillShowViewControllerNotification";
NSString *const CCNNavigationControllerDidShowViewControllerNotification  = @"CCNNavigationControllerDidShowViewControllerNotification";
NSString *const CCNNavigationControllerWillPopViewControllerNotification  = @"CCNNavigationControllerWillPopViewControllerNotification";
NSString *const CCNNavigationControllerDidPopViewControllerNotification   = @"CCNNavigationControllerDidPopViewControllerNotification";

NSString *const CCNNavigationControllerNotificationUserInfoKey = @"viewController";


@interface CCNNavigationController () {
    NSMutableArray *_viewControllers;
}
@end

@implementation CCNNavigationController

#pragma mark - Creating Navigation Controllers

- (instancetype)initWithRootViewController:(__kindof NSViewController *)viewController {
    self = [super initWithNibName:nil bundle:nil];
    if (!self) return nil;

    _delegate = nil;
    _viewControllers = [NSMutableArray array];
    
    NSRect viewControllerFrame = viewController.view.bounds;
    
    if (!viewController) {
        viewController = [[NSViewController alloc] init];
        viewController.view = [[NSView alloc] initWithFrame:viewControllerFrame];
    }
    
    [_viewControllers addObject:viewController];
    
    self.view = [[NSView alloc] initWithFrame:viewControllerFrame];
    self.view.translatesAutoresizingMaskIntoConstraints = YES;
    self.view.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
    self.view.wantsLayer = YES;
    
    // setup configuration
    self.configuration = [CCNNavigationControllerConfiguration defaultConfiguration];
    self.backgroundColor = self.configuration.backgroundColor;
    
    
    // inject navigation controller
    if ([viewController respondsToSelector:@selector(setNavigationController:)]) {
        [viewController performSelector:@selector(setNavigationController:) withObject:self];
    }
    
    [self.view addSubview:viewController.view];
    viewController.view.translatesAutoresizingMaskIntoConstraints = YES;
    viewController.view.autoresizingMask = self.view.autoresizingMask;
    viewController.view.wantsLayer = YES;
    viewController.view.frame = viewControllerFrame;
    
    
    // Initial controller will appear on startup
    if([viewController respondsToSelector:@selector(viewWillAppear:)]) {
        [(id<CCNViewController>)viewController viewWillAppear:NO];
    }

    return self;
}

#pragma mark - Pushing and Popping Stack Items

- (void)setViewControllers:(NSArray<__kindof NSViewController *> *)viewControllers {
    [self setViewControllers:viewControllers animated:NO];
}

- (void)setViewControllers:(NSArray<__kindof NSViewController *> *)viewControllers animated:(BOOL)animated {
    NSViewController *currentVisibleController = self.visibleViewController;
    NSViewController *newVisibleController = [viewControllers lastObject];
    
    BOOL push = !([_viewControllers containsObject:newVisibleController] && [_viewControllers indexOfObject:newVisibleController] < [_viewControllers count] - 1);
    _viewControllers = [viewControllers mutableCopy];
    
    for (NSViewController* viewController in _viewControllers) {
        if ([viewController respondsToSelector:@selector(setNavigationController:)]) {
            [viewController performSelector:@selector(setNavigationController:) withObject:self];
        }
    }
    
    [self _transitionFromViewController:currentVisibleController toViewController:newVisibleController animated:animated push:push];
}

- (void)pushViewController:(__weak __kindof NSViewController *)viewController animated:(BOOL)animated {
    NSViewController *visibleViewController = self.visibleViewController;
    [_viewControllers addObject:viewController];
    
    [self _transitionFromViewController:visibleViewController toViewController:viewController animated:animated push:YES];
}

- (__kindof NSViewController *)popViewControllerAnimated:(BOOL)animated {
    if ([_viewControllers count] == 1) return nil;

    NSViewController *visibleViewController = self.visibleViewController;
    [_viewControllers removeLastObject];
    
    [self _transitionFromViewController:visibleViewController toViewController:_viewControllers.lastObject animated:animated push:NO];
    
    return visibleViewController;
}

- (NSArray<__kindof NSViewController *> *)popToRootViewControllerAnimated:(BOOL)animated {
    NSViewController *rootController = _viewControllers.firstObject;
    [_viewControllers removeObject:rootController];
    
    NSArray<NSViewController *> *poppedViewControllers = [NSArray arrayWithArray:_viewControllers];
    _viewControllers = [NSMutableArray arrayWithObject:rootController];
    
    for (NSViewController *aViewController in _viewControllers) {
        if ([aViewController respondsToSelector:@selector(setNavigationController:)]) {
            [aViewController performSelector:@selector(setNavigationController:) withObject:nil];
        }
    }
    
    [self _transitionFromViewController:poppedViewControllers.lastObject toViewController:rootController animated:animated push:NO];
    
    return poppedViewControllers;
}

- (NSArray<__kindof NSViewController *> *)popToViewController:(__kindof NSViewController *)viewController animated:(BOOL)animated {
    NSViewController *fromViewController = self.visibleViewController;
    
    if (![_viewControllers containsObject: viewController] || fromViewController == viewController) {
        return [NSArray array];
    }
    
    NSUInteger index  = [_viewControllers indexOfObject:viewController] + 1;
    NSUInteger length = [_viewControllers count] - index;
    NSRange range     = NSMakeRange(index, length);
    NSArray *poppedViewControllers = [_viewControllers subarrayWithRange:range];
    [_viewControllers removeObjectsInArray:poppedViewControllers];
    
    for (NSViewController * aViewController in poppedViewControllers) {
        if([aViewController respondsToSelector:@selector(setNavigationController:)]) {
            [aViewController performSelector:@selector(setNavigationController:) withObject:nil];
        }
    }
    
    [self _transitionFromViewController:fromViewController toViewController:viewController animated:animated push:NO];
    
    return poppedViewControllers;
}

#pragma mark - View Controller Transition

- (void)_transitionFromViewController:(__kindof NSViewController *)currentViewController
                     toViewController:(__kindof NSViewController *)nextViewController
                             animated:(BOOL)animated
                                 push:(BOOL)push {
    
    // inject navigation controller
    if ([nextViewController respondsToSelector:@selector(setNavigationController:)]) {
        [nextViewController performSelector:@selector(setNavigationController:) withObject:self];
    }

    // call the delegate and push a notification
    [self navigationController:self willShowViewController:nextViewController animated:animated];
    
    if ([nextViewController respondsToSelector:@selector(viewWillAppear:)]) {
        [(id<CCNViewController>)nextViewController viewWillAppear:animated];
    }
    
    if ([currentViewController respondsToSelector:@selector(viewWillDisappear:)]) {
        [(id<CCNViewController>)currentViewController viewWillDisappear:animated];
    }
    

    void(^completeAnimation)(BOOL, BOOL) = ^(BOOL animated, BOOL push) {
        [currentViewController.view removeFromSuperview];
        
        if ([nextViewController respondsToSelector:@selector(viewDidAppear:)]) {
            [(id<CCNViewController>)nextViewController viewDidAppear:animated];
        }
        
        if ([currentViewController respondsToSelector:@selector(viewDidDisappear:)]) {
            [(id<CCNViewController>)currentViewController viewDidDisappear:animated];
        }
        
        // remove possible injected navigation controller
        if ([currentViewController respondsToSelector:@selector(setNavigationController:)]) {
            [currentViewController performSelector:@selector(setNavigationController:) withObject:nil];
        }
    };
    
    
    NSRect nextViewControllerStartFrame = self.view.bounds;
    NSRect currentViewControllerEndFrame = self.view.bounds;
    

    [self.view addSubview:nextViewController.view];
    nextViewController.view.translatesAutoresizingMaskIntoConstraints = YES;
    nextViewController.view.autoresizingMask = self.view.autoresizingMask;
    nextViewController.view.wantsLayer = YES;
    nextViewController.view.layer.backgroundColor = self.configuration.backgroundColor.CGColor;
    

    // put animation here...
    if (animated) {
        switch (self.configuration.transition) {
            case CCNNavigationControllerTransitionShiftLeft: {
                nextViewControllerStartFrame.origin.x  = (push ? NSWidth(nextViewControllerStartFrame) : -NSWidth(nextViewControllerStartFrame));
                currentViewControllerEndFrame.origin.x = (push ? -NSWidth(currentViewControllerEndFrame) : NSWidth(currentViewControllerEndFrame));
                break;
            }
            case CCNNavigationControllerTransitionShiftRight: {
                nextViewControllerStartFrame.origin.x  = (push ? -NSWidth(nextViewControllerStartFrame) : NSWidth(nextViewControllerStartFrame));
                currentViewControllerEndFrame.origin.x = (push ? NSWidth(currentViewControllerEndFrame) : -NSWidth(currentViewControllerEndFrame));
                break;
            }
            case CCNNavigationControllerTransitionShiftDown: {
                nextViewControllerStartFrame.origin.y  = (push ? NSHeight(nextViewControllerStartFrame) : -NSHeight(nextViewControllerStartFrame));
                currentViewControllerEndFrame.origin.y = (push ? -NSHeight(currentViewControllerEndFrame) : NSHeight(currentViewControllerEndFrame));
                break;
            }
            case CCNNavigationControllerTransitionShiftUp: {
                nextViewControllerStartFrame.origin.y  = (push ? -NSHeight(nextViewControllerStartFrame) : NSHeight(nextViewControllerStartFrame));
                currentViewControllerEndFrame.origin.y = (push ? NSHeight(currentViewControllerEndFrame) : -NSHeight(currentViewControllerEndFrame));
                break;
            }
        }
        
        nextViewController.view.frame = nextViewControllerStartFrame;
        
        [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
            context.duration = self.configuration.transitionDuration;
            context.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];

            [[nextViewController.view animator] setFrame:self.view.bounds];
            [[currentViewController.view animator] setFrame:currentViewControllerEndFrame];

        } completionHandler:^{
            completeAnimation(animated, push);
        }];
    }
    
    else {
        nextViewController.view.frame = nextViewControllerStartFrame;
        [currentViewController.view removeFromSuperview];
        completeAnimation(animated, push);
    }
}

#pragma mark - Custom Accessors

- (void)setBackgroundColor:(NSColor *)backgroundColor {
    self.view.layer.backgroundColor = backgroundColor.CGColor;
}

- (__kindof NSViewController *)topViewController {
    return self.viewControllers.lastObject;
}

- (__kindof NSViewController *)visibleViewController {
    return self.viewControllers.lastObject;
}

- (NSArray<__kindof NSViewController *> *)viewControllers {
    return [NSArray arrayWithArray:_viewControllers];
}

#pragma mark - CCNNavigationControllerDelegate

- (void)navigationController:(CCNNavigationController *)navigationController willShowViewController:(__kindof NSViewController *)viewController animated:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] postNotificationName:CCNNavigationControllerWillShowViewControllerNotification
                                                        object:self
                                                      userInfo:@{ CCNNavigationControllerNotificationUserInfoKey: viewController }];
    if ([self.delegate respondsToSelector:_cmd]) {
        [self.delegate navigationController:navigationController willShowViewController:viewController animated:animated];
    }
}

- (void)navigationController:(CCNNavigationController *)navigationController didShowViewController:(__kindof NSViewController *)viewController animated:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] postNotificationName:CCNNavigationControllerDidShowViewControllerNotification
                                                        object:self
                                                      userInfo:@{ CCNNavigationControllerNotificationUserInfoKey: viewController }];
    if ([self.delegate respondsToSelector:_cmd]) {
        [self.delegate navigationController:navigationController didShowViewController:viewController animated:animated];
    }
}

- (void)navigationController:(CCNNavigationController *)navigationController willPopViewController:(__kindof NSViewController *)viewController animated:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] postNotificationName:CCNNavigationControllerWillPopViewControllerNotification
                                                        object:self
                                                      userInfo:@{ CCNNavigationControllerNotificationUserInfoKey: viewController }];
    if ([self.delegate respondsToSelector:_cmd]) {
        [self.delegate navigationController:navigationController willPopViewController:viewController animated:animated];
    }
}

- (void)navigationController:(CCNNavigationController *)navigationController didPopViewController:(__kindof NSViewController *)viewController animated:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] postNotificationName:CCNNavigationControllerDidPopViewControllerNotification
                                                        object:self
                                                      userInfo:@{ CCNNavigationControllerNotificationUserInfoKey: viewController }];
    if ([self.delegate respondsToSelector:_cmd]) {
        [self.delegate navigationController:navigationController didPopViewController:viewController animated:animated];
    }
}

@end


#pragma mark - NSViewController+CCNNavigationController
@implementation NSViewController (CCNNavigationController)
- (CCNNavigationController *)navigationController {
    return objc_getAssociatedObject(self, @selector(navigationController));
}

- (void)setNavigationController:(CCNNavigationController *)navigationController {
    objc_setAssociatedObject(self, @selector(navigationController), navigationController, OBJC_ASSOCIATION_ASSIGN);
}
@end
