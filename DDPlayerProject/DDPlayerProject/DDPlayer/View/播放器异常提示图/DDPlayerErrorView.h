//
//  DDPlayerErrorView.h
//  DDPlayerProject
//
//  Created by wuqh on 2018/11/21.
//  Copyright © 2018 wuqh. All rights reserved.
//

#import "DDPlayerComponentBaseView.h"



@interface DDPlayerErrorView : DDPlayerComponentBaseView

@property (nonatomic, copy) void (^backButtonClickBlock)(UIButton *);
@property(nonatomic, copy) void(^retryBlock)(void);

- (void)setError:(NSError *)error url:(NSString *)url;

@end

