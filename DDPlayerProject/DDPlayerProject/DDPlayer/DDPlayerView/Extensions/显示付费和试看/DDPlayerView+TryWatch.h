//
//  DDPlayerView+tryWatch.h
//  DDPlayerProject
//
//  Created by wuqh on 2018/11/23.
//  Copyright © 2018 wuqh. All rights reserved.
//

#import "DDPlayerView.h"

@class DDTryWatchView;



@interface DDPlayerView (TryWatch)

@property(nonatomic, strong) DDTryWatchView *tryWatchView;

- (void)showTryWatchView;
- (void)dismissTryWatchView;

@end

