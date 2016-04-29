//
//  Created by Frank Gregor on 29/04/16.
//  Copyright © 2016 cocoa:naut. All rights reserved.
//

#import "AppDelegate.h"
#import "TestVC.h"


@interface AppDelegate ()
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
    self.window.contentViewController = navigationController;

}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

@end
