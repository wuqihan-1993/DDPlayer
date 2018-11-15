//
//  DDCaptureImageShareSmallView.m
//  DDPlayerProject
//
//  Created by wuqh on 2018/11/14.
//  Copyright © 2018 wuqh. All rights reserved.
//

#import "DDCaptureImageShareSmallView.h"
#import <Masonry.h>

@interface DDCaptureImageShareSmallView()

@property(nonatomic, strong) UIImageView *imageView;
@property(nonatomic, strong) UIView *bottomCoverView;
@property(nonatomic, strong) UIButton *shareButton;

@end

@implementation DDCaptureImageShareSmallView

- (void)dealloc {
    NSLog(@"%s",__FUNCTION__);
}

- (instancetype)initWithImage:(UIImage *)image {
    if (self = [super init]) {
        self.imageView.image = image;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    self.layer.cornerRadius = 4;
    self.layer.masksToBounds = YES;
    
    [self addSubview:self.imageView];
    [self addSubview:self.shareButton];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.width.mas_equalTo(90);
        make.height.mas_equalTo(90*9/16);
    }];
    [self.shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageView.mas_bottom);
        make.left.right.equalTo(self);
        make.height.mas_equalTo(30);
        make.bottom.equalTo(self);
    }];
    
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self addGestureRecognizer:tap];
}

- (void)tap:(UITapGestureRecognizer *)tap {
    if (self.toShareBlock) {
        self.toShareBlock(self.imageView.image);
    }
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}
- (UIButton *)shareButton {
    if (!_shareButton) {
        _shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shareButton setTitle:@" 点击分享" forState:UIControlStateNormal];
        _shareButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [_shareButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_shareButton setImage:[UIImage imageNamed:@"DDPlayer_Btn_CaptureShare"] forState:UIControlStateNormal];
        _shareButton.userInteractionEnabled = NO;
    }
    return _shareButton;
}

@end
