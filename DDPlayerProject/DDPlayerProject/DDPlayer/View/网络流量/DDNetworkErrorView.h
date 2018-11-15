//
//  DDNetworkErrorView.h
//  DDPlayerProject
//
//  Created by wuqh on 2018/11/15.
//  Copyright © 2018 wuqh. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DDNetworkErrorView : UIView

@property(nonatomic, copy) void(^retryBlock)(void);

@end

NS_ASSUME_NONNULL_END
