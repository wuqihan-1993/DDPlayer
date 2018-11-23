//
//  DDPlayerView+ToPay.h
//  DDPlayerProject
//
//  Created by wuqh on 2018/11/23.
//  Copyright © 2018 wuqh. All rights reserved.
//

#import "DDPlayerView.h"
@class DDNeedPayView;
NS_ASSUME_NONNULL_BEGIN

@interface DDPlayerView (ToPay)

@property(nonatomic, strong) DDNeedPayView *needPayView;

- (void)showNeedPayView;
- (void)dismissNeedPayView;

@end

NS_ASSUME_NONNULL_END
