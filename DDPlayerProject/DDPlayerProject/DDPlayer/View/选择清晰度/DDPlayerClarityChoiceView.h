//
//  DDPlayerClarityChoiceView.h
//  DDPlayerProject
//
//  Created by wuqh on 2018/11/19.
//  Copyright © 2018 wuqh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDPlayerStatus.h"
#import "DDPlayerClarityTool.h"
NS_ASSUME_NONNULL_BEGIN


@interface DDPlayerClarityChoiceView : UIView

@property(nonatomic, copy) void(^clarityButtonClickBlock)(DDPlayerClarity,UIButton*);

@property(nonatomic, assign) DDPlayerClarity clarity;

@end

NS_ASSUME_NONNULL_END
