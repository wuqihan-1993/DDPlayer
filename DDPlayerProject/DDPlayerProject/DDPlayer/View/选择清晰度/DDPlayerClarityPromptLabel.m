//
//  DDPlayerClarityPromptLabel.m
//  DDPlayerProject
//
//  Created by wuqh on 2018/11/19.
//  Copyright © 2018 wuqh. All rights reserved.
//

#import "DDPlayerClarityPromptLabel.h"
#import "DDPlayerTool.h"

@interface DDPlayerClarityPromptLabel()

@property(nonatomic, copy) NSString *clarityStr;

@end

@implementation DDPlayerClarityPromptLabel

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.font = [DDPlayerTool PingFangSCRegularAndSize:14];
        self.textColor = UIColor.whiteColor;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    }
    return self;
}

- (void)choose:(DDPlayerClarity)clarity {
    NSString *clarityStr;
    switch (clarity) {
        case DDPlayerClarityDefault:
            clarityStr = @"标准";
            break;
        case DDPlayerClarityFluency:
            clarityStr = @"流畅";
            break;
        default:
            break;
    }
    self.clarityStr = clarityStr;
    NSString *text = [NSString stringWithFormat:@"正在切换到%@，请稍候...",clarityStr];
    NSMutableAttributedString *attText = [[NSMutableAttributedString alloc]initWithString:text];
    [attText addAttribute:NSForegroundColorAttributeName value:[DDPlayerTool colorWithRGBHex:0x61d8bb] range:[text rangeOfString:clarityStr]];
    self.attributedText = attText;
}
- (void)chooseSuccess {
    NSString *text = [NSString stringWithFormat:@"您已切换到%@",self.clarityStr];
    NSMutableAttributedString *attText = [[NSMutableAttributedString alloc]initWithString:text];
    [attText addAttribute:NSForegroundColorAttributeName value:[DDPlayerTool colorWithRGBHex:0x61d8bb] range:[text rangeOfString:self.clarityStr]];
    self.attributedText = attText;
    [self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:1];
}

@end
