//
//  DDCaptureImageShareSmallView.h
//  DDPlayerProject
//
//  Created by wuqh on 2018/11/14.
//  Copyright © 2018 wuqh. All rights reserved.
//

#import "DDPlayerComponentBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface DDCaptureImageShareSmallView : DDPlayerComponentBaseView

@property(nonatomic, copy) void(^toShareBlock)(UIImage *);

- (instancetype)initWithImage:(UIImage *)image;

@end

NS_ASSUME_NONNULL_END
