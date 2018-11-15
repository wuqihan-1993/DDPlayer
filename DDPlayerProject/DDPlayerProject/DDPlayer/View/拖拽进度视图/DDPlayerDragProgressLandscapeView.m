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

- (void)clear {
    self.timeLabel.text = @"";
    self.currentImageView.image = nil;
}

- (void)setProgress:(CGFloat)progress duration:(CGFloat)duration {
    
    if (self.asset == nil) {
        return;
    }
    
    self.timeLabel.text = [DDPlayerTool translateTimeToString:duration*progress];
    self.timeLabel.textColor = [DDPlayerTool colorWithRGBHex:0x61d8bb];
    NSInteger seconds = progress*duration;
    if (ABS(seconds-_lastSecond) < 1) {
        return;
    }else {
        [self.imageGenerator cancelAllCGImageGeneration];
    }
    _lastSecond = seconds;
    
//    AVURLAsset *urlAsset = (AVURLAsset *)self.asset;
//    if ([DDPlayerTool isLocationPath:urlAsset.URL.absoluteString]) {
//        self.imageGenerator.maximumSize = CGSizeMake(DDPlayerTool.screenHeight*0.4, DDPlayerTool.screenHeight*0.4*9/16);
//    }else {
//        self.imageGenerator.maximumSize = CGSizeMake(100, 100*9/16);
//    }
    
    self.imageGenerator.maximumSize = CGSizeMake(100, 100*9/16);
    
    
    CMTime time = CMTimeMakeWithSeconds(seconds, 600);
    
    NSString *timeStr = self.timeLabel.text;
    NSLog(@"开始下载图片%@",timeStr);
//    [self.imageGenerator generateCGImagesAsynchronouslyForTimes:@[[NSValue valueWithCMTime:time]] completionHandler:^(CMTime requestedTime, CGImageRef  _Nullable image, CMTime actualTime, AVAssetImageGeneratorResult result, NSError * _Nullable error) {
//        if (result == AVAssetImageGeneratorSucceeded) {
//            UIImage *cImage = [UIImage imageWithCGImage:image scale:1 orientation:UIImageOrientationUp];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                if (weakSelf != nil && weakSelf.currentImageView != nil) {
//                    NSLog(@"AVAssetImageGeneratorSucceeded :%@",self.timeLabel.text);
//                    weakSelf.currentImageView.image = cImage;
//                }
//            });
//        }
//    }];
    __weak typeof(self) weakSelf = self;
    [self.imageGenerator generateCGImagesAsynchronouslyForTimes:@[[NSValue valueWithCMTime:time]] completionHandler:^(CMTime requestedTime, CGImageRef  _Nullable image, CMTime actualTime, AVAssetImageGeneratorResult result, NSError * _Nullable error) {
        if (result == AVAssetImageGeneratorSucceeded) {
            NSLog(@"下载完成：%@",timeStr);
            UIImage *thumbImg = [UIImage imageWithCGImage:image];
            [weakSelf performSelectorOnMainThread:@selector(movieImage:) withObject:thumbImg waitUntilDone:YES];
        }
    }];
}

- (void)movieImage:(UIImage *)image {
    self.currentImageView.image = image;
}

- (void)initUI {
    
    self.timeLabel.font = [UIFont boldSystemFontOfSize:32];
    
    [self addSubview:self.currentImageView];
    [self.currentImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(200*9/16);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.currentImageView.mas_top);
        make.centerX.equalTo(self);
    }];
}

- (UIImageView *)currentImageView {
    if (!_currentImageView) {
        _currentImageView = [[UIImageView alloc] init];
        _currentImageView.layer.cornerRadius = 5;
        _currentImageView.layer.masksToBounds = YES;
    }
    return _currentImageView;
}

@end
