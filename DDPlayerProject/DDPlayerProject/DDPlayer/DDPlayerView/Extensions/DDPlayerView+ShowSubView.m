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
#import "DDLeftBottomPromptLabel.h"
#import <objc/runtime.h>
static void* _leftBottomPromptLabelKey = &_leftBottomPromptLabelKey;

@implementation DDPlayerView (ShowSubView)

- (DDLeftBottomPromptLabel *)leftBottomPromptLabel {
    if (objc_getAssociatedObject(self, _leftBottomPromptLabelKey)) {
        return objc_getAssociatedObject(self, _leftBottomPromptLabelKey);
    }else {
        DDLeftBottomPromptLabel *label = [[DDLeftBottomPromptLabel alloc] init];
        self.leftBottomPromptLabel = label;
        return label;
    }
}
- (void)setLeftBottomPromptLabel:(DDLeftBottomPromptLabel *)leftBottomPromptLabel {
    objc_setAssociatedObject(self, _leftBottomPromptLabelKey, leftBottomPromptLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


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
            make.top.equalTo(self).mas_offset(DDPlayerTool.isScreenPortrait ? 20 : 33);
            make.centerX.equalTo(self);
        }];
        [self layoutIfNeeded];
    }else if(origin == DDPlayerShowOriginLeftBottom) {
        [self addSubview:view];
        [self bringSubviewToFront:view];
        if (DDPlayerTool.isScreenPortrait) {
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self).mas_offset(-50);
                make.left.equalTo(self).mas_offset(20);
            }];
        }else {
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self).mas_offset(-88);
                make.left.equalTo(self).mas_offset(DDPlayerTool.isiPhoneX ? 44 : 20);
            }];
        }
        [view performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:2];
        [self layoutIfNeeded];
    }
}

- (void)showLeftBottomRromptLabel:(NSString *)prompt {
    self.leftBottomPromptLabel.text = prompt;
    [self show:self.leftBottomPromptLabel origin:DDPlayerShowOriginLeftBottom isDismissControl:NO isPause:NO dismissCompletion:nil];
}

@end
