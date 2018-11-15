//
//  DDPlayerView+ShowSubView.h
//  DDPlayerProject
//
//  Created by wuqh on 2018/11/15.
//  Copyright © 2018 wuqh. All rights reserved.
//

#import "DDPlayerView.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,DDPlayerShowOrigin) {
    DDPlayerShowOriginCenter,
    DDPlayerShowOriginRight
};

@interface DDPlayerView (ShowSubView)

- (void)show:(UIView*)view origin:(DDPlayerShowOrigin)origin isDismissControl:(BOOL)isDismissControl isPause:(BOOL)isPause dismissCompletion:(void(^)(void))dismiss;

@end

NS_ASSUME_NONNULL_END
