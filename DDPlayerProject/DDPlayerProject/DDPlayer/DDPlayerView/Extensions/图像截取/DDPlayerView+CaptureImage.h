//
//  DDPlayerView+CaptureImage.h
//  DDPlayerProject
//
//  Created by wuqh on 2018/11/21.
//  Copyright © 2018 wuqh. All rights reserved.
//

#import "DDPlayerView.h"
@class DDCaptureImageShareSmallView;



@interface DDPlayerView (CaptureImage)

@property(nonatomic, strong) DDCaptureImageShareSmallView *captureImageShareSmallView;
@property(nonatomic, assign) BOOL isShareingCaptureImage;

- (void)captureImageButtonClick:(UIButton *)captureImageButton;
- (void)dismissCaptureImageShareSmallView;

@end

