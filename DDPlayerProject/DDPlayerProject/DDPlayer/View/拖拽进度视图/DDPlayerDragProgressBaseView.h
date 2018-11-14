//
//  DDPlayerDragProgressBaseView.h
//  DDPlayerProject
//
//  Created by wuqh on 2018/11/14.
//  Copyright © 2018 wuqh. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DDPlayerDragProgressBaseView : UIView

@property(nonatomic, strong) UILabel *timeLabel;

- (void)setProgress:(CGFloat)progress duration:(CGFloat)duration;

@end

NS_ASSUME_NONNULL_END
