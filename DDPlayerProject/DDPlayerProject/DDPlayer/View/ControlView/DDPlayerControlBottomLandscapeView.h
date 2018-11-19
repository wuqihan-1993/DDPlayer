//
//  DDVideoPlayerBottomLandscapeView.h
//  DDVideoPlayer
//
//  Created by wuqh on 2018/11/7.
//  Copyright © 2018 wuqh. All rights reserved.
//

#import "DDPlayerControlBottomBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface DDPlayerControlBottomLandscapeView : DDPlayerControlBottomBaseView

@property(nonatomic, copy) void(^forwardButtonClickBlock)(UIButton *);
@property(nonatomic, copy) void(^chapterButtonClickBlock)(UIButton *);
@property(nonatomic, copy) void(^rateButtonClickBlock)(UIButton *);
@property(nonatomic, copy) void(^clarityButtonClickBlock)(UIButton *);


@end

NS_ASSUME_NONNULL_END
