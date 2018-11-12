//
//  DDBrightView.h
//  DDPlayerProject
//
//  Created by wuqh on 2018/11/12.
//  Copyright © 2018 wuqh. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DDBrightView : UIView

@property(nonatomic, assign) CGFloat bright;

/**
 亮度视图消失
 */
-(void)disAppearBrightViewImmediately;
@end

NS_ASSUME_NONNULL_END
