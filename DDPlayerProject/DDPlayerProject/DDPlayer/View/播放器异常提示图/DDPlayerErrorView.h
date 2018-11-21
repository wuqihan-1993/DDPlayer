//
//  DDPlayerErrorView.h
//  DDPlayerProject
//
//  Created by wuqh on 2018/11/21.
//  Copyright © 2018 wuqh. All rights reserved.
//

#import "DDPlayerComponentBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface DDPlayerErrorView : DDPlayerComponentBaseView

@property (nonatomic, copy) void (^backButtonClickBlock)(UIButton *);
@property(nonatomic, copy) void(^retryBlock)(void);

@end

NS_ASSUME_NONNULL_END
