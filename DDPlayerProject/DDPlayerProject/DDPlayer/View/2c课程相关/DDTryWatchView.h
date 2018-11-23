//
//  DDTryWatchView.h
//  DDPlayerProject
//
//  Created by wuqh on 2018/11/23.
//  Copyright © 2018 wuqh. All rights reserved.
//

#import "DDPlayerContentView.h"

NS_ASSUME_NONNULL_BEGIN

@interface DDTryWatchView : DDPlayerContentView

@property(nonatomic, copy) void(^backBlock)(UIButton *);
@property(nonatomic, copy) void(^buyBlock)(UIButton *);
@property(nonatomic, copy) void(^retryWatchBlock)(UIButton *);
@end

NS_ASSUME_NONNULL_END
