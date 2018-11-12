//
//  NSTimer+Block.h
//  DDPlayerProject
//
//  Created by wuqh on 2018/11/12.
//  Copyright © 2018 wuqh. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSTimer (Block)

+ (NSTimer *)dd_scheduledTimerWithTimeInterval:(NSTimeInterval)inerval
                                        repeats:(BOOL)repeats
                                          block:(void(^)(NSTimer *timer))block;

@end

@implementation NSTimer(Block)

+ (NSTimer *)dd_scheduledTimerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats block:(void (^)(NSTimer *timer))block{
    return [NSTimer timerWithTimeInterval:interval target:self selector:@selector(dd_blcokInvoke:) userInfo:[block copy] repeats:repeats];
}

+ (void)dd_blcokInvoke:(NSTimer *)timer {
    
    void (^block)(NSTimer *timer) = timer.userInfo;
    
    if (block) {
        block(timer);
    }
}

@end


NS_ASSUME_NONNULL_END
