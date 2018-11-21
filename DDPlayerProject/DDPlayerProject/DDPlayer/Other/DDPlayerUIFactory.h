//
//  DDPlayerUIFactory.h
//  DDPlayerProject
//
//  Created by wuqh on 2018/11/21.
//  Copyright © 2018 wuqh. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DDPlayerUIFactory : UIView

//上图片，下文字的按钮
+(UIButton *)attributeButtonWithImage:(UIImage *)image
                                title:(NSString *)title
                                 font:(UIFont *)font
                           titleColor:(UIColor *)titleColor
                              spacing:(CGFloat)spacing;

@end

NS_ASSUME_NONNULL_END
