//
//  DDPlayerView.h
//  DDPlayerProject
//
//  Created by wuqh on 2018/11/9.
//  Copyright © 2018 wuqh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDPlayer.h"
#import "DDPlayerTool.h"
#import "DDPlayerViewDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface DDPlayerView : UIView

@property(nonatomic, strong) DDPlayer *player;
@property(nonatomic, weak)   id<DDPlayerViewDelegate> delegate;

/**
 设置清晰度名称
 */
@property(nonatomic, strong) NSArray *clarityNameArray;

/**
 视频标题
 */
@property(nonatomic, copy)   NSString *title;
/**
 封面图
 */
@property(nonatomic, copy) NSString *coverImage;
/**
 是否隐藏截取功能
 */
@property(nonatomic, assign) BOOL isHiddenCapture;

/**
 是否隐藏分享按钮
 */
@property(nonatomic, assign) BOOL isHiddenShare;


/**
 是否锁屏
 */
@property(nonatomic, assign, readonly) BOOL isLockScreen;


@end

NS_ASSUME_NONNULL_END
