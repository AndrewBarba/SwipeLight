//
//  ABTorch.h
//  SwipeLight
//
//  Created by Andrew Barba on 10/30/12.
//  Copyright (c) 2012 Andrew Barba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface ABTorch : NSObject
-(void)torchON;
-(void)torchOFF;
-(void)strobeFaster;
-(void)strobeSlower;
-(void)beginChangingBrightness;
-(void)endChangingBrightness;
-(void)changeBrightness:(CGFloat)level;

@property (nonatomic, strong) UIView *torchView;
@property (nonatomic, strong) AVCaptureDevice *device;
@property (nonatomic) CGFloat strobesPerSecond;
@property (nonatomic) CGFloat lastLevel;
@property (nonatomic) CGFloat changeLevel;
@property (nonatomic) BOOL    isStrobing;
@property (nonatomic) BOOL    isChangingBrightness;
@property (nonatomic) BOOL    canChangeBrightness;
@property (nonatomic) BOOL    canTorch;
@property (nonatomic) BOOL    isTorchOn;
@property (nonatomic) BOOL    shouldToggleScreen;
@end
