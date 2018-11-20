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
#import "DDCaptureImageShareView.h"
#import "DDPlayerCoverView.h"
#import "DDNetworkWWANWarnView.h"
#import "DDNetworkErrorView.h"
#import "DDPlayerView+ShowSubView.h"
#import "DDPlayerClarityChoiceView.h"
#import "DDPlayerClarityPromptLabel.h"

@interface DDPlayerView()<DDPlayerDelegate,DDPlayerControlViewDelegate>


@property(nonatomic, strong) DDPlayerControlView *playerControlView;
@property(nonatomic, strong) UIImageView *loadingView;
@property(nonatomic, strong) DDPlayerDragProgressPortraitView *dragProgressPortraitView;
@property(nonatomic, strong) DDPlayerDragProgressLandscapeView *dragProgressLandscapeView;
@property(nonatomic, strong) DDCaptureImageShareSmallView *captureImageShareSmallView;
@property(nonatomic, strong) DDPlayerCoverView *coverView;//封面图
@property(nonatomic, strong) DDNetworkWWANWarnView *WWANWarnView;//流量警告视图
@property(nonatomic, strong) DDNetworkErrorView *networkErrorView;//无网警告视图
@property(nonatomic, strong) DDPlayerClarityChoiceView *clarityChoiceView;//清晰度选择视图
@property(nonatomic, strong) DDPlayerClarityPromptLabel *clarityPromptLabel;

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

#pragma mark - setter
- (void)setTitle:(NSString *)title {
    self.playerControlView.topView.title = title;
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

- (DDPlayerCoverView *)coverView {
    if (!_coverView) {
        _coverView = [[DDPlayerCoverView alloc] init];
        _coverView.playButtonClickBlock = ^{
            
        };
        _coverView.backButtonClickBlock = ^{
            
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
    }
    return _WWANWarnView;
}

- (DDNetworkErrorView *)networkErrorView {
    if (!_networkErrorView) {
        _networkErrorView = [[DDNetworkErrorView alloc] init];
    }
    return _networkErrorView;
}

- (DDPlayerClarityChoiceView *)clarityChoiceView {
    if (!_clarityChoiceView) {
        _clarityChoiceView = [[DDPlayerClarityChoiceView alloc] init];
        __weak typeof(self) weakSelf = self;
        _clarityChoiceView.clarityButtonClickBlock = ^(DDPlayerClarity clarity, UIButton *button) {
            
            //切流操作
            
            if (weakSelf.clarityChoiceView.clarity == clarity) {
                //如果点击s的是同样的清晰度。则直接返回
                [(DDPlayerContainerView*)weakSelf.clarityChoiceView.superview dismiss];
                return ;
            }
            //1.保存当前时间
            NSTimeInterval lastTime = weakSelf.player.currentTime;
            
            //2.截取当前时间图片
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[DDPlayerManager thumbnailImageWithAsset:weakSelf.player.currentAsset currentTime:weakSelf.player.currentItem.currentTime]];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            [weakSelf show:imageView origin:DDPlayerShowOriginCenter isDismissControl:YES isPause:NO dismissCompletion:nil];
            [weakSelf insertSubview:imageView belowSubview:weakSelf.playerControlView];
            
            //3.截取汇总
            [weakSelf.clarityPromptLabel choose:clarity];
            [weakSelf show:weakSelf.clarityPromptLabel origin:DDPlayerShowOriginTop isDismissControl:YES isPause:NO dismissCompletion:nil];
            
            if ([weakSelf.delegate respondsToSelector:@selector(playerViewChooseClarity:success:failure:)]) {
                
                //截取完成
                [(DDPlayerContainerView*)weakSelf.clarityChoiceView.superview dismiss];
            
                [weakSelf.delegate playerViewChooseClarity:clarity success:^(NSString * _Nonnull url) {
                    //4.截取成功
                    [weakSelf.player replaceWithUrl:url];
                    [weakSelf.player seekToTime:lastTime completionHandler:^(BOOL isComplete) {
                        button.selected = YES;
                        [weakSelf.clarityPromptLabel performSelector:@selector(chooseSuccess) withObject:nil afterDelay:1];
                        [imageView removeFromSuperview];
                    }];
                    [(UIButton*)[weakSelf.playerControlView.bottomLandscapeView valueForKey:@"clarityButton"] setTitle:button.titleLabel.text forState:UIControlStateNormal];
                    weakSelf.clarityChoiceView.clarity = clarity;
                } failure:^{
                    [imageView removeFromSuperview];
                }];
            }
        };
    }
    return _clarityChoiceView;
}

- (DDPlayerClarityPromptLabel *)clarityPromptLabel {
    if (!_clarityPromptLabel) {
        _clarityPromptLabel = [[DDPlayerClarityPromptLabel alloc] init];
    }
    return _clarityPromptLabel;
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
            break;
        case DDPlayerStatusUnknown:
        {
            // [DDPlayer stop]
            [self playerTimeChanged:0];
        }
            break;
        default:
            break;
    }
}

- (void)playerNetworkStatusChanged:(NetworkStatus)networkStatus {
    switch (networkStatus) {
        case NotReachable:
        {
            [self show:self.networkErrorView origin:DDPlayerShowOriginCenter isDismissControl:YES isPause:YES dismissCompletion:^{
                
            }];
        }
            break;
        case ReachableViaWWAN:
        {
            [self show:self.WWANWarnView origin:DDPlayerShowOriginCenter isDismissControl:YES isPause:YES dismissCompletion:^{
                
            }];
            
        }
            break;
        case ReachableViaWiFi:
        {
            if (self.networkErrorView.superview) {
                [self.networkErrorView removeFromSuperview];
            }
            if (self.WWANWarnView.superview) {
                [self.WWANWarnView removeFromSuperview];
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
    [self show:self.WWANWarnView origin:DDPlayerShowOriginCenter isDismissControl:YES isPause:YES dismissCompletion:^{
        
    }];
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
- (void)playerControlView:(DDPlayerControlView *)controlView clickClarityButton:(UIButton *)button {
//    if ([self.delegate respondsToSelector:@selector(playerViewClickClarityButton:)]) {
//        [self.delegate playerViewClickClarityButton:button];
//    }

    [self show:self.clarityChoiceView origin:DDPlayerShowOriginRight isDismissControl:YES isPause:NO dismissCompletion:^{
        
    }];
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
            [self.playerControlView show];
            if (self.captureImageShareSmallView != nil) {
                [self.captureImageShareSmallView removeFromSuperview];
                self.captureImageShareSmallView = nil;
            }
            self.captureImageShareSmallView = [[DDCaptureImageShareSmallView alloc] initWithImage:currentImage];
            
            BOOL lastStausIsPause = self.player.isPause;
            
            __weak typeof(self) weakSelf = self;
            self.captureImageShareSmallView.toShareBlock = ^(UIImage * _Nonnull image) {
                NSLog(@"去分享页面");
                
                if (image) {
                    
                    [weakSelf.player pause];
                    [weakSelf.playerControlView dismiss];
                    
                    DDCaptureImageShareView *imageShareView = [[DDCaptureImageShareView alloc] initWithImage:image];
                    imageShareView.dismissBlock = ^{
                        if (!lastStausIsPause) {
                            [weakSelf.player play];
                        }
                    };
                    [weakSelf addSubview:imageShareView];
                    [imageShareView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.edges.equalTo(weakSelf);
                    }];
                }
            };
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
        
        [self.captureImageShareSmallView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.playerControlView.captureImageButton.mas_left).mas_offset(250);
        }];
        
        [UIView animateWithDuration:0.4 animations:^{
            
            [self layoutIfNeeded];
            
        } completion:^(BOOL finished) {
            [self.captureImageShareSmallView removeFromSuperview];
            self.captureImageShareSmallView = nil;
        }];
    
    }
}


@end
