//
//  DDPlayerManager.m
//  DDPlayerProject
//
//  Created by wuqh on 2018/11/9.
//  Copyright © 2018 wuqh. All rights reserved.
//

#import "DDPlayerManager.h"

@implementation DDPlayerManager

static DDPlayerManager *manager;
+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[DDPlayerManager alloc]init];
    });
    return manager;
}

@end
