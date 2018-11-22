//
//  DDCaptureVideoView.m
//  DDPlayerProject
//
//  Created by wuqh on 2018/11/21.
//  Copyright © 2018 wuqh. All rights reserved.
//

#import "DDCaptureVideoView.h"
#import "DDPlayerTool.h"
#import "DDCaptureVideoProgressView.h"
@interface DDCaptureVideoView()



@property(nonatomic, strong) UIButton *backButton;
@property(nonatomic, strong) UIButton *captureButton;
@property(nonatomic, strong) DDCaptureVideoProgressView *captureProgressView;


@end


@implementation DDCaptureVideoView

- (void)dealloc {
    NSLog(@"%s",__FUNCTION__);
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    
    //添加虚线边框
    CAShapeLayer *borderLayer = [CAShapeLayer layer];
    borderLayer.frame = CGRectMake(0, 0, DDPlayerTool.screenHeight, DDPlayerTool.screenWidth);
    borderLayer.path = [UIBezierPath bezierPathWithRect:borderLayer.bounds].CGPath;
    borderLayer.lineWidth = 3;
    borderLayer.lineDashPattern = @[@8, @8];
    borderLayer.fillColor = [UIColor clearColor].CGColor;
    borderLayer.strokeColor = [UIColor whiteColor].CGColor;
    [self.layer addSublayer:borderLayer];
    
    //subView
    [self addSubview:self.backButton];
    [self addSubview:self.captureButton];
    [self addSubview:self.captureProgressView];
    
    //layout
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).mas_offset(33);
        make.left.equalTo(self).mas_offset(DDPlayerTool.isiPhoneX ? 44 : 20);
        make.width.mas_equalTo(68);
        make.height.mas_equalTo(26);
    }];
    
    [self.captureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(DDPlayerTool.isiPhoneX ? -44 : -20);
        make.centerY.equalTo(self);
    }];
    
    [self.captureProgressView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-20);
        make.centerX.equalTo(self);
        make.width.mas_equalTo(280);
        make.height.mas_equalTo(48);
    }];
    
}

#pragma mark - public
// 该方法每0.5s调用一次 因为DDPlayer 监听时间变化的方法是每0.5s执行一次
- (void)timeChanged:(NSTimeInterval)time {
    self.currentTime += 0.5;
    self.captureProgressView.progress = self.currentTime;
    self.captureButton.enabled = (self.currentTime >= 3);
    if (self.currentTime > 15) {
        //截取结束
        [self finishCapture];
    }
}

#pragma mark - private
//- (void)startCapture {
//
//}
- (void)finishCapture {
    if (self.finishBlock) {
        self.finishBlock();
    }
}

#pragma mark - action
- (void)backButtonClick:(UIButton *)button {
    if (self.dismissBlock) {
        self.dismissBlock();
    }
}
- (void)captureButtonClick:(UIButton *)button {
    [self finishCapture];
}

#pragma mark - setter
- (void)setCaptureMaxDuration:(NSInteger)captureMaxDuration {
    _captureMaxDuration = captureMaxDuration;
    self.captureProgressView.captureMaxDuration = captureMaxDuration;
}

#pragma mark - getter
- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backButton setTitle:@"取消" forState:UIControlStateNormal];
        [_backButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _backButton.titleLabel.font = [DDPlayerTool PingFangSCRegularAndSize:15];
        _backButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
        _backButton.layer.cornerRadius = 13;
        _backButton.layer.masksToBounds = true;
        [_backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}
- (UIButton *)captureButton {
    if (!_captureButton) {
        //截取按钮
        _captureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_captureButton setImage:[UIImage imageNamed:@"DDPlayer_Btn_VideoCapture_disabled"] forState:UIControlStateDisabled];
        [_captureButton setImage:[UIImage imageNamed:@"DDPlayer_Btn_VideoCapture_normal"] forState:UIControlStateNormal];
        [_captureButton addTarget:self action:@selector(captureButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _captureButton.enabled = NO;
    }
    return _captureButton;
}
- (DDCaptureVideoProgressView *)captureProgressView {
    if (!_captureProgressView) {
        _captureProgressView = [[DDCaptureVideoProgressView alloc] init];
    }
    return _captureProgressView;
}

@end
