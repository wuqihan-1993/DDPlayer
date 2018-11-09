//
//  DDPlayerView.h
//  DDPlayerProject
//
//  Created by wuqh on 2018/11/9.
//  Copyright © 2018 wuqh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDPlayer.h"
#import "DDPlayerTool.h"
#import "DDPlayerViewDelegate.h"
NS_ASSUME_NONNULL_BEGIN

@interface DDPlayerView : UIView
@property(nonatomic, strong) DDPlayer *player;
@property(nonatomic, weak) id<DDPlayerViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
