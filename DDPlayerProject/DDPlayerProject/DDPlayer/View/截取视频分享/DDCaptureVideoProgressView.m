//
//  DDCaptureVideoProgressView.m
//  DDPlayerProject
//
//  Created by wuqh on 2018/11/21.
//  Copyright © 2018 wuqh. All rights reserved.
//

#import "DDCaptureVideoProgressView.h"
#import "DDPlayerTool.h"

@interface DDCaptureVideoProgressView()

@property(nonatomic, strong) UILabel *timeLabel;
@property(nonatomic, strong) UISlider *slider;

@end

@implementation DDCaptureVideoProgressView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self initialize];
        
    }
    return self;
}
- (void)initialize {
    
    self.layer.cornerRadius = 24;
    self.layer.masksToBounds = YES;
    
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    
    [self addSubview:self.timeLabel];
    [self addSubview:self.slider];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).mas_offset(8);
        make.centerX.equalTo(self);
    }];
    [self.slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.timeLabel.mas_bottom).offset(4);
        make.width.mas_equalTo(240);
        make.centerX.equalTo(self);
        make.height.mas_equalTo(10);
    }];
}

- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    
    if (progress < 3) {
        self.timeLabel.text = [NSString stringWithFormat:@"00:%02ld/00:%02ld 录制中，请稍后...",(long)progress,self.captureMaxDuration];
    }else {
        self.timeLabel.text = [NSString stringWithFormat:@"00:%02ld/00:%02ld 点击右侧按钮，完成录制...",(long)progress,self.captureMaxDuration];
    }
    
    self.slider.value = progress / self.captureMaxDuration;
    if (progress == self.captureMaxDuration) {
        self.slider.value = 1;
    }
}


- (void)setCaptureMaxDuration:(NSInteger)maxCaptureDuration {
    _captureMaxDuration = maxCaptureDuration;
    self.timeLabel.text = [NSString stringWithFormat:@"00:00/00:%02ld 录制中，请稍后...",self.captureMaxDuration];
}

#pragma mark - getter
- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = UIColor.whiteColor;
        _timeLabel.font = [DDPlayerTool PingFangSCRegularAndSize:13];
        _timeLabel.text =  @"00:00/00:00 录制中，请稍后...";
    }
    return _timeLabel;
}

- (UISlider *)slider {
    if (!_slider) {
        _slider = [[UISlider alloc] initWithFrame:CGRectMake(0, 0, 200, 10)];
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
