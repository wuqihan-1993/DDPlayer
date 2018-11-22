//
//  DDPlayerClarityTool.h
//  DDPlayerProject
//
//  Created by wuqh on 2018/11/22.
//  Copyright © 2018 wuqh. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,DDPlayerClarity) {
    DDPlayerClarityDefault,//标准
    DDPlayerClarityFluency//流畅
};


NS_ASSUME_NONNULL_BEGIN

@interface DDPlayerClarityTool : NSObject

+ (NSString *)clarityString:(DDPlayerClarity)clarity;

@end

NS_ASSUME_NONNULL_END
