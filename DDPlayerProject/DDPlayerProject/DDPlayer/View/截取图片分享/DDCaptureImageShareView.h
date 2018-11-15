//
//  DDCaptureImageShareView.h
//  DDPlayerProject
//
//  Created by wuqh on 2018/11/15.
//  Copyright © 2018 wuqh. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DDCaptureImageShareView : UIView
@property(nonatomic, copy) void(^dismissBlock)(void) ;
- (instancetype)initWithImage:(UIImage *)image;
@end

NS_ASSUME_NONNULL_END
