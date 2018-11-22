//
//  DDInputView.h
//  DDPlayerProject
//
//  Created by wuqh on 2018/11/22.
//  Copyright © 2018 wuqh. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DDTextView : UITextView

@property (nonatomic, strong) NSString *placeholder;
@property (nonatomic, strong) UIColor *placeholderColor;
@property (nonatomic, strong) UIFont *placeholderFont;
/**
 行数 0代表不限
 */
@property (nonatomic, assign) NSUInteger maxNumberOfLines;
@property (nonatomic, assign) NSUInteger cornerRadius;

@property (nonatomic, copy) void(^textViewChanged)(NSString *text,CGFloat textHeight);

@end

NS_ASSUME_NONNULL_END
