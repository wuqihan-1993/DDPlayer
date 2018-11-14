//
//  DDVideoPlayerBottomBaseView.h
//  DDVideoPlayer
//
//  Created by wuqh on 2018/11/7.
//  Copyright © 2018 wuqh. All rights reserved.
//

#import "DDPlayerComponentBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface DDPlayerControlBottomBaseView : DDPlayerComponentBaseView

@property(nonatomic, copy) void(^playButtonClickBlock)(UIButton *);

@property(nonatomic, copy) void(^sliderBeginDragingBlock)(UISlider *);
@property(nonatomic, copy) void(^sliderDragingBlock)(UISlider *);
@property(nonatomic, copy) void(^sliderEndDragingBlock)(UISlider *);
@property(nonatomic, copy) void(^sliderTapBlock)(UISlider *);

@property(nonatomic, strong) UIImageView *maskView;
@property(nonatomic, strong) UIButton *playButton;
@property(nonatomic, strong) UISlider *slider;
@property(nonatomic, strong) UILabel *timeLabel;

@end

NS_ASSUME_NONNULL_END
