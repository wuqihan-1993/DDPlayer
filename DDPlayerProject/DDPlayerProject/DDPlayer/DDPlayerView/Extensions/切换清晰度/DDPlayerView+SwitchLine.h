//
//  DDPlayerView+SwitchLine.h
//  DDPlayerProject
//
//  Created by wuqh on 2018/11/22.
//  Copyright © 2018 wuqh. All rights reserved.
//

#import "DDPlayerView.h"

@class DDPlayerClarityPromptLabel;
@class DDPlayerClarityChoiceView;

@interface DDPlayerView (SwitchLine)

@property(nonatomic, strong) DDPlayerClarityChoiceView *clarityChoiceView;
@property(nonatomic, strong) DDPlayerClarityPromptLabel *clarityPromptLabel;

- (void)switchLineWithClarity:(DDPlayerClarity)clarity clarityButton:(UIButton *)clarityButton;

@end


