//
//  DDPlayerViewDelegate.h
//  DDPlayerProject
//
//  Created by wuqh on 2018/11/9.
//  Copyright © 2018 wuqh. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol DDPlayerViewDelegate <NSObject>
@optional
- (void)playerViewClickBackTitleButton:(UIButton *)button;

@end

NS_ASSUME_NONNULL_END
