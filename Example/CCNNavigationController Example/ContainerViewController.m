//
//  Created by Frank Gregor on 05/05/16.
//  Copyright © 2016 cocoa:naut. All rights reserved.
//

#import "ContainerViewController.h"
#import "ImageViewController.h"

@interface ContainerViewController () <CCNNavigationControllerDelegate>
@property (weak) IBOutlet NSButton *previousButton;
@property (weak) IBOutlet NSButton *nextButton;
@property (weak) IBOutlet NSButton *popToRootButton;
@property (weak) IBOutlet NSButton *popToCalculatedMiddleImageButton;
@property (weak) IBOutlet NSView *imageContainer;
@property (weak) IBOutlet NSPopUpButton *transitionPopup;
@property (weak) IBOutlet NSPopUpButton *transitionStylePopup;
@property (nonatomic, assign) NSInteger counter;
@end

@implementation ContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.counter = 1;
    
    
    ImageViewController *imageVC = [[ImageViewController alloc] initWithNibName:NSStringFromClass([ImageViewController class]) bundle:nil];

    self.navigationController = [[CCNNavigationController alloc] initWithRootViewController:imageVC];
    self.navigationController.view.translatesAutoresizingMaskIntoConstraints = NO;
    self.navigationController.delegate = self;
    self.navigationController.configuration.transitionDuration = 5;
    
    
    [self.imageContainer addSubview:self.navigationController.view];
    
    NSDictionary *views = @{ @"navigation": self.navigationController.view};
    [self.imageContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[navigation]|" options:0 metrics:@{} views:views]];
    [self.imageContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[navigation]|" options:0 metrics:@{} views:views]];
    
    
    [self.transitionPopup removeAllItems];
    [self.transitionPopup addItemsWithTitles:@[
        @"Right to Left",
        @"Left to Right",
        @"Top to Down",
        @"Bottom to Up"
    ]];
    
    
    [self.transitionStylePopup removeAllItems];
    [self.transitionStylePopup addItemsWithTitles:@[
        @"Shift views",
        @"Stack all views",
        @"Warp popped view"
    ]];
}

- (void)updateButtonTtile {
    NSInteger numberOfMiddleImage = ceil(self.counter/2);
    self.popToCalculatedMiddleImageButton.title = [NSString stringWithFormat:@"Pop to Image #%@", @(numberOfMiddleImage)];
}

#pragma mark - Button Actions

- (IBAction)previousButtonAction:(NSButton *)button {
    [self.navigationController popViewControllerAnimated:YES];
    [self updateButtonTtile];
}

- (IBAction)nextButtonAction:(NSButton *)button {
    self.counter++;
    
    ImageViewController *imageVC = [[ImageViewController alloc] initWithNibName:NSStringFromClass([ImageViewController class]) bundle:nil];
    imageVC.counter = self.counter;
    [self.navigationController pushViewController:imageVC animated:YES];
    
    [self updateButtonTtile];
}

- (IBAction)popTooRootButtonAction:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)popToCalculatedMiddleImageButtonAction:(id)sender {
    if (self.navigationController.viewControllers.count < 4) return;
    
    NSViewController *numberFive = [self.navigationController.viewControllers objectAtIndex:ceil(self.counter/2)-1];
    [self.navigationController popToViewController:numberFive animated:YES];
    
    [self updateButtonTtile];
}

- (IBAction)transitionPopupAction:(NSPopUpButton *)sender {
    CCNNavigationControllerTransition transition = [sender indexOfSelectedItem];
    self.navigationController.configuration.transition = transition;
}

- (IBAction)transitionStylePopupAction:(NSPopUpButton *)sender {
    CCNNavigationControllerTransitionStyle transitionStyle = [sender indexOfSelectedItem];
    self.navigationController.configuration.transitionStyle = transitionStyle;
    self.transitionPopup.enabled = (transitionStyle != CCNNavigationControllerTransitionStyleWarp);
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
