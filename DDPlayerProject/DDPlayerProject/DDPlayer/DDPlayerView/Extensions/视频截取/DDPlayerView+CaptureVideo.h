//
//  DDPlayerView+CaptureVideo.h
//  DDPlayerProject
//
//  Created by wuqh on 2018/11/21.
//  Copyright © 2018 wuqh. All rights reserved.
//

#import "DDPlayerView.h"

@class DDCaptureVideoView;
@class DDCaptureVideoShareView;

@interface DDPlayerView (CaptureVideo)

@property(nonatomic, strong) DDCaptureVideoView *captureVideoView;
@property(nonatomic, strong) DDCaptureVideoShareView *captureVideoShareView;
@property(nonatomic, assign) BOOL isCapturingVideo;


- (void)captureVideoButtonClick:(UIButton *)captureVideoButton;

@end


