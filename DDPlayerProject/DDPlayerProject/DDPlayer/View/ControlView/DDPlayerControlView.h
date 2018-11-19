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
#import "DDPlayerControlTopView.h"

@class DDPlayerControlView;

@protocol DDPlayerControlViewDelegate <NSObject>

@optional
/**
 点击返回按钮

 @param controlView self
 @param button 返回按钮
 */
- (void)playerControlView:(DDPlayerControlView*)controlView clickBackTitleButton:(UIButton*)button;
/**
 点击播放按钮

 @param controlView self
 @param button 播放按钮
 */
- (void)playerControlView:(DDPlayerControlView*)controlView clickPlayButton:(UIButton*)button;
/**
 点击锁屏按钮

 @param controlView self
 @param button 锁屏按钮
 */
- (void)playerControlView:(DDPlayerControlView*)controlView clicklockScreenButton:(UIButton*)button;

/**
 点击截取视频按钮

 @param controlView self
 @param button 截取按钮
 */
- (void)playerControlView:(DDPlayerControlView*)controlView clickCaptureVideoButton:(UIButton*)button;


/**
 点击截取图像按钮

 @param controlView self
 @param button 截取按钮
 */
- (void)playerControlView:(DDPlayerControlView*)controlView clickCaptureImageButton:(UIButton*)button;


/**
 点击下一首按钮

 @param controlView self
 @param button 下一首按钮
 */
- (void)playerControlView:(DDPlayerControlView*)controlView clickForwardButton:(UIButton*)button;


/**
 点击清晰度按钮

 @param controlView self
 @param button 清晰度按钮
 */
- (void)playerControlView:(DDPlayerControlView*)controlView clickClarityButton:(UIButton*)button;

/**
 点击章节列表按钮

 @param controlView self
 @param button 章节列表按钮
 */
- (void)playerControlView:(DDPlayerControlView*)controlView clickChapterButton:(UIButton*)button;

/**
 点击速率按钮

 @param controlView self
 @param button 速率按钮
 */
- (void)playerControlView:(DDPlayerControlView*)controlView clickRateButton:(UIButton*)button;

/**
 手势改变音量

 @param controlView self
 @param volume CGFloat
 */
- (void)playerControlView:(DDPlayerControlView*)controlView chagedVolume:(CGFloat)volume;

- (void)playerControlView:(DDPlayerControlView *)controlView beginDragSlider:(UISlider *)slider;
- (void)playerControlView:(DDPlayerControlView *)controlView DragingSlider:(UISlider *)slider;
- (void)playerControlView:(DDPlayerControlView *)controlView endDragSlider:(UISlider *)slider;
- (void)playerControlView:(DDPlayerControlView *)controlView tapSlider:(UISlider *)slider;

- (void)playerControViewWillShow:(DDPlayerControlView *)controlView;
- (void)playerControViewWillDismiss:(DDPlayerControlView *)controlView;

@end

NS_ASSUME_NONNULL_BEGIN

@interface DDPlayerControlView : DDPlayerComponentBaseView

@property (nonatomic, weak) id<DDPlayerControlViewDelegate> delegate;
@property(nonatomic, strong) DDPlayerControlBottomPortraitView *bottomPortraitView;
@property(nonatomic, strong) DDPlayerControlBottomLandscapeView *bottomLandscapeView;
@property(nonatomic, strong) DDPlayerControlTopView *topView;
@property(nonatomic, strong) UIButton *captureImageButton;
@property(nonatomic, strong) UIButton *captureVideoButton;
/**
 是否锁屏
 */
@property(nonatomic, assign, readonly) BOOL isLockScreen;

/**
 是否正在拖拽进度
 */
@property(nonatomic, assign, readonly) BOOL isDragingSlider;


/**
 显示控制视图
 */
- (void)show;

/**
 隐藏控制视图
 */
- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
