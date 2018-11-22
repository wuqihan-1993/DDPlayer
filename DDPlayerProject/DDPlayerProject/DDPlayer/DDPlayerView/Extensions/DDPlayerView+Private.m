//
//  DDPlayerView+Private.m
//  DDPlayerProject
//
//  Created by wuqh on 2018/11/15.
//  Copyright © 2018 wuqh. All rights reserved.
//

#import "DDPlayerView+Private.h"

@implementation DDPlayerView (Private)

- (DDPlayerControlView *)_getPlayerControlView {
    return (DDPlayerControlView *)[self valueForKey:@"playerControlView"];
}


@end
