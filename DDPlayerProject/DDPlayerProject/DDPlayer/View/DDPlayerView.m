//
//  DDPlayerView.m
//  DDPlayerProject
//
//  Created by wuqh on 2018/11/9.
//  Copyright © 2018 wuqh. All rights reserved.
//

#import "DDPlayerView.h"
#import "DDPlayer.h"
#import "DDPlayerControlView.h"
#import <Masonry.h>
#import <SDWebImage/UIImage+GIF.h>
#import "DDPlayerContainerView.h"
#import "DDPlayerDragProgressPortraitView.h"
#import "DDPlayerDragProgressLandscapeView.h"
#import "DDPlayerManager.h"
#import "DDCaptureImageShareSmallView.h"

@interface DDPlayerView()<DDPlayerDelegate,DDPlayerControlViewDelegate>


@property (nonatomic, strong) DDPlayerControlView *playerControlView;
@property (nonatomic, strong) UIImageView *loadingView;
@property (nonatomic, strong) DDPlayerDragProgressPortraitView *dragProgressPortraitView;
@property (nonatomic, strong) DDPlayerDragProgressLandscapeView *dragProgressLandscapeView;
@property (nonatomic, strong) DDCaptureImageShareSmallView *captureImageShareSmallView;

@end

@implementation DDPlayerView

- (void)dealloc {
    NSLog(@"%s",__FUNCTION__);
}

#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    [self initUI];
    [self.player bindToPlayerLayer:(AVPlayerLayer *)self.layer];
}
- (void)initUI {
    self.backgroundColor = UIColor.blackColor;
    
    [self addSubview:self.playerControlView];
    [self addSubview:self.loadingView];
    
    self.loadingView.hidden = YES;
    
    [self.playerControlView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.mas_equalTo(125);
        make.height.mas_equalTo(20);
    }];
}

#pragma mark - override system method
+ (Class)layerClass {
    return AVPlayerLayer.class;
}

#pragma mark - public method
- (void)showSubViewFromRight:(UIView *)subView {
    
    DDPlayerContainerView *containerView = [[DDPlayerContainerView alloc] initWithContentView:subView alignment:DDPlayerContainerAlignmentRight];
    containerView.frame = CGRectMake(0, 0, DDPlayerTool.screenHeight, DDPlayerTool.screenWidth);
    containerView.dismissBlock = ^{
        [self.playerControlView show];
    };
    [self addSubview:containerView];
    [self layoutIfNeeded];
    [self.playerControlView dismiss];
    [containerView show];
}
- (void)setTitle:(NSString *)title {
    self.playerControlView.topView.title = title;
}

#pragma mark - getter
- (DDPlayer *)player {
    if (!_player) {
        _player = [[DDPlayer alloc] init];
        _player.delegate = self;
    }
    return _player;
}
- (DDPlayerControlView *)playerControlView {
    if (!_playerControlView) {
        _playerControlView = [[DDPlayerControlView alloc] init];
        _playerControlView.delegate = self;
    }
    return _playerControlView;
}

- (UIImageView *)loadingView {
    if (!_loadingView) {
        _loadingView = [[UIImageView alloc] init];
        NSString *gifPath = [[NSBundle mainBundle] pathForResource:@"DDPlayer_Gif_Loading@2x" ofType:@"gif"];
        NSData *gifData = [NSData dataWithContentsOfFile:gifPath];
        _loadingView.image = [UIImage sd_animatedGIFWithData:gifData];
    }
    return _loadingView;
}

- (DDPlayerDragProgressPortraitView *)dragProgressPortraitView {
    if (!_dragProgressPortraitView) {
        _dragProgressPortraitView = [[DDPlayerDragProgressPortraitView alloc] init];
    }
    return _dragProgressPortraitView;
}
- (DDPlayerDragProgressLandscapeView *)dragProgressLandscapeView {
    if (!_dragProgressLandscapeView) {
        _dragProgressLandscapeView = [[DDPlayerDragProgressLandscapeView alloc] init];
    }
    return _dragProgressLandscapeView;
}

- (BOOL)isLockScreen {
    return self.playerControlView.isLockScreen;
}

#pragma mark - DDPlayerDelegate
- (void)playerTimeChanged:(double)currentTime {
    
    
    if (self.playerControlView.isDragingSlider || self.player.isSeekingToTime) {
        return;
    }else {
        CGFloat progressValue = currentTime / self.player.duration;
        self.playerControlView.bottomLandscapeView.slider.value = progressValue;
        self.playerControlView.bottomPortraitView.slider.value = progressValue;
    }
    
    
    
    NSString *timeStr = [NSString stringWithFormat:@"%@/%@",[DDPlayerTool translateTimeToString:currentTime],[DDPlayerTool translateTimeToString:self.player.duration]];
    self.playerControlView.bottomLandscapeView.timeLabel.text = timeStr;
    self.playerControlView.bottomPortraitView.timeLabel.text = timeStr;
    
    
}
- (void)playerStatusChanged:(DDPlayerStatus)status {
    NSLog(@"%ld",(long)status);

    self.loadingView.hidden = (status != DDPlayerStatusBuffering);

    switch (status) {
        case DDPlayerStatusPlaying:
        {
            self.playerControlView.bottomPortraitView.playButton.selected = YES;
            self.playerControlView.bottomLandscapeView.playButton.selected = YES;
            
          
        }
            break;
        case DDPlayerStatusPaused:
        {
            self.playerControlView.bottomPortraitView.playButton.selected = NO;
            self.playerControlView.bottomLandscapeView.playButton.selected = NO;
          
        }
            break;
        case DDPlayerStatusBuffering:
        {
        }
            break;
        case DDPlayerStatusEnd:
        {
            
        }
        default:
            break;
    }
}

#pragma mark - DDPlayerControlViewDelegate
- (void)playerControlView:(DDPlayerControlView *)containerView clickBackTitleButton:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(playerViewClickBackTitleButton:)]) {
        [self.delegate playerViewClickBackTitleButton:button];
    }
}
- (void)playerControlView:(DDPlayerControlView *)containerView clickPlayButton:(UIButton *)button {
    if (button.isSelected) {
        [self.player pause];
    }else {
        [self.player play];
    }
}
- (void)playerControlView:(DDPlayerControlView *)controlView clickForwardButton:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(playerViewClickForwardButton:)]) {
        [self.delegate playerViewClickForwardButton:button];
    }
}
- (void)playerControlView:(DDPlayerControlView *)controlView clicklockScreenButton:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(playerViewClickLockScreenButton:)]) {
        [self.delegate playerViewClickLockScreenButton:button];
    }
}

- (void)playerControlView:(DDPlayerControlView *)controlView clickCaptureImageButton:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(playerControlView:clickCaptureImageButton:)]) {
        [self.delegate playerViewClickCaptureImageButton:button];
    }
    //截图 一闪 的效果
    UIView *whiteView = [[UIView alloc] initWithFrame:self.bounds];
    whiteView.backgroundColor = UIColor.whiteColor;
    [self addSubview:whiteView];
    [UIView animateWithDuration:0.5 animations:^{
        whiteView.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
    } completion:^(BOOL finished) {
        [whiteView removeFromSuperview];
        //开始截取
        UIImage *currentImage = [DDPlayerManager thumbnailImageWithAsset:self.player.currentAsset currentTime:self.player.currentItem.currentTime];
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = currentImage;
        [self addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).mas_offset(40);
            make.right.equalTo(self).mas_offset(-100);
            make.height.mas_equalTo((DDPlayerTool.screenHeight - 140)*9/16);
            make.centerY.equalTo(self);
        }];
        [self layoutIfNeeded];
        [imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(button);
            make.width.height.mas_equalTo(0);
        }];
        [UIView animateWithDuration:0.5 animations:^{
            [self layoutIfNeeded];
        } completion:^(BOOL finished) {
            if (self.captureImageShareSmallView != nil) {
                [self.captureImageShareSmallView removeFromSuperview];
                self.captureImageShareSmallView = nil;
            }
            self.captureImageShareSmallView = [[DDCaptureImageShareSmallView alloc] initWithImage:currentImage];
            [self addSubview:self.captureImageShareSmallView];
            [self.captureImageShareSmallView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(button.mas_left).mas_offset(-20);
                make.centerY.equalTo(button);
            }];
            [self layoutIfNeeded];
        }];
    }];
    
}
- (void)playerControlView:(DDPlayerControlView *)controlView clickCaptureVideoButton:(UIButton *)button {
    
}
- (void)playerControlView:(DDPlayerControlView *)controlView clickRateButton:(UIButton *)button {
    NSMutableString *buttonTitle = button.titleLabel.text.mutableCopy;
    [buttonTitle deleteCharactersInRange:NSMakeRange(buttonTitle.length-1, 1)];
    [self.player playImmediatelyAtRate:buttonTitle.floatValue];
}

- (void)playerControlView:(DDPlayerControlView *)containerView chagedVolume:(CGFloat)volume {
    self.player.volume = volume;
}

- (void)playerControlView:(DDPlayerControlView *)controlView beginDragSlider:(UISlider *)slider {
    
    UIView *dragProgressView;
    if (DDPlayerTool.isScreenPortrait) {
        dragProgressView = self.dragProgressPortraitView;
    }else {
        self.dragProgressLandscapeView.asset = self.player.currentAsset;
        [self.dragProgressLandscapeView clear];
        dragProgressView = self.dragProgressLandscapeView;
    }
    
    [self addSubview:dragProgressView];
    [self insertSubview:dragProgressView belowSubview:self.playerControlView];
    [dragProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self layoutIfNeeded];
    
    
}
- (void)playerControlView:(DDPlayerControlView *)controlView DragingSlider:(UISlider *)slider {
    
    [self.dragProgressPortraitView setProgress:slider.value duration:self.player.duration];
    [self.dragProgressLandscapeView setProgress:slider.value duration:self.player.duration];
}
- (void)playerControlView:(DDPlayerControlView *)controlView endDragSlider:(UISlider *)slider {

    if (DDPlayerTool.isScreenPortrait) {
        [self.dragProgressPortraitView removeFromSuperview];
       
    }else {
        [self.dragProgressLandscapeView removeFromSuperview];
    }
     [self.player seekToTime:self.player.duration * slider.value completionHandler:nil];
}

- (void)playerControlView:(DDPlayerControlView *)controlView tapSlider:(UISlider *)slider {
    [self.player seekToTime:(self.player.duration * slider.value) completionHandler:nil];
}

- (void)playerControViewWillShow:(DDPlayerControlView *)controlView {
    
    
    
}
- (void)playerControViewWillDismiss:(DDPlayerControlView *)controlView {
    if (self.captureImageShareSmallView) {
        [UIView animateWithDuration:0.4 animations:^{
            CGRect frame = self.captureImageShareSmallView.frame;
            frame.origin.x += 200;
            self.captureImageShareSmallView.frame = frame;
        } completion:^(BOOL finished) {
            [self.captureImageShareSmallView removeFromSuperview];
            self.captureImageShareSmallView = nil;
        }];
    }
}


@end
