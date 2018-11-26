//
//  DDLeftBottomPromptLabel.m
//  DDPlayerProject
//
//  Created by wuqh on 2018/11/22.
//  Copyright © 2018 wuqh. All rights reserved.
//

#import "DDLeftBottomPromptLabel.h"
#import "DDPlayerTool.h"

@interface DDLeftBottomPromptLabel()

@property(nonatomic, strong) UILabel *label;

@end

@implementation DDLeftBottomPromptLabel

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.label];
        [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}
- (UILabel *)label {
    if (!_label) {
        _label = [[UILabel alloc] init];
        _label.font = [DDPlayerTool PingFangSCRegularAndSize:13];
        _label.textColor = [DDPlayerTool colorWithRGBHex:0x61d8bb];
    }
    return _label;
}

- (void)updateUIWithPortrait {
    if (!self.superview) {
        return;
    }
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.superview).mas_offset(20);
        make.bottom.equalTo(self.superview).mas_offset(-50);
    }];
}
- (void)updateUIWithLandscape {
    if (!self.superview) {
        return;
    }
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.superview).mas_offset(DDPlayerTool.isiPhoneX ? 44 : 20);
        make.bottom.equalTo(self.superview).mas_offset(-88);
    }];
}
- (void)setText:(NSString *)text {
    _text = text;
    self.label.text = text;
}

@end
