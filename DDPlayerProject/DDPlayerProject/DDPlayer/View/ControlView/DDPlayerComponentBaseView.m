//
//  DDVideoPlayerComponentBaseView.m
//  DDVideoPlayer
//
//  Created by wuqh on 2018/11/7.
//  Copyright © 2018 wuqh. All rights reserved.
//

#import "DDPlayerComponentBaseView.h"

@implementation DDPlayerComponentBaseView

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(screenRotation:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    }
    return self;
}

- (void)screenRotation:(NSNotification *)notification {
    switch (UIDevice.currentDevice.orientation) {
        case UIDeviceOrientationPortrait:
        {
            [self updateUIWithPortrait];
        }
            break;
        case UIDeviceOrientationLandscapeLeft:
        {
            [self updateUIWithLandscape];
        }
            break;
        case UIDeviceOrientationLandscapeRight:
        {
            [self updateUIWithLandscape];
        }
            break;
            
        default:
            break;
    }
}

- (void)updateUIWithPortrait {
    
}
- (void)updateUIWithLandscape {
    
}

@end
