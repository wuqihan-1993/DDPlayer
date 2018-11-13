//
//  DDPlayerContainerView.h
//  DDPlayerProject
//
//  Created by wuqh on 2018/11/13.
//  Copyright © 2018 wuqh. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,DDPlayerContainerAlignment) {
    DDPlayerContainerAlignmentRight,
    DDPlayerContainerAlignmentCenter
};

@interface DDPlayerContainerView : UIView

@property (nonatomic, copy) void(^dismissBlock)(void);

- (instancetype)initWithContentView:(UIView *)view alignment:(DDPlayerContainerAlignment)alignment;
- (void)show;

@end

NS_ASSUME_NONNULL_END
