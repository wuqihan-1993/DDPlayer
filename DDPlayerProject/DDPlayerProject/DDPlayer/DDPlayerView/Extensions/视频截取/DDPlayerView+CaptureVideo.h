//
//  DDPlayerView+CaptureVideo.h
//  DDPlayerProject
//
//  Created by wuqh on 2018/11/21.
//  Copyright © 2018 wuqh. All rights reserved.
//

#import "DDPlayerView.h"

NS_ASSUME_NONNULL_BEGIN

@interface DDPlayerView (CaptureVideo)

@property(nonatomic, assign) BOOL isCapturingVideo;

- (void)captureVideoButtonClick:(UIButton *)captureVideoButton;

@end

NS_ASSUME_NONNULL_END
