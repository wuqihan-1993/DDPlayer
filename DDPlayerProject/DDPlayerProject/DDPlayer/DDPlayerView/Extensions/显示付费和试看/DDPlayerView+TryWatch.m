//
//  DDPlayerView+tryWatch.m
//  DDPlayerProject
//
//  Created by wuqh on 2018/11/23.
//  Copyright © 2018 wuqh. All rights reserved.
//

#import "DDPlayerView+TryWatch.h"
#import <objc/runtime.h>
#import "DDTryWatchView.h"
#import "DDPlayerView+ShowSubView.h"

@implementation DDPlayerView (TryWatch)

static void* _tryWatchViewKey = &_tryWatchViewKey;

- (DDTryWatchView *)tryWatchView {
    if (objc_getAssociatedObject(self, _tryWatchViewKey)) {
        return objc_getAssociatedObject(self, _tryWatchViewKey);
    }else {
        DDTryWatchView *tryWatchView = [[DDTryWatchView alloc] init];
        __weak typeof(self) weakSelf = self;
        tryWatchView.backBlock = ^(UIButton * _Nonnull button) {
            if ([weakSelf.delegate respondsToSelector:@selector(playerViewClickBackButton:)]) {
                [weakSelf.delegate playerViewClickBackButton:button];
            }
        };
        tryWatchView.buyBlock = ^(UIButton * _Nonnull button) {
            if ([weakSelf.delegate respondsToSelector:@selector(playerViewNeedToPay)]) {
                [weakSelf.delegate playerViewNeedToPay];
            }
        };
        tryWatchView.retryWatchBlock = ^(UIButton * _Nonnull button) {
            [weakSelf dismissTryWatchView];
            [weakSelf.player seekToTime:0 isPlayImmediately:YES completionHandler:nil];
        };
        self.tryWatchView = tryWatchView;
        return tryWatchView;
    }
}
- (void)setTryWatchView:(DDTryWatchView *)tryWatchView {
    objc_setAssociatedObject(self, _tryWatchViewKey, tryWatchView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)showTryWatchView {
    self.player.isNeedCanPlay = NO;
    __weak typeof(self) weakSelf = self;
    [self show:self.tryWatchView origin:DDPlayerShowOriginCenter isDismissControl:YES isPause:YES dismissCompletion:^{
        weakSelf.player.isNeedCanPlay = YES;
    }];
}
- (void)dismissTryWatchView {
    if (objc_getAssociatedObject(self, _tryWatchViewKey)) {
        self.tryWatchView.dismissBlock();
        [self.tryWatchView removeFromSuperview];
        self.tryWatchView = nil;
    }
}

@end
