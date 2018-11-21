//
//  DDCaptureVideoProgressView.h
//  DDPlayerProject
//
//  Created by wuqh on 2018/11/21.
//  Copyright © 2018 wuqh. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DDCaptureVideoProgressView : UIView

@property(nonatomic, assign) CGFloat progress;
@property(nonatomic, assign) NSInteger maxCaptureDuration;

@end

NS_ASSUME_NONNULL_END
