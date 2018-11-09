//
//  DDVideoPlayerContainerView.h
//  DDVideoPlayer
//
//  Created by wuqh on 2018/11/7.
//  Copyright © 2018 wuqh. All rights reserved.
//

#import "DDPlayerComponentBaseView.h"
#import "DDPlayerControlBottomPortraitView.h"
#import "DDPlayerControlBottomLandscapeView.h"

@class DDPlayerControlView;

@protocol DDPlayerControlViewDelegate <NSObject>

@optional
/**
 点击返回按钮

 @param containerView self
 @param button 返回按钮
 */
- (void)videoPlayerContainerView:(DDPlayerControlView*)containerView clickBackTitleButton:(UIButton*)button;
/**
 点击播放按钮

 @param containerView self
 @param button 播放按钮
 */
- (void)videoPlayerContainerView:(DDPlayerControlView*)containerView clickPlayButton:(UIButton*)button;
/**
 点击锁屏按钮

 @param containerView self
 @param button 锁屏按钮
 */
- (void)videoPlayerContainerView:(DDPlayerControlView*)containerView clicklockScreenButton:(UIButton*)button;

/**
 点击截取按钮

 @param containerView self
 @param button 截取按钮
 */
- (void)videoPlayerContainerView:(DDPlayerControlView*)containerView clickCaptureButton:(UIButton*)button;

@end

NS_ASSUME_NONNULL_BEGIN

@interface DDPlayerControlView : DDPlayerComponentBaseView

@property (nonatomic, weak) id<DDPlayerControlViewDelegate> delegate;
@property(nonatomic, strong) UIButton *playButton;
@property(nonatomic, strong) DDPlayerControlBottomPortraitView *bottomPortraitView;
@property(nonatomic, strong) DDPlayerControlBottomLandscapeView *bottomLandscapeView;

@end

NS_ASSUME_NONNULL_END
