//
//  DDPlayerViewDelegate.h
//  DDPlayerProject
//
//  Created by wuqh on 2018/11/9.
//  Copyright © 2018 wuqh. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol DDPlayerViewDelegate <NSObject>
@optional

/**
 返回按钮点击

 @param button 返回按钮
 */
- (void)playerViewClickBackTitleButton:(UIButton *)button;


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



@end

NS_ASSUME_NONNULL_END
