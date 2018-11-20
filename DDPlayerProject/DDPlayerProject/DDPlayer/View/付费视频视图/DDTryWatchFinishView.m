//
//  DDTryWatchFinishView.m
//  DDPlayerProject
//
//  Created by wuqh on 2018/11/20.
//  Copyright © 2018 wuqh. All rights reserved.
//

#import "DDTryWatchFinishView.h"

@interface DDTryWatchFinishView()

@property(nonatomic, strong) UIButton *backButton;
@property(nonatomic, strong) UILabel *promptLabel;
@property(nonatomic, strong) UIButton *buyButton;
@property(nonatomic, strong) UIButton *retryWatchButton;

@end

@implementation DDTryWatchFinishView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

- (void)initialize {
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
}

@end
