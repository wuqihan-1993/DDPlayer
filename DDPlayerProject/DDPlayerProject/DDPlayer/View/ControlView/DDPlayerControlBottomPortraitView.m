//
//  DDVideoPlayerBottomPortraitView.m
//  DDVideoPlayer
//
//  Created by wuqh on 2018/11/7.
//  Copyright © 2018 wuqh. All rights reserved.
//

#import "DDPlayerControlBottomPortraitView.h"
#import "Masonry.h"
#import "DDPlayerTool.h"

@interface DDPlayerControlBottomPortraitView()
@property(nonatomic, strong) UIButton *landscapeButton;
@end

@implementation DDPlayerControlBottomPortraitView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self updateUI];
    }
    return self;
}
- (void)updateUI {
    [self addSubview:self.landscapeButton];
    
    [self.playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).mas_offset(20);
        make.centerY.equalTo(self);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.playButton.mas_right).mas_offset(12);
        make.centerY.equalTo(self);
        make.width.mas_equalTo(100);
    }];
    
    [self.slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.timeLabel.mas_right).mas_offset(12);
        make.right.equalTo(self.landscapeButton.mas_left).mas_offset(-12);
        make.centerY.equalTo(self);
        make.height.mas_equalTo(40);
    }];
    
    [self.landscapeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).mas_offset(-20);
        make.centerY.equalTo(self);
    }];
}

- (void)landscapeButtonClick:(UIButton *)button {
    [DDPlayerTool forceRotatingScreen:UIInterfaceOrientationLandscapeRight];
}


- (UIButton *)landscapeButton {
    if (!_landscapeButton) {
        _landscapeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_landscapeButton setImage:[UIImage imageNamed:@"DDPlayer_Btn_ForceOrientatedLandscape"] forState:UIControlStateNormal];
        [_landscapeButton addTarget:self action:@selector(landscapeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _landscapeButton;
}


@end
