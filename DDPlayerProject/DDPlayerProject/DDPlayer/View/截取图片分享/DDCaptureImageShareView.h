//
//  DDCaptureImageShareView.h
//  DDPlayerProject
//
//  Created by wuqh on 2018/11/15.
//  Copyright © 2018 wuqh. All rights reserved.
//

#import "DDPlayerContentView.h"
#import "DDPlayerStatus.h"
NS_ASSUME_NONNULL_BEGIN

@interface DDCaptureImageShareView : DDPlayerContentView
@property(nonatomic, copy) void(^shareButtonClickBlock)(DDShareType);
- (instancetype)initWithImage:(UIImage *)image;
@end

NS_ASSUME_NONNULL_END
