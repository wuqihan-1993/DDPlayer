//
//  DDVideoPlayerTopView.h
//  DDVideoPlayer
//
//  Created by wuqh on 2018/11/7.
//  Copyright © 2018 wuqh. All rights reserved.
//

#import "DDVideoPlayerComponentBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface DDVideoPlayerTopView : DDVideoPlayerComponentBaseView

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) void (^backTitleButtonClickBlock)(UIButton *);

@end

NS_ASSUME_NONNULL_END
