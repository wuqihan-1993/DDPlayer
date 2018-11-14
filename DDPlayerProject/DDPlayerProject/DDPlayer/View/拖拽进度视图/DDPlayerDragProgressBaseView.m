//
//  DDPlayerDragProgressBaseView.m
//  DDPlayerProject
//
//  Created by wuqh on 2018/11/14.
//  Copyright © 2018 wuqh. All rights reserved.
//

#import "DDPlayerDragProgressBaseView.h"
#import <Masonry.h>
#import "DDPlayerTool.h"

@interface DDPlayerDragProgressBaseView()



@end

@implementation DDPlayerDragProgressBaseView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    
    [self addSubview:self.timeLabel];
    [self addSubview:self.slider];
}

- (void)setProgress:(CGFloat)progress duration:(CGFloat)duration {
    
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = UIColor.whiteColor;
        _timeLabel.font = [UIFont systemFontOfSize:20];
    }
    return _timeLabel;
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
