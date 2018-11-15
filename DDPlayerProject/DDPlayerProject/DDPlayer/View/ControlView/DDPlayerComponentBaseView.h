//
//  DDVideoPlayerComponentBaseView.h
//  DDVideoPlayer
//
//  Created by wuqh on 2018/11/7.
//  Copyright © 2018 wuqh. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DDPlayerComponentBaseView : UIView

- (void)updateUIWithPortrait;
- (void)updateUIWithLandscape;

@end

NS_ASSUME_NONNULL_END
