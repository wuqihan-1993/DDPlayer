//
//  DDPlayerContainerView.m
//  DDPlayerProject
//
//  Created by wuqh on 2018/11/13.
//  Copyright © 2018 wuqh. All rights reserved.
//

#import "DDPlayerContainerView.h"
#import "Masonry.h"
#import "DDPlayerTool.h"

@interface DDPlayerContainerView()<UIGestureRecognizerDelegate>

@property(nonatomic, weak) UIView *contentView;
@property(nonatomic, assign) DDPlayerContainerAlignment alignment;

@end

@implementation DDPlayerContainerView

- (void)dealloc {
    NSLog(@"%s",__FUNCTION__);
}

- (instancetype)initWithContentView:(UIView *)view alignment:(DDPlayerContainerAlignment)alignment {
    if (self = [super init]) {
        self.contentView = view;
        [self initialize];
    }
    return self;
}
- (void)initialize {
    self.contentView.bounds = CGRectMake(0, 0, DDPlayerTool.screenHeight*0.4, DDPlayerTool.screenWidth);
    [self addSubview:self.contentView];

    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_right);
        make.bottom.top.equalTo(self);
        make.width.mas_equalTo(DDPlayerTool.screenHeight*0.4);
    }];
    [self layoutIfNeeded];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    self.userInteractionEnabled = YES;
    tap.delegate = self;
    [self addGestureRecognizer:tap];
}
- (void)tapAction:(UITapGestureRecognizer *)tap {
    [self dismiss];
}
- (void)show {
    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_right).mas_offset(-DDPlayerTool.screenHeight*0.4);
    }];
    [UIView animateWithDuration:0.4 animations:^{
        [self.superview layoutIfNeeded];
    }];
}
- (void)dismiss {
    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_right);
    }];
    [UIView animateWithDuration:0.4 animations:^{
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if (self.dismissBlock) {
            self.dismissBlock();
        }
    }];
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    CGPoint point = [touch locationInView:self.contentView];
    if (point.x < 0 || point.y < 0) {
        return YES;
    }else {
        return NO;
    }
    return true;
}


@end
