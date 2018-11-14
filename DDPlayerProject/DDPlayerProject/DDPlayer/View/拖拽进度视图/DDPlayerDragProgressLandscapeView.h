//
//  DDPlayerDragProgressLandscapeView.h
//  DDPlayerProject
//
//  Created by wuqh on 2018/11/14.
//  Copyright © 2018 wuqh. All rights reserved.
//

#import "DDPlayerDragProgressBaseView.h"


NS_ASSUME_NONNULL_BEGIN

@class AVAsset;

@interface DDPlayerDragProgressLandscapeView : DDPlayerDragProgressBaseView

@property (nonatomic, strong) AVAsset *asset;

- (void)clear;

@end

NS_ASSUME_NONNULL_END
