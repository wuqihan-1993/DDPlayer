//
//  DDPlayerBackButton.m
//  aries
//
//  Created by wuqh on 2018/11/23.
//  Copyright © 2018 wuqh. All rights reserved.
//

#import "DDPlayerBackButton.h"
#import "DDPlayerUIFactory.h"

@implementation DDPlayerBackButton

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UIButton *backButton = [DDPlayerUIFactory backButtonWithTarget:self action:NSSelectorFromString(@"backButtonClick:")];
        [self addSubview:backButton];
        [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}

- (void)updateUIWithPortrait {
    self.hidden = NO;
}
- (void)updateUIWithLandscape {
    self.hidden = YES;
}
- (void)backButtonClick:(UIButton *)button {
    if (self.backBlock) {
        self.backBlock(button);
    }
}
@end
