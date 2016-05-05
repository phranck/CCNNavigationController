//
//  Created by Frank Gregor on 27/04/16.
//  Copyright © 2016 cocoa:naut. All rights reserved.
//

#import "ImageViewController.h"

@interface ImageViewController ()
@property (strong) IBOutlet NSImageView *imageView;
@end

static NSImage *_image;

@implementation ImageViewController

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
    
    _image = [[NSImage alloc] initWithContentsOfURL:[NSURL URLWithString:@"http://lorempixel.com/640/480/"]];
    self.imageView.image = _image;
}

- (void)dealloc {
    NSLog(@"dealloc: %@", self);
}

- (NSString *)description {
    NSMutableString *desc = [NSMutableString new];
    [desc appendFormat:@"ImageViewController #%@", @(self.counter)];
    return desc;
}

@end
