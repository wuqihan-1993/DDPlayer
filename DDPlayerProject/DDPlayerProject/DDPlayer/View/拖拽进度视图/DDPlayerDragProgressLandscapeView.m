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
    
    NSString *currentTimeStr = [DDPlayerTool translateTimeToString:duration*progress];
    NSString *durationTimeStr = [DDPlayerTool translateTimeToString:duration];
    NSString *timeStr = [NSString stringWithFormat:@"%@ / %@",currentTimeStr,durationTimeStr];
    NSMutableAttributedString *timeAttStr = [[NSMutableAttributedString alloc] initWithString:timeStr];
    [timeAttStr addAttributes:@{NSForegroundColorAttributeName:[DDPlayerTool colorWithRGBHex:0x61d8bb],NSFontAttributeName:[UIFont boldSystemFontOfSize:40]} range:[timeStr rangeOfString:currentTimeStr]];
    self.timeLabel.attributedText = timeAttStr;
    
    
    NSInteger seconds = progress*duration;
    //这里做个优化。 因为时间不是精确到秒，所以同一秒钟 比如12.1 12.2 12.3 秒 都会下载。
    if (ABS(seconds-_lastSecond) < 1) {
        _lastSecond = seconds;
        return;
    }else {
        NSLog(@"取消下载---");
        [self.imageGenerator cancelAllCGImageGeneration];
        _lastSecond = seconds;
    }
    
    self.imageGenerator.maximumSize = CGSizeMake(80, 80*9/16);
    
    CMTime time = CMTimeMakeWithSeconds(seconds, 600);
    
 
    NSLog(@"开始下载：%@",currentTimeStr);
    __weak typeof(self) weakSelf = self;
    [self.imageGenerator generateCGImagesAsynchronouslyForTimes:@[[NSValue valueWithCMTime:time]] completionHandler:^(CMTime requestedTime, CGImageRef  _Nullable image, CMTime actualTime, AVAssetImageGeneratorResult result, NSError * _Nullable error) {
        if (result == AVAssetImageGeneratorSucceeded) {
            NSLog(@"下载完成：%@",currentTimeStr);
            UIImage *thumbImg = [UIImage imageWithCGImage:image];
            [weakSelf performSelectorOnMainThread:@selector(movieImage:) withObject:thumbImg waitUntilDone:YES];
        }
    }];
}

- (void)movieImage:(UIImage *)image {
    self.currentImageView.image = image;
}

- (void)initUI {
    
    self.timeLabel.font = [UIFont boldSystemFontOfSize:20];
    
    [self addSubview:self.currentImageView];
    [self.currentImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(150*9/16);
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
