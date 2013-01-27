//
//  ABTorch.m
//  SwipeLight
//
//  Created by Andrew Barba on 10/30/12.
//  Copyright (c) 2012 Andrew Barba. All rights reserved.
//

#import "ABTorch.h"

#define MAX_STROBE 41
#define MIN_STROBE 1

#define STROBE_INI 11
#define STROBE_DIF 5

@interface ABTorch() {
    dispatch_queue_t strobeQueue;
}
@end

@implementation ABTorch

/*** PUBLIC METHODS ***/

-(void)torchON
{
    [self stopStrobing];
    if ([self isON]) self.lastLevel = 1;
    [self torch:YES];
}

-(void)torchOFF
{
    [self stopStrobing];
    [self torch:NO];
}

-(void)strobeFaster
{
    if (self.isStrobing) {
        if (self.strobesPerSecond < MAX_STROBE) self.strobesPerSecond+=STROBE_DIF;
    } else {
        [self startStrobing];
    }
}

-(void)strobeSlower
{
    if (self.isStrobing) {
        if (self.strobesPerSecond > MIN_STROBE) self.strobesPerSecond-=STROBE_DIF;
    } else {
        [self startStrobing];
    }
}

-(void)beginChangingBrightness
{
    self.isChangingBrightness = YES;
    self.changeLevel = self.canTorch ? self.device.torchLevel : self.torchView.layer.opacity;
}

-(void)endChangingBrightness
{
    self.changeLevel = self.device.torchLevel;
    self.isChangingBrightness = NO;
}

-(void)changeBrightness:(CGFloat)level
{
    [self changeLevel:level];
}

/**************************/

-(ABTorch *)init
{
    self = [super init];
    if (self) {
        _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        _canTorch = [_device isTorchModeSupported:AVCaptureTorchModeOn];
        _canChangeBrightness = [_device respondsToSelector:@selector(setTorchModeOnWithLevel:error:)];
        _strobesPerSecond = STROBE_INI;
        _isStrobing = NO;
        _isChangingBrightness = NO;
        _lastLevel = 1;
        _changeLevel = _lastLevel;
        strobeQueue = dispatch_queue_create("strobeQueue", NULL);
    }
    return self;
}

-(BOOL)isON
{
    if (!self.canTorch) return !self.torchView.hidden;
    return self.device.torchMode == AVCaptureTorchModeOn;
}

-(void)torch:(BOOL)on
{
    if (!self.canTorch) {
        [self torchScreen:on];
        return;
    }
    
    self.shouldToggleScreen = [[NSUserDefaults standardUserDefaults] boolForKey:@"screenLight"];
    if (self.shouldToggleScreen) {
        [self torchScreen:on];
    }
    
    dispatch_async(strobeQueue, ^{
        if ([self.device lockForConfiguration:nil]) {
            if (!on) {
                [self.device setTorchMode:AVCaptureTorchModeOff];
            } else {
                if (self.canChangeBrightness) {
                    [self.device setTorchModeOnWithLevel:self.lastLevel error:nil];
                } else {
                    [self.device setTorchMode:AVCaptureTorchModeOn];
                }
            }
            [self.device unlockForConfiguration];
        }
    });
}

-(void)torchScreen:(BOOL)on
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.torchView.hidden = !on;
        self.torchView.layer.opacity = self.lastLevel;
    });
}

-(void)toggleLight
{
    [self torch:![self isON]];
}

-(void)changeLevel:(CGFloat)level
{
    self.lastLevel = self.changeLevel + level;
    if (self.lastLevel > 1) self.lastLevel = 1;
    if (self.lastLevel <= 0) self.lastLevel = 0.01;
    if ([self isON] && !self.isStrobing) {
        [self torch:YES];
    }
}

-(void)startStrobing
{
    self.isStrobing = YES;
    [self torch:YES];
    [self strobe];
}

-(void)strobe
{
    if (!self.isStrobing) return;
    CGFloat delayInSeconds = 1 / self.strobesPerSecond;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, strobeQueue, ^(void){
        if (self.isStrobing) {
            [self toggleLight];
            [self strobe];
        }
    });
}

-(void)stopStrobing
{
    self.isStrobing = NO;
}

@end
