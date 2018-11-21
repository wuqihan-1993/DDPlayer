//
//  DDPlayerView+ShowSubView.m
//  DDPlayerProject
//
//  Created by wuqh on 2018/11/15.
//  Copyright © 2018 wuqh. All rights reserved.
//

#import "DDPlayerView+ShowSubView.h"
#import "DDPlayerView+Private.h"

#import "DDPlayerContainerView.h"
#import "DDPlayerControlView.h"
#import "DDPlayerContentView.h"
#import <Masonry.h>

@implementation DDPlayerView (ShowSubView)

- (void)show:(UIView *)view origin:(DDPlayerShowOrigin)origin isDismissControl:(BOOL)isDismissControl isPause:(BOOL)isPause dismissCompletion:(void (^ __nullable)(void))dismiss{
    
    if (isDismissControl) {
        [self._getPlayerControlView dismiss];
    }
    if (isPause) {
        [self.player pause];
    }
    
    
    if (origin == DDPlayerShowOriginRight) {
        
        DDPlayerContainerView *containerView = [[DDPlayerContainerView alloc] initWithContentView:view alignment:DDPlayerContainerAlignmentRight];
        containerView.frame = CGRectMake(0, 0, DDPlayerTool.screenHeight, DDPlayerTool.screenWidth);
        containerView.dismissBlock = ^{
            [self._getPlayerControlView show];
            if (dismiss) {
                dismiss();
            }
        };
        [self addSubview:containerView];
        [self bringSubviewToFront:containerView];
        [self layoutIfNeeded];
        [containerView show];
        
    }else if (origin == DDPlayerShowOriginCenter) {
        
        if ([view isKindOfClass:[DDPlayerContentView class]]) {
            DDPlayerContentView *contentView = (DDPlayerContentView*)view;
            contentView.dismissBlock = dismiss;
        }

        [self addSubview:view];
        [self bringSubviewToFront:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        [self layoutIfNeeded];
        
    }else if (origin == DDPlayerShowOriginTop) {
        [self addSubview:view];
        [self bringSubviewToFront:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).mas_offset(20);
            make.centerX.equalTo(self);
        }];
        [self layoutIfNeeded];
    }
}

@end
