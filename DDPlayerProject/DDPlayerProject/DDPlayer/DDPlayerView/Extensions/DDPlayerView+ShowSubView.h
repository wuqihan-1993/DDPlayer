//
//  DDPlayerView+ShowSubView.h
//  DDPlayerProject
//
//  Created by wuqh on 2018/11/15.
//  Copyright © 2018 wuqh. All rights reserved.
//

#import "DDPlayerView.h"



typedef NS_ENUM(NSInteger,DDPlayerShowOrigin) {
    DDPlayerShowOriginCenter,
    DDPlayerShowOriginRight,
    DDPlayerShowOriginTop,
    DDPlayerShowOriginLeftBottom
};

@class DDLeftBottomPromptLabel;

@interface DDPlayerView (ShowSubView)

@property(nonatomic, strong) DDLeftBottomPromptLabel *leftBottomPromptLabel;

- (void)show:(UIView*_Nullable)view origin:(DDPlayerShowOrigin)origin isDismissControl:(BOOL)isDismissControl isPause:(BOOL)isPause dismissCompletion:(void(^ __nullable)(void))dismiss;

- (void)showLeftBottomRromptLabel:(NSString *_Nullable)prompt;

@end


