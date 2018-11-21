//
//  DDNetworkErrorView.h
//  DDPlayerProject
//
//  Created by wuqh on 2018/11/15.
//  Copyright © 2018 wuqh. All rights reserved.
//

#import "DDPlayerContentView.h"

NS_ASSUME_NONNULL_BEGIN

@interface DDNetworkErrorView : DDPlayerContentView

@property (nonatomic, copy) void (^backButtonClickBlock)(UIButton *);
@property(nonatomic, copy) void(^retryBlock)(void);

@end

NS_ASSUME_NONNULL_END
