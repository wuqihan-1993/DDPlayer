//
//  DDKVOManager.h
//  DDPlayerProject
//
//  Created by wuqh on 2018/11/16.
//  Copyright © 2018 wuqh. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DDKVOManager : NSObject

- (instancetype)initWithTarget:(NSObject *)target;

- (void)safelyAddObserver:(NSObject *)observer
               forKeyPath:(NSString *)keyPath
                  options:(NSKeyValueObservingOptions)options
                  context:(void *)context;
- (void)safelyRemoveObserver:(NSObject *)observer
                  forKeyPath:(NSString *)keyPath;

- (void)safelyRemoveAllObservers;

@end

NS_ASSUME_NONNULL_END
