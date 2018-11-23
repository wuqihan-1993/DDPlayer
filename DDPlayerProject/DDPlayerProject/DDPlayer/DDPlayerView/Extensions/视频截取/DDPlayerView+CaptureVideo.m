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
static void *_captureVideoViewKey = &_captureVideoViewKey;
static void *_captureVideoShareViewKey = &_captureVideoShareViewKey;

@implementation DDPlayerView (CaptureVideo)

- (DDCaptureVideoView *)captureVideoView {
    return objc_getAssociatedObject(self, _captureVideoViewKey);
}
- (void)setCaptureVideoView:(DDCaptureVideoView *)captureVideoView {
    objc_setAssociatedObject(self, _captureVideoViewKey, captureVideoView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (DDCaptureVideoShareView *)captureVideoShareView {
    if (objc_getAssociatedObject(self, _captureVideoShareViewKey)) {
        return objc_getAssociatedObject(self, _captureVideoShareViewKey);
    }else {
        __weak typeof(self) weakSelf = self;
        DDCaptureVideoShareView *captureVideoShareView = [[DDCaptureVideoShareView alloc] init];
        self.captureVideoShareView = captureVideoShareView;
        self.captureVideoShareView.confirmCommentBlock = ^(NSString * _Nonnull comment, void (^ _Nonnull success)(void), void (^ _Nonnull failure)(void)) {
            if ([weakSelf.delegate respondsToSelector:@selector(playerViewCaptureVideoSendComment:success:failure:)]) {
                [weakSelf.delegate playerViewCaptureVideoSendComment:comment success:^{
                    success();
                } failure:^{
                    failure();
                }];
            }
        };
        return captureVideoShareView;
    }
}
- (void)setCaptureVideoShareView:(DDCaptureVideoShareView *)captureVideoShareView {
    objc_setAssociatedObject(self, _captureVideoShareViewKey, captureVideoShareView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (BOOL)isCapturingVideo {
    return [objc_getAssociatedObject(self, _isCapturingVideoKey) boolValue];
}
- (void)setIsCapturingVideo:(BOOL)isCapturingVideo {
    objc_setAssociatedObject(self, _isCapturingVideoKey, [NSNumber numberWithBool:isCapturingVideo], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)showCaptureVideoShareView {
    __weak typeof(self) weakSelf = self;
    self.player.isNeedCanPlay = NO;
    [self show:self.captureVideoShareView origin:DDPlayerShowOriginCenter isDismissControl:NO isPause:YES dismissCompletion:^{
        weakSelf.player.isNeedCanPlay = YES;
        weakSelf.isCapturingVideo = NO;
        [weakSelf.captureVideoShareView removeFromSuperview];
        weakSelf.captureVideoShareView = nil;
        [weakSelf.player play];
    }];
}
- (void)dismissCaptureVideoShareView {
    if (objc_getAssociatedObject(self, _captureVideoShareViewKey)) {
        self.captureVideoShareView.dismissBlock();
        [self.captureVideoShareView removeFromSuperview];
        self.captureVideoShareView = nil;
        [self.player play];
    }
}

- (void)captureVideoButtonClick:(UIButton *)captureVideoButton {
    
    __weak typeof(self) weakSelf = self;
    
    //记录截取前的播放器状态
    BOOL lastPlayerIsPlaying = self.player.isPlaying;
    CGFloat lastTime = self.player.currentTime;
    CMTime lastCMTime = self.player.currentItem.currentTime;
    
    self.captureVideoView = [[DDCaptureVideoView alloc] init];
    
    self.captureVideoView.finishBlock = ^{
        
        [weakSelf toCaptureVideoWithStartTime:lastCMTime duration:weakSelf.captureVideoView.currentTime];
        [weakSelf.captureVideoView removeFromSuperview];
        weakSelf.captureVideoView = nil;
        
    };
    
    self.captureVideoView.captureMaxDuration = self.captureMaxDuration > 0 ? self.captureMaxDuration : 15;
    self.isCapturingVideo = YES;
    
    [self.player playImmediatelyAtRate:1.0];
    
    [self show:self.captureVideoView origin:DDPlayerShowOriginCenter isDismissControl:YES isPause:NO dismissCompletion:^{
        //截取视频取消
        weakSelf.isCapturingVideo = NO;
        [weakSelf.player seekToTime:lastTime isPlayImmediately:lastPlayerIsPlaying completionHandler:nil];
        [weakSelf.captureVideoView removeFromSuperview];
        weakSelf.captureVideoView = nil;
    }];
    
}
- (void)toCaptureVideoWithStartTime:(CMTime)startTime duration:(CGFloat)duration{
    
    __weak typeof(self) weakSelf = self;
    
    [self showCaptureVideoShareView];
    [self.captureVideoShareView captureVideoWithAsset:self.player.currentAsset startTime:startTime duration:duration success:^(NSString * _Nonnull captureVideoPath) {
        
        //截取成功
        
        if ([weakSelf.delegate respondsToSelector:@selector(playerViewUploadCaptureVideo:startTime:duration:progress:success:failure:)]) {
            
            [weakSelf.delegate playerViewUploadCaptureVideo:captureVideoPath startTime:CMTimeGetSeconds(startTime) duration:duration progress:^(CGFloat progress) {
                
                [weakSelf.captureVideoShareView uploadCaptureVideoProgress:progress];
                
            } success:^{
                
                [weakSelf.captureVideoShareView uploadCaptureVideoSuccess:[NSURL fileURLWithPath:captureVideoPath]];
                
            } failure:^(NSError * _Nonnull error) {
                
            }];
            
        }else {
            [weakSelf.captureVideoShareView uploadCaptureVideoSuccess:[NSURL fileURLWithPath:captureVideoPath]];
        }
        
    } failure:^(NSError * _Nonnull error) {
        //截取失败
        
    }];
}

@end
