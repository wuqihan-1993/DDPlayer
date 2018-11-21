//
//  DDPlayerViewDelegate.h
//  DDPlayerProject
//
//  Created by wuqh on 2018/11/9.
//  Copyright © 2018 wuqh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDPlayerClarity.h"

NS_ASSUME_NONNULL_BEGIN

@protocol DDPlayerViewDelegate <NSObject>
@optional

/**
 返回按钮点击

 @param button 返回按钮
 */
- (void)playerViewClickBackButton:(UIButton *)button;


/**
 点击封面上的播放按钮

 @param button 播放按钮
 */
- (void)playerViewClickCoverPlayButton:(UIButton *)button;

/**
 下一节按钮点击

 @param button 下一节按钮
 */
- (void)playerViewClickForwardButton:(UIButton *)button;

/**
 截取视频按钮点击

 @param button 截取视频按钮
 */
- (void)playerViewClickCaptureVideoButton:(UIButton *)button;

/**
 截取图像按钮点击

 @param button 截取图像按钮
 */
- (void)playerViewClickCaptureImageButton:(UIButton *)button;

/**
 锁屏按钮点击

 @param button 锁屏按钮
 */
- (void)playerViewClickLockScreenButton:(UIButton *)button;

/**
 清晰度按钮点击

 @param button 清晰度按钮
 */
- (void)playerViewClickClarityButton:(UIButton *)button;


/**
 章节列表按钮点击

 @param button 章节列表按钮
 */
- (void)playerViewClickChapterButton:(UIButton *)button;


/**
 切换清晰度

 @param clarity DDPlayerClarity
 */
- (void)playerViewChooseClarity:(DDPlayerClarity)clarity success:(void(^)(NSString*))success failure:(void(^)(void))failure;


/**
 播放器发生错误，点击重试按钮
 */
- (void)playerViewPlayerErrorRetry;


/**
 点击分享截取图像

 @param captureImage 图像
 @param shareType DDShareType
 */
- (void)playerViewShareCaptureImage:(UIImage*)captureImage shareType:(DDShareType)shareType;



@end

NS_ASSUME_NONNULL_END
