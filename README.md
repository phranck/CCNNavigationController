## An Mac OS X Navigation Controller

A Navigation Controller for Mac OS X that acts mostly like the counterpart on iOS - `UINavigationController`, using the excact method naming (with some additions).

The original idea for this controller came from [Heiko Dreyer's BFNavigationController](https://github.com/bfolder/BFNavigationController). First I forked his repo, but decided to make my own due to too many changes and additions that has been made. So, it might be possible that parts of this code looks slightly similar to his one. (-;


## Installation

You can do it manually by copying all `.h` and `.m` files into your project, or you add the following line to your Podfile:

```CocoaPods
pod 'CCNNavigationController'
```


## How to use it

There is nothing special in using `CCNNavigationController`. If you are familar with iOS' `UINavigationController` you should get it right from the start. Unlike Heiko's `BFNavigationController` there is no need to give an initial frame. Just set your `rootViewController` and you're done. The rest will be handled automatically. You can also set some configuration options via the `CCNNavigationControllerConfiguration` object.

There are two ways to give the navigation controller its rootViewController:

**First**: Set the rootViewController directly during initialization of `CCNNavigationController`.

```Objective-C
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    
   MyRootVC *rootVC = [[MyRootVC alloc] init];
   CCNNavigationController *navigationController = [[CCNNavigationController alloc] initWithRootViewController:rootVC];
    
   // you can set some configuration options
   navigationController.configuration.transition = CCNNavigationControllerTransitionShiftDown;
   
   // make the navigation controller the window's content view controller
   self.window.contentViewController = navigationController;

   ...
}
```

**Second**: Initialize `CCNNavigationController` with a `nil` rootViewController, and set it later on by directly setting the property `viewControllers` first object.

```Objective-C
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    
   CCNNavigationController *navigationController = [[CCNNavigationController alloc] initWithRootViewController:nil];
   
   // make the navigation controller the window's content view controller
   self.window.contentViewController = navigationController;


   //  do some other stuff...
   
   // initialize your rootViewController and set it as navigationController's first object
   MyRootVC *rootVC = [[MyRootVC alloc] init];
   navigationController.viewControllers = @[ rootVC ];
}
```



![CCNNavigationController-Example](img/CCNNavigationController-Example.png)


## Contribution

The code is provided as-is, and it is far off being complete or free of bugs. If you like this component feel free to support it. Make changes related to your needs, extend it or just use it in your own project. Pull-Requests and Feedbacks are very welcome. Just contact me at [phranck@cocoanaut.com](mailto:phranck@cocoanaut.com?Subject=[Xcode-Coordinator-Template] Your component on Github) or send me a ping on Twitter [@TheCocoaNaut](http://twitter.com/TheCocoaNaut). 


## License
This software is published under the [MIT License](http://cocoanaut.mit-license.org).
