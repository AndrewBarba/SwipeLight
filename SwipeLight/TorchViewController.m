//
//  TorchViewController.m
//  Torch
//
//  Created by Andrew Barba on 12/12/12.
//  Copyright (c) 2012 Andrew Barba. All rights reserved.
//

#import "TorchViewController.h"
#import <QuartzCore/QuartzCore.h>

#define FIRST_RUN_KEY  @"first_run_2"
#define ANIMATION_TIME 0.3
#define ANIMATION_MOVE 20

@interface TorchViewController ()
@property (weak, nonatomic) IBOutlet UIView *arrowContainer;
@property (weak, nonatomic) IBOutlet UIImageView *left;
@property (weak, nonatomic) IBOutlet UIImageView *right;
@property (weak, nonatomic) IBOutlet UIImageView *up;
@property (weak, nonatomic) IBOutlet UIImageView *down;
@property (weak, nonatomic) IBOutlet UIImageView *whiteLightView;
@end

@implementation TorchViewController

/********************************** TORCH METHODS **********************************/
/***********************************************************************************/

-(IBAction)torchON:(id)sender
{
    [self.torch torchON];
}

-(IBAction)torchOFF:(id)sender
{
    [self.torch torchOFF];
}

-(IBAction)strobeFaster:(id)sender
{
    [self.torch strobeFaster];
}

-(IBAction)strobeSlower:(id)sender
{
    [self.torch strobeSlower];
}

-(IBAction)changeLevel:(UIPanGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateBegan) {
        [self.torch beginChangingBrightness];
    }
    
    if (sender.state == UIGestureRecognizerStateChanged) {
        UIView *transView = self.view;
        CGPoint point = [sender translationInView:transView];
        CGFloat percentTranslated = point.y / (transView.frame.size.height*0.85);
        [self.torch changeBrightness:percentTranslated*-1];
    }
    
    if (sender.state == UIGestureRecognizerStateEnded) {
        [self.torch endChangingBrightness];
    }
}

/***********************************************************************************/
/********************************* VIEW METHODS ************************************/

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.torch.torchView = self.whiteLightView;
    self.left.layer.opacity = 0;
    self.right.layer.opacity = 0;
    self.up.layer.opacity = 0;
    self.down.layer.opacity = 0;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.torch) {
        [self openingAnimation];
        [self firstRun];
    } else {
        [self showNoFlashAlert];
    }
}

-(void)showNoFlashAlert
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Welcome to Swipe Light"
                                                    message:@"It appears that you are using a device that does not have a camera flash! Currently Swipe Light only operates on devices with a flash to provide light."
                                                   delegate:nil
                                          cancelButtonTitle:@"Okay"
                                          otherButtonTitles:nil];
    [alert show];
}

-(void)firstRun
{
    if (![[NSUserDefaults standardUserDefaults] objectForKey:FIRST_RUN_KEY]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:FIRST_RUN_KEY];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Welcome to Swipe Light"
                                                        message:@"Swipe UP and DOWN to turn the light on and off.\n\nSwipe RIGHT and LEFT to strobe faster and slower.\n\nNEW in iOS6! Two finger pan UP and DOWN to change the brightness of the light!"
                                                       delegate:nil
                                              cancelButtonTitle:@"Okay"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

-(void)openingAnimation
{
    [UIView animateWithDuration:ANIMATION_TIME
                          delay:0.1
                        options:0
                     animations:^{
                         [self initialAnimation];
                     }
                     completion:^(BOOL done){
                         [UIView animateWithDuration:ANIMATION_TIME
                                          animations:^{
                                              [self finishAimation];
                                          }];
                     }];
}

-(void)initialAnimation
{
    for (UIImageView *iv in self.arrowContainer.subviews) {
        if (iv == self.left) {
            iv.layer.opacity = 0.5;
            CGRect frame = iv.frame;
            frame.origin.x -= ANIMATION_MOVE;
            iv.frame = frame;
        }
        
        if (iv == self.right) {
            iv.layer.opacity = 0.5;
            CGRect frame = iv.frame;
            frame.origin.x += ANIMATION_MOVE;
            iv.frame = frame;
        }
        
        if (iv == self.up) {
            iv.layer.opacity = 0.5;
            CGRect frame = iv.frame;
            frame.origin.y -= ANIMATION_MOVE;
            iv.frame = frame;
        }
        
        if (iv == self.down) {
            iv.layer.opacity = 0.5;
            CGRect frame = iv.frame;
            frame.origin.y += ANIMATION_MOVE;
            iv.frame = frame;
        }
    }
}

-(void)finishAimation
{
    for (UIImageView *iv in self.arrowContainer.subviews) {
        if (iv == self.left) {
            iv.layer.opacity = 1;
            CGRect frame = iv.frame;
            frame.origin.x += ANIMATION_MOVE;
            iv.frame = frame;
        }
        
        if (iv == self.right) {
            iv.layer.opacity = 1;
            CGRect frame = iv.frame;
            frame.origin.x -= ANIMATION_MOVE;
            iv.frame = frame;
        }
        
        if (iv == self.up) {
            iv.layer.opacity = 1;
            CGRect frame = iv.frame;
            frame.origin.y += ANIMATION_MOVE;
            iv.frame = frame;
        }
        
        if (iv == self.down) {
            iv.layer.opacity = 1;
            CGRect frame = iv.frame;
            frame.origin.y -= ANIMATION_MOVE;
            iv.frame = frame;
        }
    }
}

- (void)viewDidUnload {
    [self setWhiteLightView:nil];
    [super viewDidUnload];
}
@end
