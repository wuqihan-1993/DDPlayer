//
//  DDCaptureVideoCommentView.h
//  DDPlayerProject
//
//  Created by wuqh on 2018/11/22.
//  Copyright © 2018 wuqh. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DDTextView;
NS_ASSUME_NONNULL_BEGIN

@interface DDCaptureVideoCommentView : UIView

@property (nonatomic, strong) DDTextView* textView;
@property (nonatomic, copy) void(^confirmBlock)(NSString *);

@end

NS_ASSUME_NONNULL_END
