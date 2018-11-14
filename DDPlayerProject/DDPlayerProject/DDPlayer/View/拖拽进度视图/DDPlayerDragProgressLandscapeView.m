//
//  DDPlayerDragProgressLandscapeView.m
//  DDPlayerProject
//
//  Created by wuqh on 2018/11/14.
//  Copyright © 2018 wuqh. All rights reserved.
//

#import "DDPlayerDragProgressLandscapeView.h"
#import <Masonry.h>
#import "DDPlayerTool.h"
#import "DDPlayerManager.h"
#import <AVKit/AVKit.h>

@interface DDPlayerDragProgressLandscapeView()

{
    NSInteger _lastSecond;
}
@property (nonatomic, strong) UIImageView *currentImageView;
@property (nonatomic, strong) AVAssetImageGenerator *imageGenerator;

@end

@implementation DDPlayerDragProgressLandscapeView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

- (void)setAsset:(AVAsset *)asset {
    _asset = asset;
    self.imageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    self.imageGenerator.requestedTimeToleranceBefore = kCMTimeZero;
    self.imageGenerator.requestedTimeToleranceAfter = kCMTimeZero;
    self.imageGenerator.appliesPreferredTrackTransform = YES;
}

- (void)setProgress:(CGFloat)progress duration:(CGFloat)duration {
    self.timeLabel.text = [DDPlayerTool translateTimeToString:duration*progress];
    
    
    NSInteger seconds = progress*duration;
    if (ABS(seconds-_lastSecond) < 1) {
        return;
    }else {
        [self.imageGenerator cancelAllCGImageGeneration];
    }
    _lastSecond = seconds;
    
    self.imageGenerator.maximumSize = CGSizeMake(100, 100*9/16);
    
    CMTime time = CMTimeMakeWithSeconds(seconds, 600);
    __weak typeof(self) weakSelf = self;
    NSLog(@"开始下载图片%@",self.timeLabel.text);
    [self.imageGenerator generateCGImagesAsynchronouslyForTimes:@[[NSValue valueWithCMTime:time]] completionHandler:^(CMTime requestedTime, CGImageRef  _Nullable image, CMTime actualTime, AVAssetImageGeneratorResult result, NSError * _Nullable error) {
        if (result == AVAssetImageGeneratorSucceeded) {
            UIImage *cImage = [UIImage imageWithCGImage:image scale:0.5 orientation:UIImageOrientationUp];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (weakSelf != nil && weakSelf.currentImageView != nil) {
                    NSLog(@"AVAssetImageGeneratorSucceeded :%@",self.timeLabel.text);
                    weakSelf.currentImageView.image = cImage;
                }
            });
        }
    }];
}

- (void)initUI {
    [self addSubview:self.currentImageView];
    [self.currentImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(200*9/16);
//        make.width.equalTo(self).multipliedBy(0.3);
//        make.height.equalTo(self.mas_width).multipliedBy(0.3*9/16);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.currentImageView.mas_top).mas_offset(-8);
        make.centerX.equalTo(self);
    }];
}

- (UIImageView *)currentImageView {
    if (!_currentImageView) {
        _currentImageView = [[UIImageView alloc] init];
        _currentImageView.backgroundColor = [UIColor greenColor];
    }
    return _currentImageView;
}

@end
