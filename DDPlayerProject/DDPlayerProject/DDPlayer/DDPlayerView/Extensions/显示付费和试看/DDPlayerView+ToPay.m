//
//  DDPlayerView+ToPay.m
//  DDPlayerProject
//
//  Created by wuqh on 2018/11/23.
//  Copyright © 2018 wuqh. All rights reserved.
//

#import "DDPlayerView+ToPay.h"
#import "DDNeedPayView.h"
#import "DDPlayerView+ShowSubView.h"
#import <objc/runtime.h>

static void* _needPayViewKey = &_needPayViewKey;

@implementation DDPlayerView (ToPay)

- (DDNeedPayView *)needPayView {
    if (objc_getAssociatedObject(self, _needPayViewKey)) {
        return objc_getAssociatedObject(self, _needPayViewKey);
    }else {
        DDNeedPayView *needPayView = [[DDNeedPayView alloc] init];
        __weak typeof(self) weakSelf = self;
        needPayView.toPayBlock = ^{
            if([weakSelf.delegate respondsToSelector:@selector(playerViewNeedToPay)]) {
                [weakSelf.delegate playerViewNeedToPay];
            }
        };
        needPayView.backBlock = ^(UIButton * _Nonnull button) {
            if ([weakSelf.delegate respondsToSelector:@selector(playerViewClickBackButton:)]) {
                [weakSelf.delegate playerViewClickBackButton:button];
            }
        };
        self.needPayView = needPayView;
        return needPayView;
    }
}
- (void)setNeedPayView:(DDNeedPayView *)needPayView {
    objc_setAssociatedObject(self, _needPayViewKey, needPayView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)showNeedPayView {
    self.player.isNeedCanPlay = NO;
    __weak typeof(self) weakSelf = self;
    [self show:self.needPayView origin:DDPlayerShowOriginCenter isDismissControl:YES isPause:YES dismissCompletion:^{
        weakSelf.player.isNeedCanPlay = YES;
    }];
}
- (void)dismissNeedPayView {
    if (objc_getAssociatedObject(self, _needPayViewKey)) {
        self.needPayView.dismissBlock();
        [self.needPayView removeFromSuperview];
        self.needPayView = nil;
    }
}

@end
