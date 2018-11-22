//
//  DDPlayerManager.h
//  DDPlayerProject
//
//  Created by wuqh on 2018/11/9.
//  Copyright © 2018 wuqh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVKit/AVKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DDPlayerManager : NSObject


/**
 视频截图

 @param asset asset
 @param currentTime CMTime
 @return UIImage
 */
+ (UIImage *)thumbnailImageWithAsset:(AVAsset*)asset currentTime:(CMTime)currentTime;

+ (AVAssetExportSession*)captureVideoWithAsset:(AVAsset*)asset startTime:(CMTime)startTime duration:(NSTimeInterval)duration progress:(void(^)(CGFloat))progress success:(void(^)(NSString *))success failure:(void(^)(void))failure;


@end

NS_ASSUME_NONNULL_END
