//
//  TestVC.m
//  PodLive
//
//  Created by Frank Gregor on 27/04/16.
//  Copyright © 2016 cocoa:naut. All rights reserved.
//

#import "TestVC.h"

@interface TestVC () {
    BOOL _hasLoadableNib;
}

@property (weak) IBOutlet NSButton *previousButton;
@property (weak) IBOutlet NSButton *nextButton;
@property (weak) IBOutlet NSButton *popToRootButton;
@property (weak) IBOutlet NSButton *popToFiveButton;
@property (strong) IBOutlet NSImageView *imageView;

@end

static NSImage *_image;

@implementation TestVC

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _counter = 1;
        _image = nil;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        _counter = 1;
        _image = nil;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.translatesAutoresizingMaskIntoConstraints = NO;
    self.view.wantsLayer = YES;
    
    _image = [[NSImage alloc] initWithContentsOfURL:[NSURL URLWithString:@"https://ssl.webpack.de/lorempixel.com/640/480/"]];
    self.imageView.image = _image;
}

- (IBAction)previousButtonAction:(NSButton *)button {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)nextButtonAction:(NSButton *)button {
    TestVC *vc = [[TestVC alloc] initWithNibName:@"TestVC" bundle:nil];
    vc.counter = self.counter + 1;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)popTooRootButtonAction:(id)sender {
    NSArray *poppedVCs = [self.navigationController popToRootViewControllerAnimated:YES];
    NSLog(@"poppedVCs: %@", poppedVCs);
}

- (IBAction)popToFiveButtonAction:(id)sender {
    if (self.navigationController.viewControllers.count < 4) return;
    
    NSViewController *numberFive = [self.navigationController.viewControllers objectAtIndex:4];
    NSArray *poppedVCs = [self.navigationController popToViewController:numberFive animated:YES];
    NSLog(@"poppedVCs: %@", poppedVCs);
}

- (NSString *)description {
    NSMutableString *desc = [NSMutableString new];
    [desc appendFormat:@"TestVC #%@", @(self.counter)];
    return desc;
}

@end
