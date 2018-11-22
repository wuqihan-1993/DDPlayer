//
//  DDCaptureVideoCommentView.m
//  DDPlayerProject
//
//  Created by wuqh on 2018/11/22.
//  Copyright © 2018 wuqh. All rights reserved.
//

#import "DDCaptureVideoCommentView.h"
#import "DDPlayerTool.h"
#import "DDTextView.h"

@interface DDCaptureVideoCommentView()<UITextFieldDelegate>

@property (nonatomic, strong) UIButton *confirmButton;

@end


@implementation DDCaptureVideoCommentView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}
#pragma mark action
- (void)confirmButtonClick:(UIButton *)btn {
    if (self.confirmBlock) {
        self.confirmBlock(self.textView.text);
    }
}

#pragma mark ui
- (void)setupUI {
    
    self.textView = [[DDTextView alloc] init];
    self.textView.placeholder = @"分享我的课程感悟......";
    self.textView.placeholderFont = [DDPlayerTool PingFangSCRegularAndSize:16];
    self.textView.placeholderColor = [UIColor lightGrayColor];
    
    self.textView.font = [DDPlayerTool PingFangSCRegularAndSize:16];
    self.textView.textColor = UIColor.blackColor;
    self.textView.backgroundColor = UIColor.whiteColor;
    self.textView.cornerRadius = 2;
    self.textView.maxNumberOfLines = 3;
    __weak typeof(self) weakSelf = self;
    [self.textView setTextViewChanged:^(NSString *text, CGFloat textHeight) {
        [weakSelf.textView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(textHeight);
        }];
        [UIView animateWithDuration:0.4 animations:^{
            [weakSelf layoutIfNeeded];
        }];
    }];
    [self addSubview:self.textView];
    
    self.confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.confirmButton.layer.cornerRadius = 2;
    self.confirmButton.layer.masksToBounds = YES;
    [self.confirmButton setTitle:@"确 定" forState:UIControlStateNormal];
    self.confirmButton.titleLabel.font = [DDPlayerTool PingFangSCRegularAndSize:16];
    [self.confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.confirmButton.backgroundColor = [DDPlayerTool colorWithRGBHex:0x61d8bb];
    [self.confirmButton addTarget:self action:@selector(confirmButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.confirmButton];
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).mas_offset(DDPlayerTool.isiPhoneX ? 44 : 25);
        make.bottom.equalTo(self.confirmButton.mas_bottom);
        make.right.equalTo(self.confirmButton.mas_left).offset(-12);
        make.height.mas_equalTo(39);
        make.top.equalTo(self).offset(12);
    }];
    
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).mas_offset(-12);
        make.right.equalTo(self).mas_offset(DDPlayerTool.isiPhoneX ? -44 : -25);
        make.width.mas_equalTo(82);
        make.height.mas_equalTo(39);
    }];
    
}

@end
