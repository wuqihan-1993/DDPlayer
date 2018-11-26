//
//  DDCaptureVideoShareView.h
//  DDPlayerProject
//
//  Created by wuqh on 2018/11/22.
//  Copyright © 2018 wuqh. All rights reserved.
//

#import "DDPlayerContentView.h"
#import <CoreMedia/CMTime.h>
#import "DDPlayerStatus.h"
@class AVAsset;

NS_ASSUME_NONNULL_BEGIN

@interface DDCaptureVideoShareView : DDPlayerContentView


/**
 参数：评论String，成功block，失败block
 */
@property(nonatomic, copy) void(^confirmCommentBlock)( NSString* , void(^)(void) ,void(^)(void) );
@property(nonatomic, copy) void(^shareBlock)(DDShareType);

@property(nonatomic, copy) NSString *title;


/**
 截取视频
 */
- (void)captureVideoWithAsset:(AVAsset*)asset
                    startTime:(CMTime)startTime
                     duration:(CGFloat)duration
                      success:(void(^)(NSString*))success
                      failure:(void(^)(NSError*))failure;

- (void)uploadCaptureVideoProgress:(CGFloat)progress;
- (void)uploadCaptureVideoSuccess:(NSURL *)videoUrl;

@end

NS_ASSUME_NONNULL_END
