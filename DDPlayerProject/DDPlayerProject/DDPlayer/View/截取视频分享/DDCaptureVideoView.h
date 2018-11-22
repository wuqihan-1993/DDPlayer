//
//  DDCaptureVideoView.h
//  DDPlayerProject
//
//  Created by wuqh on 2018/11/21.
//  Copyright © 2018 wuqh. All rights reserved.
//

#import "DDPlayerContentView.h"

NS_ASSUME_NONNULL_BEGIN


@interface DDCaptureVideoView : DDPlayerContentView

@property(nonatomic, copy) void(^finishBlock)(void);

@property(nonatomic, assign) NSInteger captureMaxDuration;

- (void)timeChanged:(NSTimeInterval)time;


@end

NS_ASSUME_NONNULL_END
