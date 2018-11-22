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
#import "DDPlayerErrorView.h"
#import "DDPlayerView+CaptureImage.h"
#import "DDPlayerView+CaptureVideo.h"
#import "DDCaptureVideoView.h"
#import "DDPlayerView+SwitchLine.h"

@class DDPlayerClarityChoiceView;


@interface DDPlayerView()<DDPlayerDelegate,DDPlayerControlViewDelegate>

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
    [self addSubview:self.loadingView];
    
    self.loadingView.hidden = YES;
    
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

//- (DDPlayerClarityChoiceView *)clarityChoiceView {
//    if (!_clarityChoiceView) {
//        _clarityChoiceView = [[DDPlayerClarityChoiceView alloc] init];
//        __weak typeof(self) weakSelf = self;
//        _clarityChoiceView.clarityButtonClickBlock = ^(DDPlayerClarity clarity, UIButton *button) {
//
//            //切流操作
//
//            if (weakSelf.clarityChoiceView.clarity == clarity) {
//                //如果点击s的是同样的清晰度。则直接返回
//                [(DDPlayerContainerView*)weakSelf.clarityChoiceView.superview dismiss];
//                return ;
//            }
//            //1.保存当前时间
//            NSTimeInterval lastTime = weakSelf.player.currentTime;
//
//            //2.截取当前时间图片
//            UIImageView *imageView = [[UIImageView alloc] initWithImage:[DDPlayerManager thumbnailImageWithAsset:weakSelf.player.currentAsset currentTime:weakSelf.player.currentItem.currentTime]];
//            imageView.contentMode = UIViewContentModeScaleAspectFit;
//            [weakSelf show:imageView origin:DDPlayerShowOriginCenter isDismissControl:YES isPause:NO dismissCompletion:nil];
//            [weakSelf insertSubview:imageView belowSubview:weakSelf.playerControlView];
//
//            //3.截取汇总
//            [weakSelf.clarityPromptLabel choose:clarity];
//            [weakSelf show:weakSelf.clarityPromptLabel origin:DDPlayerShowOriginTop isDismissControl:YES isPause:NO dismissCompletion:nil];
//
//            if ([weakSelf.delegate respondsToSelector:@selector(playerViewChooseClarity:success:failure:)]) {
//
//                //截取完成
//                [(DDPlayerContainerView*)weakSelf.clarityChoiceView.superview dismiss];
//
//                [weakSelf.delegate playerViewChooseClarity:clarity success:^(NSString * _Nonnull url) {
//                    //4.截取成功
//                    [weakSelf.player playWithUrl:url];
//                    [weakSelf.player seekToTime:lastTime isPlayImmediately:YES completionHandler:^(BOOL complete) {
//                        button.selected = YES;
//                        [weakSelf.clarityPromptLabel chooseSuccess];
////                        [weakSelf.clarityPromptLabel performSelector:@selector(chooseSuccess) withObject:nil afterDelay:1];
//                        [imageView removeFromSuperview];
//                    }];
//                    [(UIButton*)[weakSelf.playerControlView.bottomLandscapeView valueForKey:@"clarityButton"] setTitle:button.titleLabel.text forState:UIControlStateNormal];
//                    weakSelf.clarityChoiceView.clarity = clarity;
//                } failure:^{
//                    [weakSelf.clarityPromptLabel chooseFail];
//                    [imageView removeFromSuperview];
//                }];
//            }
//        };
//    }
//    return _clarityChoiceView;
//}



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
//            ;这里调用这个方法有时会无效，因为我内部写的是 应用处于活跃状态才能播放。但是wifi状态变更的时候，很有可能不是活跃装填s
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
 
    [self.player seekToTime:self.player.duration * slider.value isPlayImmediately:self.player.isPlaying completionHandler:nil];
}

- (void)playerControlView:(DDPlayerControlView *)controlView tapSlider:(UISlider *)slider {
    [self.player seekToTime:self.player.duration * slider.value isPlayImmediately:self.player.isPlaying completionHandler:nil];
}

- (void)playerControViewWillShow:(DDPlayerControlView *)controlView {
    
    
}

- (void)playerControViewWillDismiss:(DDPlayerControlView *)controlView {
    [self dismissCaptureImageShareSmallView];
}


@end
