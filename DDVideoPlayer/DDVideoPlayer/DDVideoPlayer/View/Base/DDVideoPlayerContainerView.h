//
//  DDVideoPlayerContainerView.h
//  DDVideoPlayer
//
//  Created by wuqh on 2018/11/7.
//  Copyright © 2018 wuqh. All rights reserved.
//

#import "DDVideoPlayerComponentBaseView.h"
#import "DDVideoPlayerBottomPortraitView.h"
#import "DDVideoPlayerBottomLandscapeView.h"

@class DDVideoPlayerContainerView;

@protocol DDVideoPlayerContainerViewDelegate <NSObject>

/**
 点击返回按钮

 @param containerView self
 @param button 返回按钮
 */
- (void)videoPlayerContainerView:(DDVideoPlayerContainerView*)containerView clickBackTitleButton:(UIButton*)button;
/**
 点击播放按钮

 @param containerView self
 @param button 播放按钮
 */
- (void)videoPlayerContainerView:(DDVideoPlayerContainerView*)containerView clickPlayButton:(UIButton*)button;
/**
 点击锁屏按钮

 @param containerView self
 @param button 锁屏按钮
 */
- (void)videoPlayerContainerView:(DDVideoPlayerContainerView*)containerView clicklockScreenButton:(UIButton*)button;

/**
 点击截取按钮

 @param containerView self
 @param button 截取按钮
 */
- (void)videoPlayerContainerView:(DDVideoPlayerContainerView*)containerView clickCaptureButton:(UIButton*)button;

@end

NS_ASSUME_NONNULL_BEGIN

@interface DDVideoPlayerContainerView : DDVideoPlayerComponentBaseView

@property (nonatomic, weak) id<DDVideoPlayerContainerViewDelegate> delegate;

@property(nonatomic, strong) DDVideoPlayerBottomPortraitView *bottomPortraitView;
@property(nonatomic, strong) DDVideoPlayerBottomLandscapeView *bottomLandscapeView;

@end

NS_ASSUME_NONNULL_END
