//
//  DDPlayerView+CaptureVideo.m
//  DDPlayerProject
//
//  Created by wuqh on 2018/11/21.
//  Copyright © 2018 wuqh. All rights reserved.
//

#import "DDPlayerView+CaptureVideo.h"
#import "DDCaptureVideoView.h"
#import "DDPlayerView+ShowSubView.h"

@implementation DDPlayerView (CaptureVideo)

- (void)captureVideoButtonClick:(UIButton *)captureVideoButton {
    
    DDCaptureVideoView *captureVideoView = [[DDCaptureVideoView alloc] init];
    [self show:captureVideoView origin:DDPlayerShowOriginCenter isDismissControl:YES isPause:NO dismissCompletion:^{
        //稍后处理
    }];
    
    
//    if (self.isPoping) {
//        return;
//    }
//    if (!self.currentPlayerItem || self.currentPlayerItem.status != AVPlayerStatusReadyToPlay) {
//        return;
//    }
//    //点击截频按钮。隐藏其他控件
//    [self hideTheLandscapeUI:NO];
//
//    //添加截取视频视图到屏幕上
//    if (self.videoCaptureView == nil) {
//        WTCVideoCaptureView *videoCaptureView = [[WTCVideoCaptureView alloc] initWithFrame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.height, UIScreen.mainScreen.bounds.size.width)];
//        self.videoCaptureView = videoCaptureView;
//        self.videoCaptureView.delegate = self;
//        [self addSubview:self.videoCaptureView];
//    }
//    //把代理传过来的 截取视频的标题 赋值给 captrueView（如果不传，默认标题为 ”截取视频片段“）
//    if ([self.eventDelegate respondsToSelector:@selector(videoPlayerClickCaptureVideoBtn:)]) {
//        [self.eventDelegate videoPlayerClickCaptureVideoBtn:^(NSString *captureTitle) {
//            self.videoCaptureView.captureTitle = captureTitle;
//        }];
//    }
//
//    [self.videoCaptureView mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self);
//    }];
//
//    // 获取视频当前播放时间点
//    double currentPlayerTime = self.currentPlayerItem.currentTime.value / self.currentPlayerItem.currentTime.timescale;
//    //开始视频截取
//    [self.videoCaptureView startCapture:currentPlayerTime isPause:self.currentPlayer.rate==0];
}

@end
