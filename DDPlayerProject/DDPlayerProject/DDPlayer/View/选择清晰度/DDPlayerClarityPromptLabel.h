//
//  DDPlayerClarityPromptLabel.h
//  DDPlayerProject
//
//  Created by wuqh on 2018/11/19.
//  Copyright © 2018 wuqh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDPlayerClarity.h"

NS_ASSUME_NONNULL_BEGIN

@interface DDPlayerClarityPromptLabel : UILabel

- (void)choose:(DDPlayerClarity)clarity;
- (void)chooseSuccess;
- (void)chooseFail;

@end

NS_ASSUME_NONNULL_END
