//
//  DDPlayerView+CaptureVideo.m
//  DDPlayerProject
//
//  Created by wuqh on 2018/11/21.
//  Copyright © 2018 wuqh. All rights reserved.
//

#import "DDPlayerView+CaptureVideo.h"
#import "DDCaptureVideoView.h"
#import "DDCaptureVideoShareView.h"
#import "DDPlayerView+ShowSubView.h"
#import <objc/runtime.h>

static void *_isCapturingVideoKey = &_isCapturingVideoKey;
static void *_captureViewViewKey = &_captureViewViewKey;
static void *_captureViewShareViewKey = &_captureViewShareViewKey;

@implementation DDPlayerView (CaptureVideo)

- (DDCaptureVideoView *)captureVideoView {
    return objc_getAssociatedObject(self, _captureViewViewKey);
}
- (void)setCaptureVideoView:(DDCaptureVideoView *)captureVideoView {
    objc_setAssociatedObject(self, _captureViewViewKey, captureVideoView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (DDCaptureVideoShareView *)captureVideoShareView {
    return objc_getAssociatedObject(self, _captureViewShareViewKey);
}
- (void)setCaptureVideoShareView:(DDCaptureVideoShareView *)captureVideoShareView {
    objc_setAssociatedObject(self, _captureViewShareViewKey, captureVideoShareView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (BOOL)isCapturingVideo {
    return [objc_getAssociatedObject(self, _isCapturingVideoKey) boolValue];
}
- (void)setIsCapturingVideo:(BOOL)isCapturingVideo {
    objc_setAssociatedObject(self, _isCapturingVideoKey, [NSNumber numberWithBool:isCapturingVideo], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)captureVideoButtonClick:(UIButton *)captureVideoButton {
    
    __weak typeof(self) weakSelf = self;
    
    //记录截取前的播放器状态
    BOOL lastPlayerIsPlaying = self.player.isPlaying;
    CGFloat lastTime = self.player.currentTime;
    CMTime lastCMTime = self.player.currentItem.currentTime;
    
    self.captureVideoView = [[DDCaptureVideoView alloc] init];
    
    self.captureVideoView.finishBlock = ^{
        [weakSelf toCaptureAndUploadVideoWithStartTime:lastCMTime duration:weakSelf.captureVideoView.currentTime];
        [weakSelf.captureVideoView removeFromSuperview];
        weakSelf.captureVideoView = nil;
        
    };
    
    self.captureVideoView.captureMaxDuration = self.captureMaxDuration > 0 ? self.captureMaxDuration : 15;
    self.isCapturingVideo = YES;
    
    [self.player playImmediatelyAtRate:1.0];
     
    [self show:self.captureVideoView origin:DDPlayerShowOriginCenter isDismissControl:YES isPause:NO dismissCompletion:^{
        //截取视频取消
        weakSelf.isCapturingVideo = NO;
        [self.player seekToTime:lastTime isPlayImmediately:lastPlayerIsPlaying completionHandler:nil];
        [self.captureVideoView removeFromSuperview];
        self.captureVideoView = nil;
    }];
    
}
- (void)toCaptureAndUploadVideoWithStartTime:(CMTime)startTime duration:(CGFloat)duration{
    self.captureVideoShareView = [[DDCaptureVideoShareView alloc] init];
    __weak typeof(self) weakSelf = self;
    self.captureVideoShareView.confirmCommentBlock = ^(NSString * _Nonnull comment, void (^ _Nonnull success)(void), void (^ _Nonnull failure)(void)) {
        if ([weakSelf.delegate respondsToSelector:@selector(playerViewCaptureVideoSendComment:success:failure:)]) {
            [weakSelf.delegate playerViewCaptureVideoSendComment:comment success:^{
                success();
            } failure:^{
                failure();
            }];
        }
    };

    [self show:self.captureVideoShareView origin:DDPlayerShowOriginCenter isDismissControl:NO isPause:YES dismissCompletion:^{
        self.isCapturingVideo = NO;
        [weakSelf.captureVideoShareView removeFromSuperview];
        weakSelf.captureVideoShareView = nil;
    }];
    [self.captureVideoShareView captureVideoWithAsset:self.player.currentAsset startTime:startTime duration:duration];
}

@end
