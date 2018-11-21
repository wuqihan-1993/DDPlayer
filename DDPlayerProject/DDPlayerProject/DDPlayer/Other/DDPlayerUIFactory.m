//
//  DDPlayerUIFactory.m
//  DDPlayerProject
//
//  Created by wuqh on 2018/11/21.
//  Copyright © 2018 wuqh. All rights reserved.
//

#import "DDPlayerUIFactory.h"

@implementation DDPlayerUIFactory

//上图片，下文字的按钮
+(UIButton *)attributeButtonWithImage:(UIImage *)image
                                title:(NSString *)title
                                 font:(UIFont *)font
                           titleColor:(UIColor *)titleColor
                              spacing:(CGFloat)spacing {
    UIButton *btn = [[UIButton alloc]init];
    NSDictionary *titleDict = @{NSFontAttributeName: font,
                                NSForegroundColorAttributeName: titleColor};
    NSDictionary *spacingDict = @{NSFontAttributeName: [UIFont systemFontOfSize:spacing]};
    
    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
    attachment.image = image;
    attachment.bounds = CGRectMake(0, 0, image.size.width, image.size.height);
    NSAttributedString *imageText = [NSAttributedString attributedStringWithAttachment:attachment];
    
    NSAttributedString *lineText = [[NSAttributedString alloc] initWithString:@"\n\n" attributes:spacingDict];
    
    NSAttributedString *text = [[NSAttributedString alloc] initWithString:title attributes:titleDict];
    
    NSMutableAttributedString *attM = [[NSMutableAttributedString alloc] initWithAttributedString:imageText];
    [attM appendAttributedString:lineText];
    [attM appendAttributedString:text];
    [btn setAttributedTitle:attM forState:UIControlStateNormal];
    btn.titleLabel.numberOfLines = 0;
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [btn sizeToFit];
    return btn;
}
@end
