//
//  DDPlayerClarityChoiceView.m
//  DDPlayerProject
//
//  Created by wuqh on 2018/11/19.
//  Copyright © 2018 wuqh. All rights reserved.
//

#import "DDPlayerClarityChoiceView.h"
#import "DDPlayerTool.h"

@interface DDPlayerClarityChoiceView()

@property(nonatomic, strong) UIStackView *stackView;

@end

@implementation DDPlayerClarityChoiceView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
    
    UILabel *label = [[UILabel alloc]init];
    label.font = [DDPlayerTool PingFangSCRegularAndSize:15];
    label.textColor = UIColor.whiteColor;
    label.text = @"清晰度";
    [self addSubview:label];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor colorWithWhite:1 alpha:0.2];
    [self addSubview:line];
    
    [self addSubview:self.stackView];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).mas_offset(10);
        make.right.equalTo(self).mas_offset(-10);
        make.top.equalTo(self).mas_offset(44);
        make.height.mas_equalTo(1);
    }];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom).mas_offset(14);
        make.centerX.equalTo(self);
    }];
    [self.stackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
    
    
}

- (void)setClarityArray:(NSMutableArray *)clarityArray {
    _clarityArray = clarityArray;
    
    if (self.stackView.subviews.count > 0) {
        [self.stackView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    

    for (NSInteger i = 0; i < clarityArray.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:clarityArray[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:14/255.0 green:197/255.0 blue:131/255.0 alpha:1.0] forState:UIControlStateSelected];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button.titleLabel setFont:[DDPlayerTool PingFangSCRegularAndSize:15]];
        [button addTarget:self action:@selector(clarityButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0) {
            button.selected = YES;
        }
        [self.stackView addArrangedSubview:button];
    }
    
    
}

- (UIStackView *)stackView {
    if (!_stackView) {
        _stackView = [[UIStackView alloc] init];
        _stackView.axis = UILayoutConstraintAxisVertical;
        _stackView.spacing = 20;
    }
    return _stackView;
}


#pragma mark - action
- (void)clarityButtonClick:(UIButton *)button {
    
}

@end
