//
//  DDPlayerClarityTool.m
//  DDPlayerProject
//
//  Created by wuqh on 2018/11/22.
//  Copyright © 2018 wuqh. All rights reserved.
//

#import "DDPlayerClarityTool.h"


@implementation DDPlayerClarityTool

+ (NSString *)clarityString:(DDPlayerClarity)clarity {
    NSString *clarityStr;
    switch (clarity) {
        case DDPlayerClarityDefault:
            clarityStr = @"标准";
            break;
        case DDPlayerClarityFluency:
            clarityStr = @"流畅";
        default:
            break;
    }
    return clarityStr;
}

@end
