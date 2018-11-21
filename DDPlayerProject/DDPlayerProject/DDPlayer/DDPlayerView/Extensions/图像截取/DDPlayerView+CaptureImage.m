//
//  DDPlayerView+CaptureImage.m
//  DDPlayerProject
//
//  Created by wuqh on 2018/11/21.
//  Copyright © 2018 wuqh. All rights reserved.
//

#import "DDPlayerView+CaptureImage.h"
#import "DDPlayerManager.h"
#import "DDPlayerView+Private.h"
#import "DDCaptureImageShareView.h"
#import "DDCaptureImageShareSmallView.h"
#import "DDPlayerControlView.h"
#import <objc/runtime.h>
#import "DDPlayerView+ShowSubView.h"

static void *_captureImageShareSmallViewKey = &_captureImageShareSmallViewKey;
static void *_isShareingCaptureImageKey = &_isShareingCaptureImageKey;

@implementation DDPlayerView (CaptureImage)

- (DDCaptureImageShareSmallView *)captureImageShareSmallView {
    return objc_getAssociatedObject(self, _captureImageShareSmallViewKey);
}
- (void)setCaptureImageShareSmallView:(DDCaptureImageShareSmallView *)captureImageShareSmallView {
    objc_setAssociatedObject(self, _captureImageShareSmallViewKey, captureImageShareSmallView, OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)isShareingCaptureImage {
    return [objc_getAssociatedObject(self, _isShareingCaptureImageKey) boolValue];
}
- (void)setIsShareingCaptureImage:(BOOL)isShareingCaptureImage {
    objc_setAssociatedObject(self, _isShareingCaptureImageKey, [NSNumber numberWithBool:isShareingCaptureImage], OBJC_ASSOCIATION_RETAIN);
}

- (void)captureImageButtonClick:(UIButton *)captureImageButton {
    //截图 一闪 的效果
    UIView *whiteView = [[UIView alloc] initWithFrame:self.bounds];
    whiteView.backgroundColor = UIColor.whiteColor;
    [self addSubview:whiteView];
    [UIView animateWithDuration:0.5 animations:^{
        whiteView.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
    } completion:^(BOOL finished) {
        [whiteView removeFromSuperview];
        //开始截取
        UIImage *currentImage = [DDPlayerManager thumbnailImageWithAsset:self.player.currentAsset currentTime:self.player.currentItem.currentTime];
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = currentImage;
        [self addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).mas_offset(40);
            make.right.equalTo(self).mas_offset(-100);
            make.height.mas_equalTo((DDPlayerTool.screenHeight - 140)*9/16);
            make.centerY.equalTo(self);
        }];
        [self layoutIfNeeded];
        [imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(captureImageButton);
            make.width.height.mas_equalTo(0);
        }];
        [UIView animateWithDuration:0.5 animations:^{
            [self layoutIfNeeded];
        } completion:^(BOOL finished) {
            [self._getPlayerControlView show];
            if (self.captureImageShareSmallView != nil) {
                [self.captureImageShareSmallView removeFromSuperview];
                self.captureImageShareSmallView = nil;
            }
            
            self.captureImageShareSmallView = [[DDCaptureImageShareSmallView alloc] initWithImage:currentImage];
            
            BOOL lastStausIsPause = self.player.isPause;
            
            __weak typeof(self) weakSelf = self;
            self.captureImageShareSmallView.toShareBlock = ^(UIImage * _Nonnull image) {

                if (image) {
                    
                    weakSelf.isShareingCaptureImage = YES;
                    
                    DDCaptureImageShareView *imageShareView = [[DDCaptureImageShareView alloc] initWithImage:image];
                    imageShareView.shareButtonClickBlock = ^(DDShareType shareType) {
                        if ([weakSelf.delegate respondsToSelector:@selector(playerViewShareCaptureImage:shareType:)]) {
                            [weakSelf.delegate playerViewShareCaptureImage:image shareType:shareType];
                        }
                    };
                    [weakSelf show:imageShareView origin:DDPlayerShowOriginCenter isDismissControl:YES isPause:YES dismissCompletion:^{
                        weakSelf.isShareingCaptureImage = NO;
                        if (lastStausIsPause == YES) {
                            [weakSelf.player pause];
                        }else {
                            [weakSelf.player play];
                        }
                    }];
            
                }
            };
            [self addSubview:self.captureImageShareSmallView];
            [self.captureImageShareSmallView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(captureImageButton.mas_left).mas_offset(-20);
                make.centerY.equalTo(captureImageButton);
            }];
            [self layoutIfNeeded];
        }];
    }];
}

- (void)dismissCaptureImageShareSmallView {
    if (self.captureImageShareSmallView != nil) {
        
        [self.captureImageShareSmallView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self._getPlayerControlView.captureImageButton.mas_left).mas_offset(250);
        }];
        
        [UIView animateWithDuration:0.4 animations:^{
            
            [self layoutIfNeeded];
            
        } completion:^(BOOL finished) {
            [self.captureImageShareSmallView removeFromSuperview];
            self.captureImageShareSmallView = nil;
        }];
    }

}
@end
