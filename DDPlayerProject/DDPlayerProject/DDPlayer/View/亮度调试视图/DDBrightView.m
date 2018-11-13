//
//  DDBrightView.m
//  DDPlayerProject
//
//  Created by wuqh on 2018/11/12.
//  Copyright © 2018 wuqh. All rights reserved.
//

#import "DDBrightView.h"
#import "Masonry.h"

@interface DDBrightView()

@property(nonatomic,strong)NSTimer *timer;

@property(nonatomic,strong)NSMutableArray *tipArray;

@property(nonatomic, strong) UIImageView *iconImageView;
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UIView  *brightnessLevelView;

@end

@implementation DDBrightView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [[UIApplication sharedApplication].keyWindow addSubview:self];
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo([UIApplication sharedApplication].keyWindow);
            make.height.width.mas_equalTo(155);
        }];
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.layer.cornerRadius = 10;
    self.layer.masksToBounds = YES;
    self.backgroundColor = UIColor.whiteColor;
    
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"DDPlayer_Bg_Bright"]];
    [self addSubview:bgImageView];
    
    [self addSubview:self.titleLabel];
    [self addSubview:self.iconImageView];
    [self addSubview:self.brightnessLevelView];
    
    self.alpha = 0;
    
    [bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).mas_offset(5);
        make.centerX.equalTo(self);
        make.height.mas_equalTo(30);
    }];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
    }];
    [self.brightnessLevelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).mas_offset(13);
        make.top.mas_equalTo(self).mas_offset(132);
        make.right.mas_equalTo(self).mas_offset(-13);
        make.height.mas_equalTo(7);
    }];
    [self createTips];
}

- (void)createTips {
    
    self.tipArray = [NSMutableArray arrayWithCapacity:16];
    CGFloat tipW = (155 - 26 - 17) / 16;
    CGFloat tipH = 5;
    CGFloat tipY = 1;
    
    for (int i = 0; i < 16; i++) {
        CGFloat tipX = i * (tipW + 1) + 1;
        UIImageView *image = [[UIImageView alloc] init];
        image.backgroundColor = [UIColor whiteColor];
        [self.brightnessLevelView addSubview:image];
        [self.tipArray addObject:image];
        [image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.brightnessLevelView).mas_offset(tipX);
            make.top.mas_equalTo(self.brightnessLevelView).mas_offset(tipY);
            make.width.mas_equalTo(tipW);
            make.height.mas_equalTo(tipH);
        }];
    }
    [self updateBrightnessLevel:self.bright];
}
- (void)updateBrightnessLevel:(CGFloat)brightnessLevel {
//    NSLog(@"%.6lf",brightnessLevel);
    CGFloat stage = 1 / 15.0;
    NSInteger level = brightnessLevel / stage;
    for (int i = 0; i < self.tipArray.count; i++) {
        UIImageView *img = self.tipArray[i];
        if (i <= level) {
            img.hidden = NO;
        } else {
            img.hidden = YES;
        }
    }
}

- (void)appearBrightnessView {
    [UIView animateWithDuration:0.01 animations:^{
        self.alpha = 1;
    } completion:^(BOOL finished) {
        [self addtimer];
    }];
}

- (void)disAppearBrightnessView {
    if (self.alpha == 1.0) {
        [UIView animateWithDuration:0.5 animations:^{
            self.alpha = 0.0;
        } completion:^(BOOL finished) {
            [self removeTimer];
        }];
    }
}

-(void)disAppearBrightViewImmediately{
    self.alpha = 0.0;
}

- (void)addtimer {
    if (self.timer) {
        return;
    }
    self.timer = [NSTimer timerWithTimeInterval:2
                                         target:self
                                       selector:@selector(disAppearBrightnessView)
                                       userInfo:nil
                                        repeats:NO];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
}

- (void)removeTimer{
    [self.timer invalidate];
    self.timer = nil;
}

#pragma mark - setter
-(void)setBright:(CGFloat)bright{
    _bright = bright;
    [self removeTimer];
    [self appearBrightnessView];
    [self updateBrightnessLevel:bright];
}

#pragma mark - getter
- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"DDPlayer_Img_Bright"]];
    }
    return _iconImageView;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.text = @"亮度";
        _titleLabel.textColor = [UIColor colorWithRed:0.25f green:0.22f blue:0.21f alpha:1.00f];
    }
    return _titleLabel;
}
-(UIView *)brightnessLevelView {
    
    if (!_brightnessLevelView) {
        _brightnessLevelView  = [[UIView alloc]init];
        _brightnessLevelView.backgroundColor = [UIColor colorWithRed:0.25f green:0.22f blue:0.21f alpha:1.00f];
        [self addSubview:_brightnessLevelView];
    }
    return _brightnessLevelView;
}



@end
