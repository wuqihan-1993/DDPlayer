//
//  DDVideoLineModel.h
//  DDVideoPlayer
//
//  Created by wuqh on 2018/11/7.
//  Copyright © 2018 wuqh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DDVideoLineModel : NSObject

@property (nonatomic,copy) NSString *lineName;//清晰度名称
@property (nonatomic,copy) NSString *lineID;//清晰度ID
@property (nonatomic,copy) NSString *lineUrl;//清晰度url
@property (nonatomic,copy) NSNumber *videoSize;//视频的大小
@property (nonatomic,copy) NSString *videoTitle;//视频标题
@property (nonatomic,copy) NSNumber *videoDuration;//视频时长
@property (nonatomic,assign) BOOL lineDefault;//默认清晰度

@end

NS_ASSUME_NONNULL_END
