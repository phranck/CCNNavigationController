//
//  Created by Frank Gregor on 29/04/16.
//  Copyright © 2016 cocoa:naut. All rights reserved.
//

#import "AppDelegate.h"
#import "TestVC.h"
#import "CCNNavigationController.h"


@interface AppDelegate () <CCNNavigationControllerDelegate>
@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {

    self.window.movableByWindowBackground  = YES;
    self.window.titlebarAppearsTransparent = YES;
    self.window.titleVisibility = NSWindowTitleHidden;
    self.window.styleMask |= NSFullSizeContentViewWindowMask;
    
    TestVC *rootVC = [[TestVC alloc] initWithNibName:@"TestVC" bundle:nil];
    CCNNavigationController *navigationController = [[CCNNavigationController alloc] initWithRootViewController:rootVC];
    navigationController.delegate = self;
    navigationController.configuration.transitionStyle = CCNNavigationControllerTransitionStyleStack;
    navigationController.configuration.transition = CCNNavigationControllerTransitionToLeft;
//    navigationController.configuration.transitionDuration = 2.5;
    self.window.contentViewController = navigationController;
    
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserverForName:CCNNavigationControllerWillShowViewControllerNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        NSViewController *viewController = note.userInfo[CCNNavigationControllerNotificationUserInfoKey];
        NSLog(@"[NOTIFICATION] CCNNavigationControllerWillShowViewControllerNotification: %@", viewController);
    }];
    [nc addObserverForName:CCNNavigationControllerDidShowViewControllerNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        NSViewController *viewController = note.userInfo[CCNNavigationControllerNotificationUserInfoKey];
        NSLog(@"[NOTIFICATION] CCNNavigationControllerDidShowViewControllerNotification: %@", viewController);
    }];
    [nc addObserverForName:CCNNavigationControllerWillPopViewControllerNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        NSViewController *viewController = note.userInfo[CCNNavigationControllerNotificationUserInfoKey];
        NSLog(@"[NOTIFICATION] CCNNavigationControllerWillPopViewControllerNotification: %@", viewController);
    }];
    [nc addObserverForName:CCNNavigationControllerDidPopViewControllerNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        NSViewController *viewController = note.userInfo[CCNNavigationControllerNotificationUserInfoKey];
        NSLog(@"[NOTIFICATION] CCNNavigationControllerDidPopViewControllerNotification: %@", viewController);
    }];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

#pragma mrk - CCNNavigationControllerDelegate

- (void)navigationController:(CCNNavigationController *)navigationController willShowViewController:(__kindof NSViewController *)viewController animated:(BOOL)animated {
    NSLog(@"[DELEGATE] navigationController: willShowViewController: %@", viewController);
}

- (void)navigationController:(CCNNavigationController *)navigationController didShowViewController:(__kindof NSViewController *)viewController animated:(BOOL)animated {
    NSLog(@"[DELEGATE] navigationController: didShowViewController: %@", viewController);
}

- (void)navigationController:(CCNNavigationController *)navigationController willPopViewController:(__kindof NSViewController *)viewController animated:(BOOL)animated {
    NSLog(@"[DELEGATE] navigationController: willPopViewController: %@", viewController);
}

- (void)navigationController:(CCNNavigationController *)navigationController didPopViewController:(__kindof NSViewController *)viewController animated:(BOOL)animated {
    NSLog(@"[DELEGATE] navigationController: didPopViewController: %@", viewController);
}


@end
