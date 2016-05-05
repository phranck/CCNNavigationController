//
//  Created by Frank Gregor on 29/04/16.
//  Copyright © 2016 cocoa:naut. All rights reserved.
//

#import "AppDelegate.h"
#import "ContainerViewController.h"


@interface AppDelegate ()
@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    
    self.window.movableByWindowBackground  = YES;
    self.window.titlebarAppearsTransparent = YES;
    self.window.titleVisibility = NSWindowTitleHidden;
    self.window.styleMask |= NSFullSizeContentViewWindowMask;
    
    
    
    ContainerViewController *rootVC = [[ContainerViewController alloc] initWithNibName:NSStringFromClass([ContainerViewController class]) bundle:nil];
    self.window.contentViewController = rootVC;
    
    
    
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


@end
