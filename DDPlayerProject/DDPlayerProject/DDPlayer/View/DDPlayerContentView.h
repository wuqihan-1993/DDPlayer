//
//  DDPlayerContentView.h
//  DDPlayerProject
//
//  Created by wuqh on 2018/11/15.
//  Copyright © 2018 wuqh. All rights reserved.
//

#import "DDPlayerComponentBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface DDPlayerContentView : DDPlayerComponentBaseView

@property (nonatomic, copy) void(^dismissBlock)(void);

@end

NS_ASSUME_NONNULL_END
