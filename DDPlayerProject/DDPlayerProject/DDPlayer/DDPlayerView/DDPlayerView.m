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
#import <UIImageView+WebCache.h>
#import "DDPlayerContainerView.h"
#import "DDPlayerDragProgressPortraitView.h"
#import "DDPlayerDragProgressLandscapeView.h"
#import "DDPlayerManager.h"
#import "DDPlayerCoverView.h"
#import "DDNetworkWWANWarnView.h"
#import "DDNetworkErrorView.h"
#import "DDPlayerView+ShowSubView.h"
#import "DDPlayerClarityChoiceView.h"
#import "DDPlayerErrorView.h"
#import "DDPlayerView+CaptureImage.h"
#import "DDPlayerView+CaptureVideo.h"
#import "DDCaptureVideoView.h"
#import "DDPlayerView+SwitchLine.h"
#import "DDPlayerUIFactory.h"
#import "DDPlayerBackButton.h"

@class DDPlayerClarityChoiceView;


@interface DDPlayerView()<DDPlayerDelegate,DDPlayerControlViewDelegate>

@property(nonatomic, strong) DDPlayerBackButton *backButton;
@property(nonatomic, strong) DDPlayerControlView *playerControlView;
@property(nonatomic, strong) UIImageView *loadingView;
@property(nonatomic, strong) DDPlayerDragProgressPortraitView *dragProgressPortraitView;
@property(nonatomic, strong) DDPlayerDragProgressLandscapeView *dragProgressLandscapeView;
@property(nonatomic, strong) DDPlayerCoverView *coverView;//封面图
@property(nonatomic, strong) DDNetworkWWANWarnView *WWANWarnView;//流量警告视图
@property(nonatomic, strong) DDNetworkErrorView *networkErrorView;//无网警告视图
@property(nonatomic, strong) DDPlayerErrorView *playerErrorView;

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
    [self addSubview:self.coverView];
    [self addSubview:self.backButton];
    [self addSubview:self.loadingView];
    
    self.loadingView.hidden = YES;
    
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self).mas_offset(20);
    }];
    [self.playerControlView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.coverView mas_makeConstraints:^(MASConstraintMaker *make) {
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

#pragma mark - setter
- (void)setTitle:(NSString *)title {
    self.playerControlView.topView.title = title;
}
- (void)setCoverImageName:(NSString *)coverImageName {
    self.coverView.coverImageName = coverImageName;
    self.coverView.hidden = NO;
}
- (void)setIsHiddenCapture:(BOOL)isHiddenCapture {
    _isHiddenCapture = isHiddenCapture;
    self.playerControlView.captureImageButton.hidden = isHiddenCapture;
    self.playerControlView.captureVideoButton.hidden = isHiddenCapture;
}
- (void)setIsHiddenShare:(BOOL)isHiddenShare {
    _isHiddenShare = isHiddenShare;
    [[self.playerControlView.topView valueForKey:@"shareButton"] setHidden:isHiddenShare];
}
- (void)setIsHiddenClarity:(BOOL)isHiddenClarity {
    _isHiddenClarity = isHiddenClarity;
    [[self.playerControlView.bottomLandscapeView valueForKey:@"clarityButton"] setHidden:isHiddenClarity];
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
        _playerControlView.hidden = YES;
    }
    return _playerControlView;
}

- (UIImageView *)loadingView {
    if (!_loadingView) {
        _loadingView = [[UIImageView alloc] init];
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSString *gifPath = [[NSBundle mainBundle] pathForResource:@"DDPlayer_Gif_Loading" ofType:@"gif"];
            NSData *gifData = [NSData dataWithContentsOfFile:gifPath];
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.loadingView.image = [UIImage sd_animatedGIFWithData:gifData];
            });
        });
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

- (DDPlayerCoverView *)coverView {
    if (!_coverView) {
        _coverView = [[DDPlayerCoverView alloc] init];
        _coverView.hidden = YES;
        __weak typeof(self) weakSelf = self;
        _coverView.playButtonClickBlock = ^(UIButton * _Nonnull button){
            if ([weakSelf.delegate respondsToSelector:@selector(playerViewClickCoverPlayButton:)]) {
                [weakSelf.delegate playerViewClickCoverPlayButton:button];
            }
        };
        _coverView.backButtonClickBlock = ^(UIButton * _Nonnull button){
            if ([weakSelf.delegate respondsToSelector:@selector(playerViewClickBackButton:)]) {
                [weakSelf.delegate playerViewClickBackButton:button];
            }
        };
    }
    return _coverView;
}

- (DDNetworkWWANWarnView *)WWANWarnView {
    if (!_WWANWarnView) {
        _WWANWarnView = [[DDNetworkWWANWarnView alloc] init];
        __weak typeof(self) weakSelf = self;

        _WWANWarnView.playButtonClickBlock = ^(UIButton * _Nonnull button) {
            //设置为流量可播放
            weakSelf.player.isCanPlayOnWWAN = YES;
            [weakSelf.WWANWarnView removeFromSuperview];
        };
        _WWANWarnView.backButtonClickBlock = ^(UIButton * _Nonnull button) {
            if ([weakSelf.delegate respondsToSelector:@selector(playerViewClickBackButton:)]) {
                [weakSelf.delegate playerViewClickBackButton:button];
            }
        };
    }
    return _WWANWarnView;
}

- (DDNetworkErrorView *)networkErrorView {
    if (!_networkErrorView) {
        _networkErrorView = [[DDNetworkErrorView alloc] init];
        __weak typeof(self) weakSelf = self;
        _networkErrorView.retryBlock = ^{
            if (weakSelf.player.reachability.currentReachabilityStatus != NotReachable) {
                if (weakSelf.networkErrorView.superview) {
                    [weakSelf.networkErrorView removeFromSuperview];
                }
                if (weakSelf.player.status == DDPlayerStatusUnknown) {
                    [weakSelf.player playWithUrl:[weakSelf.player valueForKey:@"_willPlayUrlString"]];
                }else {
                    [weakSelf.player play];
                }

            }

        };
        _networkErrorView.backButtonClickBlock = ^(UIButton * _Nonnull button) {
            if ([weakSelf.delegate respondsToSelector:@selector(playerViewClickBackButton:)]) {
                [weakSelf.delegate playerViewClickBackButton:button];
            }
        };
    }
    return _networkErrorView;
}

- (DDPlayerErrorView *)playerErrorView {
    if (!_playerErrorView) {
        _playerErrorView = [[DDPlayerErrorView alloc] init];
        __weak typeof(self) weakSelf = self;
        _playerErrorView.backButtonClickBlock = ^(UIButton * _Nonnull button) {
            if ([weakSelf.delegate respondsToSelector:@selector(playerViewClickBackButton:)]) {
                [weakSelf.delegate playerViewClickBackButton:button];
            }
        };
        _playerErrorView.retryBlock = ^{
            if ([weakSelf.delegate respondsToSelector:@selector(playerViewPlayerErrorRetry)]) {
                [weakSelf.delegate playerViewPlayerErrorRetry];
            }
        };
    }
    return _playerErrorView;
}
- (DDPlayerBackButton *)backButton {
    if (!_backButton) {
        _backButton = [[DDPlayerBackButton alloc] init];
        __weak typeof(self) weakSelf = self;
        _backButton.backBlock = ^(UIButton * button) {
            if ([weakSelf.delegate respondsToSelector:@selector(playerViewClickBackButton:)]) {
                [weakSelf.delegate playerViewClickBackButton:button];
            }
        };
    }
    return _backButton;
}

- (BOOL)isLockScreen {
    return self.playerControlView.isLockScreen;
}
- (BOOL)isAutorotate {
    if (self.playerControlView.isLockScreen) {
        return NO;
    }
    if (self.isShareingCaptureImage) {
        return NO;
    }
    if (self.isCapturingVideo) {
        return NO;
    }
    return YES;
}

#pragma mark - DDPlayerDelegate
- (void)playerTimeChanged:(double)currentTime {
    
    if (self.playerControlView.isDragingSlider) {
        return;
    }
    
    
    if (self.player.isSeekingToTime) {
        
    }else {
        CGFloat progressValue = currentTime / self.player.duration;
        self.playerControlView.bottomLandscapeView.slider.value = progressValue;
        self.playerControlView.bottomPortraitView.slider.value = progressValue;
    }
    
    NSString *timeStr = [NSString stringWithFormat:@"%@/%@",[DDPlayerTool translateTimeToString:currentTime],[DDPlayerTool translateTimeToString:self.player.duration]];
    self.playerControlView.bottomLandscapeView.timeLabel.text = timeStr;
    self.playerControlView.bottomPortraitView.timeLabel.text = timeStr;
    
    //截取视频时，把时间穿个DDCaptureVideoView
    if (self.captureVideoView) {
        [self.captureVideoView timeChanged:currentTime];
    }
}
- (void)playerStatusChanged:(DDPlayerStatus)status {
    NSLog(@"status: - %ld",(long)status);

    self.loadingView.hidden = (status != DDPlayerStatusBuffering);

    switch (status) {
        case DDPlayerStatusUnknown:
        {
            // [DDPlayer stop]
            [self playerTimeChanged:0];
        }
            break;
        case DDPlayerStatusBuffering:
        {
        }
            break;
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
        
        case DDPlayerStatusEnd:
        {
            
        }
            break;
        case DDPlayerStatusError:
        {
            if ([self.player valueForKeyPath:@"player.error"]) {
                 [self.playerErrorView setError:[self.player valueForKeyPath:@"player.error"] url:[self.player valueForKey:@"_willPlayUrlString"]];
            }else if(self.player.currentItem.error != nil) {
                [self.playerErrorView setError:self.player.currentItem.error url:[self.player valueForKey:@"_willPlayUrlString"]];
            }else {
                [self.playerErrorView setError:nil url:[self.player valueForKey:@"_willPlayUrlString"]];
            }
            [self show:self.playerErrorView origin:DDPlayerShowOriginCenter isDismissControl:YES isPause:YES dismissCompletion:nil];
        }
            break;
        default:
            break;
    }
}

- (void)playerReadyToPlay {

    if (self.WWANWarnView.superview) {
        [self.WWANWarnView removeFromSuperview];
    }
    if (self.networkErrorView.superview) {
        [self.networkErrorView removeFromSuperview];
    }
    if (self.playerErrorView.superview) {
        [self.playerErrorView removeFromSuperview];
    }
    if (self.coverView.hidden == NO) {
        self.coverView.hidden = YES;
    }
    if (self.playerControlView.hidden == YES) {
        self.playerControlView.hidden = NO;
    }
    if (self.player.isLocationUrl) {
        self.isHiddenClarity = YES;
    }else {
        self.isHiddenClarity = NO;
    }
    
    //播放视频，重置清晰度。设置为标准
    if (self.clarity == DDPlayerClarityFluency && ![self.clarityUrl isEqualToString:self.player.currentAsset.URL.absoluteString] ) {
        self.clarity = DDPlayerClarityDefault;
    }
    
    [self.playerControlView show];
    

}

- (void)playerNetworkStatusChanged:(NetworkStatus)networkStatus {
    switch (networkStatus) {
        case NotReachable:
        {
            if (_WWANWarnView !=nil && _WWANWarnView.superview) {
                [_WWANWarnView removeFromSuperview];
            }
            [self show:self.networkErrorView origin:DDPlayerShowOriginCenter isDismissControl:YES isPause:YES dismissCompletion:^{
                
            }];
        }
            break;
        case ReachableViaWWAN:
        {
            if (_networkErrorView != nil && _networkErrorView.superview) {
                [_networkErrorView removeFromSuperview];
            }
            if (self.player.isCanPlayOnWWAN == NO) {
                [self show:self.WWANWarnView origin:DDPlayerShowOriginCenter isDismissControl:YES isPause:YES dismissCompletion:^{
                    
                }];
            }
        }
            break;
        case ReachableViaWiFi:
        {
            if (_networkErrorView != nil && _networkErrorView.superview) {
                [_networkErrorView removeFromSuperview];
            }
            if (_WWANWarnView !=nil && _WWANWarnView.superview) {
                [_WWANWarnView removeFromSuperview];
            }
            [self.player play];
        }
            break;
        default:
            break;
    }
}

- (void)playerWillPlayWithWWAN {
    [self.player stop];
    [self show:self.WWANWarnView origin:DDPlayerShowOriginCenter isDismissControl:YES isPause:YES dismissCompletion:nil];
}
- (void)playerWillPlayWithNetworkError {
    [self.player stop];
    [self show:self.networkErrorView origin:DDPlayerShowOriginCenter isDismissControl:YES isPause:YES dismissCompletion:nil];
}

- (void)playerReInitPlayer {
    [self.player bindToPlayerLayer:(AVPlayerLayer *)self.layer];
}

#pragma mark - DDPlayerControlViewDelegate
- (void)playerControlView:(DDPlayerControlView *)containerView clickBackTitleButton:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(playerViewClickBackButton:)]) {
        [self.delegate playerViewClickBackButton:button];
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
- (void)playerControlView:(DDPlayerControlView *)controlView clickClarityButton:(UIButton *)button {
//    if ([self.delegate respondsToSelector:@selector(playerViewClickClarityButton:)]) {
//        [self.delegate playerViewClickClarityButton:button];
//    }

    [self show:self.clarityChoiceView origin:DDPlayerShowOriginRight isDismissControl:YES isPause:NO dismissCompletion:nil];
}
- (void)playerControlView:(DDPlayerControlView *)controlView clickChapterButton:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(playerViewClickChapterButton:)]) {
        [self.delegate playerViewClickChapterButton:button];
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
    [self captureImageButtonClick:button];
}
- (void)playerControlView:(DDPlayerControlView *)controlView clickCaptureVideoButton:(UIButton *)button {
    [self captureVideoButtonClick:button];
}
- (void)playerControlView:(DDPlayerControlView *)controlView clickRateButton:(UIButton *)button {
    NSMutableString *buttonTitle = button.titleLabel.text.mutableCopy;
    [buttonTitle deleteCharactersInRange:NSMakeRange(buttonTitle.length-1, 1)];
    [self.player playImmediatelyAtRate:buttonTitle.floatValue];
}

- (void)playerControlView:(DDPlayerControlView *)containerView chagedVolume:(CGFloat)volume {
    self.player.volume = volume;
}

- (void)playerControlViewBeginDragProgress {
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
- (void)playerControlViewDragingProgress:(CGFloat)value {
    [self.dragProgressPortraitView setProgress:value duration:self.player.duration];
    [self.dragProgressLandscapeView setProgress:value duration:self.player.duration];
}

-(void)playerControlViewEndDragProgress:(CGFloat)value {
    if (DDPlayerTool.isScreenPortrait) {
        [self.dragProgressPortraitView removeFromSuperview];
        
    }else {
        [self.dragProgressLandscapeView removeFromSuperview];
    }
    
    [self.player seekToTime:self.player.duration * value isPlayImmediately:self.player.isPlaying completionHandler:nil];
}

- (void)playerControlViewTapProgress:(CGFloat)value {
    [self.player seekToTime:self.player.duration * value isPlayImmediately:self.player.isPlaying completionHandler:nil];
}

- (void)playerControViewWillShow:(DDPlayerControlView *)controlView {    
    
}

- (void)playerControViewWillDismiss:(DDPlayerControlView *)controlView {
    [self dismissCaptureImageShareSmallView];
}


@end
