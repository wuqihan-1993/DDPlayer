//
//  DDPlayerManager.h
//  DDPlayerProject
//
//  Created by wuqh on 2018/11/9.
//  Copyright © 2018 wuqh. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class DDPlayer;
@interface DDPlayerManager : NSObject

+ (instancetype)sharedManager;

@property (nonatomic, weak) DDPlayer *player;

@end

NS_ASSUME_NONNULL_END
