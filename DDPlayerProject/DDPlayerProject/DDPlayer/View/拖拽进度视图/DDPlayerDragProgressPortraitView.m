//
//  DDPlayerDragProgressPortraitView.m
//  DDPlayerProject
//
//  Created by wuqh on 2018/11/14.
//  Copyright © 2018 wuqh. All rights reserved.
//

#import "DDPlayerDragProgressPortraitView.h"
#import "DDPlayerTool.h"
#import <Masonry.h>

@interface DDPlayerDragProgressPortraitView()

@property (nonatomic, strong) UISlider *slider;

@end

@implementation DDPlayerDragProgressPortraitView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    
    self.timeLabel.text = @"00:00";
    [self addSubview:self.slider];
    
    [self.slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.equalTo(self).multipliedBy(0.3);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.slider.mas_top).mas_offset(-20);
        make.centerX.equalTo(self);
    }];
}


- (void)setProgress:(CGFloat)progress duration:(CGFloat)duration {
    self.slider.value = progress;
    self.timeLabel.text = [DDPlayerTool translateTimeToString:duration*progress];
}


- (UISlider *)slider {
    if (!_slider) {
        
        _slider = [[UISlider alloc] init];
        _slider.userInteractionEnabled = NO;
        _slider.tintColor = [DDPlayerTool colorWithRGBHex:0x61d8bb];
        
        //隐藏滑块
        CGSize s=CGSizeMake(0.1, 0.1);
        UIGraphicsBeginImageContextWithOptions(s, 0, [UIScreen mainScreen].scale);
        UIRectFill(CGRectMake(0, 0, 0.1, 0.1));
        UIImage *img=UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [_slider setThumbImage:img forState:UIControlStateNormal];
        
    }
    return _slider;
}


@end
