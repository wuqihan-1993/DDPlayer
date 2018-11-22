//
//  DDPlayerView+SwitchLine.m
//  DDPlayerProject
//
//  Created by wuqh on 2018/11/22.
//  Copyright © 2018 wuqh. All rights reserved.
//

#import "DDPlayerView+SwitchLine.h"
#import "DDPlayerView+Private.h"
#import "DDPlayerClarityChoiceView.h"
#import "DDPlayerContainerView.h"
#import "DDPlayerManager.h"
#import "DDPlayerView+ShowSubView.h"
#import "DDPlayerClarityPromptLabel.h"
#import <objc/runtime.h>
#import "DDPlayerControlView.h"

@implementation DDPlayerView (SwitchLine)

static void * _clarityPromptLabelKey = &_clarityPromptLabelKey;
static void * _clarityChoiceViewKey = &_clarityChoiceViewKey;

- (DDPlayerClarityChoiceView *)clarityChoiceView {
    if (objc_getAssociatedObject(self, _clarityChoiceViewKey) != nil) {
        return objc_getAssociatedObject(self, _clarityChoiceViewKey);
    }else {
        DDPlayerClarityChoiceView *clarityChoiceView = [[DDPlayerClarityChoiceView alloc] init];
        __weak typeof(self) weakSelf = self;
        clarityChoiceView.clarityButtonClickBlock = ^(DDPlayerClarity clarity, UIButton * _Nonnull button) {
            [weakSelf switchLineWithClarity:clarity clarityButton:button];
        };
        self.clarityChoiceView = clarityChoiceView;
        return clarityChoiceView;
    }
}
- (void)setClarityChoiceView:(DDPlayerClarityChoiceView *)clarityChoiceView {
    objc_setAssociatedObject(self, _clarityChoiceViewKey, clarityChoiceView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (DDPlayerClarityPromptLabel *)clarityPromptLabel {
    if (objc_getAssociatedObject(self, _clarityPromptLabelKey)) {
        return objc_getAssociatedObject(self, _clarityPromptLabelKey);
    }else {
        DDPlayerClarityPromptLabel *clarityPromptLabel = [[DDPlayerClarityPromptLabel alloc] init];
        self.clarityPromptLabel = clarityPromptLabel;
        return clarityPromptLabel;
    }
}
- (void)setClarityPromptLabel:(DDPlayerClarityPromptLabel *)clarityPromptLabel {
    objc_setAssociatedObject(self, _clarityPromptLabelKey, clarityPromptLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)switchLineWithClarity:(DDPlayerClarity)clarity clarityButton:(UIButton *)clarityButton {
    if (self.clarityChoiceView.clarity == clarity) {
        //如果点击s的是同样的清晰度。则直接返回
        [(DDPlayerContainerView*)self.clarityChoiceView.superview dismiss];
        return ;
    }
    //1.保存当前时间
    NSTimeInterval lastTime = self.player.currentTime;
    
    //2.截取当前时间图片
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[DDPlayerManager thumbnailImageWithAsset:self.player.currentAsset currentTime:self.player.currentItem.currentTime]];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self show:imageView origin:DDPlayerShowOriginCenter isDismissControl:YES isPause:NO dismissCompletion:nil];
    [self insertSubview:imageView belowSubview:self._getPlayerControlView];
    
    //3.截取
    [self.clarityPromptLabel choose:clarity];
    [self show:self.clarityPromptLabel origin:DDPlayerShowOriginTop isDismissControl:YES isPause:NO dismissCompletion:nil];
    
    if ([self.delegate respondsToSelector:@selector(playerViewChooseClarity:success:failure:)]) {
        
        //截取完成
        [(DDPlayerContainerView*)self.clarityChoiceView.superview dismiss];
        
        __weak typeof(self) weakSelf = self;
        [self.delegate playerViewChooseClarity:clarity success:^(NSString * _Nonnull url) {
            //4.截取成功
            [weakSelf.player playWithUrl:url];
            [weakSelf.player seekToTime:lastTime isPlayImmediately:YES completionHandler:^(BOOL complete) {
                clarityButton.selected = YES;
                [weakSelf.clarityPromptLabel chooseSuccess];
                [imageView removeFromSuperview];
            }];
            [(UIButton*)[weakSelf._getPlayerControlView.bottomLandscapeView valueForKey:@"clarityButton"] setTitle:clarityButton.titleLabel.text forState:UIControlStateNormal];
            weakSelf.clarityChoiceView.clarity = clarity;
        } failure:^{
            [weakSelf.clarityPromptLabel chooseFail];
            [imageView removeFromSuperview];
        }];
    }
}


@end
