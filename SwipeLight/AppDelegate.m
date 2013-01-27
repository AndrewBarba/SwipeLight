//
//  AppDelegate.m
//  SwipeLight
//
//  Created by Andrew Barba on 10/30/12.
//  Copyright (c) 2012 Andrew Barba. All rights reserved.
//

#import "AppDelegate.h"
#import "ABTorch.h"
#import "TorchViewController.h"

@interface AppDelegate()
@property (nonatomic, strong) ABTorch *torch;
@property (nonatomic)         BOOL     wasInBackground;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.wasInBackground = YES;
    self.torch = [[ABTorch alloc] init];
    if (!self.torch.canTorch) [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"screenLight"];
//    self.torch.shouldToggleScreen = [[NSUserDefaults standardUserDefaults] boolForKey:@"screenLight"];
    TorchViewController *vc = (TorchViewController *)self.window.rootViewController;
    [vc setTorch:self.torch];
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Do nothing
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [self.torch torchOFF];
    [UIApplication sharedApplication].idleTimerDisabled = NO;
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    self.wasInBackground = YES;
//    self.torch.shouldToggleScreen = [[NSUserDefaults standardUserDefaults] boolForKey:@"screenLight"];
    [self.torch torchON];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    if (self.wasInBackground) [self.torch torchON];
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    self.wasInBackground = NO;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [self.torch torchOFF];
}

@end
