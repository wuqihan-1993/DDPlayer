//
//  DDPlayerViewDelegate.h
//  DDPlayerProject
//
//  Created by wuqh on 2018/11/9.
//  Copyright © 2018 wuqh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDPlayerClarityTool.h"

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
 切换清晰度
 
 @param clarity DDPlayerClarity
 */
- (void)playerViewChooseClarity:(DDPlayerClarity)clarity success:(void(^)(NSString*))success failure:(void(^)(void))failure;

/**
 章节列表按钮点击

 @param button 章节列表按钮
 */
- (void)playerViewClickChapterButton:(UIButton *)button;

/**
 播放器发生错误，点击重试按钮
 */
- (void)playerViewPlayerErrorRetry;

#pragma mark - 业务
/**
 付费页面，点击去购买
 */
- (void)playerViewNeedToPay;

#pragma mark - 截取相关
/**
 点击分享截取图像

 @param captureImage 图像
 @param shareType DDShareType
 */
- (void)playerViewShareCaptureImage:(UIImage*)captureImage shareType:(DDShareType)shareType;



/**
 点击发送截取视频评论

 @param commnet 评论
 @param success 成功
 @param failure 失败
 */
- (void)playerViewCaptureVideoSendComment:(NSString *)commnet success:(void(^)(void))success failure:(void(^)(void))failure;
/*
 func videoPlayerUploadCaptureVideo(_ captureVideoPath: URL!, startTime: Int, duration: Int, progress: ((CGFloat) -> Void)!, complete: ((Bool,Error?) -> Void)!) {
 */


/**
 上传截取的视频

 @param captureVideoPath 视频本地地址
 @param startTime startTime
 @param duration 时长
 @param progress 进度
 @param success 成功
 @param failure 失败
 */
- (void)playerViewUploadCaptureVideo:(NSString *)captureVideoPath
                           startTime:(CGFloat)startTime
                            duration:(CGFloat)duration
                            progress:(void(^)(CGFloat))progress
                             success:(void(^)(void))success
                             failure:(void(^)(NSError*))failure;

@end

NS_ASSUME_NONNULL_END
