//
//  DDVideoPlayerContainerView.m
//  DDVideoPlayer
//
//  Created by wuqh on 2018/11/7.
//  Copyright © 2018 wuqh. All rights reserved.
//

#import "DDPlayerControlView.h"
#import "DDPlayerTool.h"
#import "Masonry.h"
#import "DDBrightView.h"
#import <MediaPlayer/MPVolumeView.h>
#import "NSTimer+Block.h"
#import "DDPlayerView.h"

typedef NS_ENUM(NSInteger,DDPlayerGestureType) {
    DDPlayerGestureTypeNone,
    DDPlayerGestureTypeBright,
    DDPlayerGestureTypeVolume,
    DDPlayerGestureTypeProgress
};

#define DD_CONTROLVIEW_SHOWTIME (5) //控制view显示多久会自动隐藏

@interface DDPlayerControlView()<UIGestureRecognizerDelegate>
{
    CGFloat _currentLight;//当前亮度
    CGFloat _currentVolume;//当前音量
    CGFloat _currentProgressValue;//当前进度 (上面三个属性和 手势相关)
    CGPoint _panBeginPoint;
    DDPlayerGestureType _gestureType;
}

@property(nonatomic, strong) UIButton *lockScreenButton;

@property(nonatomic, assign) BOOL isLockScreen;



/**
 控制 view 显示隐藏的 计时器
 */
@property(nonatomic, strong) NSTimer *visibelTimer;

/**
 亮度调节视图
 */
@property(nonatomic, strong) DDBrightView *brightView;

/**
 音量调节视图
 */
@property(nonatomic,strong)UISlider *volumeViewSlider;

/**
 是否可见
 */
@property(nonatomic, assign) BOOL isVisible;

@end

@implementation DDPlayerControlView

- (void)dealloc {
    [self closeVisibleTimer];
    if (self.brightView && [[UIApplication sharedApplication].keyWindow.subviews containsObject:self.brightView]) {
        [self.brightView removeFromSuperview];
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUI];
        [self initGestures];
    }
    return self;
}

#pragma mark - action
- (void)playButtonClick:(UIButton *)button {
    [self addVisibleTimer];
    if ([self.delegate respondsToSelector:@selector(playerControlView:clickPlayButton:)]) {
        [self.delegate playerControlView:self clickPlayButton:button];
    }
}
- (void)lockScreenButtonClick:(UIButton *)button {
     [self addVisibleTimer];
    button.selected = !button.isSelected;
    self.isLockScreen = button.selected;
    if (self.isLockScreen) {
        [self dismissWithoutLockScreenButton];
    }else {
        [self show];
    }
    if ([self.delegate respondsToSelector:@selector(playerControlView:clicklockScreenButton:)]) {
        [self.delegate playerControlView:self clicklockScreenButton:button];
    }
}
- (void)captureVideoButtonClick:(UIButton *)button {
     [self addVisibleTimer];
    if ([self.delegate respondsToSelector:@selector(playerControlView:clickCaptureVideoButton:)]) {
        [self.delegate playerControlView:self clickCaptureVideoButton:button];
    }
    
}
- (void)captureImageButtonClick:(UIButton *)button {
     [self addVisibleTimer];
    if ([self.delegate respondsToSelector:@selector(playerControlView:clickCaptureImageButton:)]) {
        [self.delegate playerControlView:self clickCaptureImageButton:button];
    }
}
- (void)tapAction:(UITapGestureRecognizer *)tap {
    if (self.isVisible) {
        [self dismiss];
    }else {
        [self show];
    }
}
- (void)tapDoubleAction:(UITapGestureRecognizer *)tap {
    if (self.isLockScreen) return;
    if ([self.delegate respondsToSelector:@selector(playerControlView:clickPlayButton:)]) {
        [self.delegate playerControlView:self clickPlayButton:self.bottomPortraitView.playButton];
    }
}
- (void)panAction:(UIPanGestureRecognizer *)pan {
    
    if (self.isLockScreen) return;
    
    if (pan.state == UIGestureRecognizerStatePossible || pan.state == UIGestureRecognizerStateBegan) {
        _panBeginPoint = [pan locationInView:self];
        [self lightNeedChangedWithGesture:pan];
        [self volumeNeedChangedWithGesture:pan];
        [self progressChangedWithGesture:pan];
        
    }else if(pan.state == UIGestureRecognizerStateChanged){
        CGPoint changePoint = [pan locationInView:self];
        
        if (_gestureType != DDPlayerGestureTypeNone) {
            
            switch (_gestureType) {
                case DDPlayerGestureTypeBright:
                {
                    [self lightNeedChangedWithGesture:pan];
                }
                    break;
                case DDPlayerGestureTypeVolume:
                {
                    [self volumeNeedChangedWithGesture:pan];
                }
                    break;
                case DDPlayerGestureTypeProgress:
                {
                    [self progressChangedWithGesture:pan];
                }
                    break;
                default:
                    break;
            }
            
        }else {
            if (ABS(changePoint.x - _panBeginPoint.x) < ABS(changePoint.y - _panBeginPoint.y)) {//x > y ,改变亮度或者是音量
                
                if (_panBeginPoint.x < self.bounds.size.width * 0.5) {
                    _gestureType = DDPlayerGestureTypeBright;
                }else {
                    _gestureType = DDPlayerGestureTypeVolume;
                }
                
            }else {// y > x 代表进度
                _gestureType = DDPlayerGestureTypeProgress;
            }
        }
    }else {
        _gestureType = DDPlayerGestureTypeNone;
    }
    
}

#pragma mark - override method
- (void)updateUIWithPortrait {
    [self.topView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(60);
    }];
    self.captureVideoButton.hidden = YES;
    self.captureImageButton.hidden = YES;
    self.lockScreenButton.hidden = YES;
    self.bottomLandscapeView.hidden = YES;
    self.bottomPortraitView.hidden = NO;
}
- (void)updateUIWithLandscape {
    [self.topView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(88);
    }];
    self.captureVideoButton.hidden = NO;
    self.captureImageButton.hidden = NO;
    self.lockScreenButton.hidden = NO;
    self.bottomLandscapeView.hidden = NO;
    self.bottomPortraitView.hidden = YES;
}

#pragma mark - private method
- (void)show {
    
    if ([self.delegate respondsToSelector:@selector(playerControViewWillShow:)]) {
        [self.delegate playerControViewWillShow:self];
    }
    
    NSMutableArray *views = [NSMutableArray arrayWithArray:self.subviews];
    
    if (self.isLockScreen) {
        [views removeObject:self.captureVideoButton];
        [views removeObject:self.captureImageButton];
        [views removeObject:self.topView];
        [views removeObject:self.bottomLandscapeView];
    }
    
    [UIView animateWithDuration:0.4 animations:^{
        for (UIView *subView in views) {
            subView.alpha = 1;
        }
    }];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self addVisibleTimer];
    });
    
}

- (void)dismiss {
    
    if ([self.delegate respondsToSelector:@selector(playerControViewWillDismiss:)]) {
        [self.delegate playerControViewWillDismiss:self];
    }
    
    NSMutableArray *views = [NSMutableArray arrayWithArray:self.subviews];
    [UIView animateWithDuration:0.4 animations:^{
        for (UIView *subView in views) {
            subView.alpha = 0;
        }
    } completion:^(BOOL finished) {
        [self closeVisibleTimer];
    }];
    
}

/**
 点击锁屏按钮时调用。隐藏除了锁屏按钮之外的其他view
 */
- (void)dismissWithoutLockScreenButton {
    NSMutableArray *views = [NSMutableArray arrayWithArray:self.subviews];
    [views removeObject:self.lockScreenButton];
    [UIView animateWithDuration:0.4 animations:^{
        for (UIView *subView in views) {
            subView.alpha = 0;
        }
    } completion:^(BOOL finished) {
        [self addVisibleTimer];
    }];
}
#pragma mark timer
- (void)addVisibleTimer {
    
    if (self.visibelTimer) {
        [self.visibelTimer invalidate];
        self.visibelTimer = nil;
    }
    
    __weak typeof(self) weakSelf = self;
    self.visibelTimer = [NSTimer dd_scheduledTimerWithTimeInterval:DD_CONTROLVIEW_SHOWTIME repeats:NO block:^(NSTimer * _Nonnull timer) {
        [weakSelf doVisibleTimer];
    }];

    [[NSRunLoop currentRunLoop] addTimer:self.visibelTimer forMode:NSRunLoopCommonModes];

}
- (void)closeVisibleTimer {
    if (self.visibelTimer != nil) {
        [self.visibelTimer invalidate];
        self.visibelTimer = nil;
    }
}
- (void)doVisibleTimer {
    NSLog(@"%s",__FUNCTION__);
    if (self.isVisible) {
        [self dismiss];
    }
}

#pragma mark ui
- (void)initUI{
    [self addSubview:self.topView];
    [self addSubview:self.captureVideoButton];
    [self addSubview:self.captureImageButton];
    [self addSubview:self.lockScreenButton];
    [self addSubview:self.bottomPortraitView];
    [self addSubview:self.bottomLandscapeView];
    
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.mas_equalTo(60);
    }];
    [self.captureImageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).mas_offset(DDPlayerTool.isiPhoneX ? -50-34 : -40);
        make.centerY.equalTo(self).mas_offset(-28);
    }];
    [self.captureVideoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).mas_offset(DDPlayerTool.isiPhoneX ? -50-34 : -40);
        make.centerY.equalTo(self).mas_offset(28);
    }];
    [self.lockScreenButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).mas_offset(DDPlayerTool.isiPhoneX ? 50+34 : 40);
        make.centerY.equalTo(self);
    }];
    [self.bottomPortraitView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self);
        make.height.mas_equalTo(60);
    }];
    [self.bottomLandscapeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self);
        make.height.mas_equalTo(88);
    }];
    if (DDPlayerTool.isScreenPortrait) {
        [self updateUIWithPortrait];
    }else {
        [self updateUIWithLandscape];
    }
    
}

- (void)initGestures {
    self.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tapSingle = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    tapSingle.numberOfTapsRequired = 1;
    tapSingle.numberOfTouchesRequired = 1;
    tapSingle.delegate = self;
    [self addGestureRecognizer:tapSingle];
    
    UITapGestureRecognizer *tapDouble = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDoubleAction:)];
    tapDouble.numberOfTapsRequired = 2;
    tapDouble.numberOfTouchesRequired = 1;
    tapDouble.delegate = self;
    [self addGestureRecognizer:tapDouble];

    [tapSingle requireGestureRecognizerToFail:tapDouble];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
    pan.maximumNumberOfTouches = 1;
    pan.delegate = self;
    [self addGestureRecognizer:pan];
    
    //初始化一次音量，否则第一次取到会变成0.0
    MPVolumeView *volumeView = [[MPVolumeView alloc] init];
    for (UIView *view in volumeView.subviews){
        if (_volumeViewSlider) {
            break;
        }
        if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
            _volumeViewSlider = (UISlider*)view;
            break;
        }
    }
}

#pragma mark - GestureRecognizer
//手势改变亮度事件
-(void)lightNeedChangedWithGesture:(UIPanGestureRecognizer *)press{
    if (press.state == UIGestureRecognizerStateBegan || UIGestureRecognizerStatePossible) {
        if (!self.brightView) {
            self.brightView = [[DDBrightView alloc]init];
        }
        _currentLight = [UIScreen mainScreen].brightness;
    }else if (press.state == UIGestureRecognizerStateChanged){
        if([press locationInView:self].y > self.frame.size.height)return;
        CGFloat percent = [self coverPercentWithPoint:[press translationInView:press.view]];
        CGFloat newPercent;
        newPercent = _currentLight - percent > 1 ? 1 : _currentLight - percent;
        newPercent = _currentLight - percent < 0 ? 0 : _currentLight - percent;
        [[UIScreen mainScreen] setBrightness:newPercent];
        self.brightView.bright = newPercent;
    }
}
//手势改变音量事件
-(void)volumeNeedChangedWithGesture:(UIPanGestureRecognizer *)press{
    if (press.state == UIGestureRecognizerStateBegan || UIGestureRecognizerStatePossible) {
        MPVolumeView *volumeView = [[MPVolumeView alloc] init];
        for (UIView *view in volumeView.subviews){
            if (_volumeViewSlider) {
                break;
            }
            if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
                _volumeViewSlider = (UISlider*)view;
                break;
            }
        }
        _currentVolume = _volumeViewSlider.value;
    }else if (press.state == UIGestureRecognizerStateChanged){
        if([press locationInView:self].y > self.frame.size.height)return;
        CGFloat percent = [self coverPercentWithPoint:[press translationInView:press.view]];
        CGFloat newPercent;
        if (_currentVolume - percent > 1) {
            newPercent = 1;
        }else if (_currentVolume - percent < 0){
            newPercent = 0;
        }else{
            newPercent = _currentVolume - percent;
        }
        newPercent = _currentVolume - percent > 1 ? 1 : _currentVolume - percent;
        newPercent = _currentVolume - percent < 0 ? 0 : _currentVolume - percent;
        _volumeViewSlider.value = newPercent;
        if ([self.delegate respondsToSelector:@selector(playerControlView:chagedVolume:)]) {
            [self.delegate playerControlView:self chagedVolume:newPercent];
        }
    }
}
-(void)progressChangedWithGesture:(UIPanGestureRecognizer *)press{
    
    if (press.state == UIGestureRecognizerStateBegan || UIGestureRecognizerStatePossible) {
        
        _currentProgressValue = self.bottomPortraitView.slider.value;
        
        if ([self.delegate respondsToSelector:@selector(playerControlViewBeginDragProgress)]) {
            [self.delegate playerControlViewBeginDragProgress];
        }
    }else if (press.state == UIGestureRecognizerStateChanged){

        CGPoint changePoint = [press locationInView:self];

        CGFloat changeValue = (changePoint.x - _panBeginPoint.x) / (UIScreen.mainScreen.bounds.size.width);
        CGFloat value = changeValue + _currentProgressValue;
        if (value <= 0) {
            value = 0;
        }else if(value >= 1){
            value = 1;
        }
        
        if ([self.delegate respondsToSelector:@selector(playerControlViewDragingProgress:)]) {
            [self.delegate playerControlViewDragingProgress:value];
        }

    }else if (press.state == UIGestureRecognizerStateEnded || press.state == UIGestureRecognizerStateFailed || press.state == UIGestureRecognizerStateCancelled){
        CGPoint changePoint = [press locationInView:self];
        if ([self.delegate respondsToSelector:@selector(playerControlViewEndDragProgress:)]) {
            [self.delegate playerControlViewEndDragProgress: (changePoint.x - _panBeginPoint.x) / (UIScreen.mainScreen.bounds.size.width*0.6)];
        }
    }
}
-(CGFloat)coverPercentWithPoint:(CGPoint )point{
    return point.y / self.frame.size.height;
}
#pragma mark UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if (touch.view == self) {
        NSLog(@"YES%s",__FUNCTION__);
        return YES;
    }else{
        NSLog(@"NO%s",__FUNCTION__);
        return NO;
    }
}



#pragma mark - getter
- (BOOL)isVisible {
    return self.lockScreenButton.alpha > 0;
}
- (BOOL)isDragingSlider {
    return self.bottomPortraitView.isDraging || self.bottomLandscapeView.isDraging;
}

- (UIButton *)lockScreenButton {
    if (!_lockScreenButton) {
        _lockScreenButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_lockScreenButton setImage:[UIImage imageNamed:@"DDPlayer_Btn_Lock"] forState:UIControlStateSelected];
        [_lockScreenButton setImage:[UIImage imageNamed:@"DDPlayer_Btn_Unlock"] forState:UIControlStateNormal];
        [_lockScreenButton addTarget:self action:@selector(lockScreenButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _lockScreenButton;
}
- (UIButton *)captureImageButton {
    if (!_captureImageButton) {
        _captureImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_captureImageButton setImage:[UIImage imageNamed:@"DDPlayer_Btn_captureImage"] forState:UIControlStateNormal];
        [_captureImageButton addTarget:self action:@selector(captureImageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _captureImageButton;
}
- (UIButton *)captureVideoButton {
    if (!_captureVideoButton) {
        _captureVideoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_captureVideoButton setImage:[UIImage imageNamed:@"DDPlayer_Btn_captureVideo"] forState:UIControlStateNormal];
        [_captureVideoButton addTarget:self action:@selector(captureVideoButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _captureVideoButton;
}

- (DDPlayerControlTopView *)topView {
    if (!_topView) {
        _topView = [[DDPlayerControlTopView alloc] init];
        __weak typeof(self) weakSelf = self;
        _topView.backTitleButtonClickBlock = ^(UIButton * _Nonnull button) {
            if ([weakSelf.delegate respondsToSelector:@selector(playerControlView:clickBackTitleButton:)]) {
                [weakSelf.delegate playerControlView:weakSelf clickBackTitleButton:button];
            }
        };
    }
    return _topView;
}
- (DDPlayerControlBottomPortraitView *)bottomPortraitView {
    if (!_bottomPortraitView) {
        _bottomPortraitView = [[DDPlayerControlBottomPortraitView alloc] init];
        __weak typeof(self) weakSelf = self;
        _bottomPortraitView.playButtonClickBlock = ^(UIButton * _Nonnull button) {
            [weakSelf addVisibleTimer];
            
            if ([weakSelf.delegate respondsToSelector:@selector(playerControlView:clickPlayButton:)]) {
                [weakSelf.delegate playerControlView:weakSelf clickPlayButton:button];
            }
        };
        
        _bottomPortraitView.sliderBeginDragingBlock = ^(UISlider * _Nonnull slider) {
            [weakSelf addVisibleTimer];
            if ([weakSelf.delegate respondsToSelector:@selector(playerControlViewBeginDragProgress)]) {
                [weakSelf.delegate playerControlViewBeginDragProgress];
            }
        };
        _bottomPortraitView.sliderDragingBlock = ^(UISlider * _Nonnull slider) {
            [weakSelf addVisibleTimer];
            if ([weakSelf.delegate respondsToSelector:@selector(playerControlViewDragingProgress:)]) {
                [weakSelf.delegate playerControlViewDragingProgress:slider.value];
            }
        };
        _bottomPortraitView.sliderEndDragingBlock = ^(UISlider * _Nonnull slider) {
            [weakSelf addVisibleTimer];
            if ([weakSelf.delegate respondsToSelector:@selector(playerControlViewEndDragProgress:)]) {
                [weakSelf.delegate playerControlViewEndDragProgress:slider.value];
            }
        };
        _bottomPortraitView.sliderTapBlock = ^(UISlider * _Nonnull slider) {
            [weakSelf addVisibleTimer];
            if ([weakSelf.delegate respondsToSelector:@selector(playerControlViewTapProgress:)]) {
                [weakSelf.delegate playerControlViewTapProgress:slider.value];
            }
        };
    }
    return _bottomPortraitView;
}
- (DDPlayerControlBottomLandscapeView *)bottomLandscapeView {
    if (!_bottomLandscapeView) {
        _bottomLandscapeView = [[DDPlayerControlBottomLandscapeView alloc] init];
        __weak typeof(self) weakSelf = self;
        _bottomLandscapeView.playButtonClickBlock = ^(UIButton * _Nonnull button){
            [weakSelf addVisibleTimer];
            
            if ([weakSelf.delegate respondsToSelector:@selector(playerControlView:clickPlayButton:)]) {
                [weakSelf.delegate playerControlView:weakSelf clickPlayButton:button];
            }
        };
        _bottomLandscapeView.forwardButtonClickBlock = ^(UIButton * _Nonnull button) {
            [weakSelf addVisibleTimer];
            
            if ([weakSelf.delegate respondsToSelector:@selector(playerControlView:clickForwardButton:)]) {
                [weakSelf.delegate playerControlView:weakSelf clickForwardButton:button];
            }
        };
        _bottomLandscapeView.clarityButtonClickBlock = ^(UIButton * _Nonnull button) {
            if ([weakSelf.delegate respondsToSelector:@selector(playerControlView:clickClarityButton:)]) {
                [weakSelf.delegate playerControlView:weakSelf clickClarityButton:button];
            }
        };
        _bottomLandscapeView.chapterButtonClickBlock = ^(UIButton * _Nonnull button) {
            [weakSelf addVisibleTimer];
            
            if ([weakSelf.delegate respondsToSelector:@selector(playerControlView:clickChapterButton:)]) {
                [weakSelf.delegate playerControlView:weakSelf clickChapterButton:button];
            }
        };
        _bottomLandscapeView.rateButtonClickBlock = ^(UIButton * _Nonnull button) {
            [weakSelf addVisibleTimer];
            
            if ([weakSelf.delegate respondsToSelector:@selector(playerControlView:clickRateButton:)]) {
                [weakSelf.delegate playerControlView:weakSelf clickRateButton:button];
                
            }
        };
        _bottomLandscapeView.sliderBeginDragingBlock = ^(UISlider * _Nonnull slider) {
            [weakSelf addVisibleTimer];
            if ([weakSelf.delegate respondsToSelector:@selector(playerControlViewBeginDragProgress)]) {
                [weakSelf.delegate playerControlViewBeginDragProgress];
            }
        };
        _bottomLandscapeView.sliderDragingBlock = ^(UISlider * _Nonnull slider) {
            [weakSelf addVisibleTimer];
            if ([weakSelf.delegate respondsToSelector:@selector(playerControlViewDragingProgress:)]) {
                [weakSelf.delegate playerControlViewDragingProgress:slider.value];
            }
        };
        _bottomLandscapeView.sliderEndDragingBlock = ^(UISlider * _Nonnull slider) {
            [weakSelf addVisibleTimer];
            if ([weakSelf.delegate respondsToSelector:@selector(playerControlViewEndDragProgress:)]) {
                [weakSelf.delegate playerControlViewEndDragProgress:slider.value];
            }
        };
        _bottomLandscapeView.sliderTapBlock = ^(UISlider * _Nonnull slider) {
            [weakSelf addVisibleTimer];
            if ([weakSelf.delegate respondsToSelector:@selector(playerControlViewTapProgress:)]) {
                [weakSelf.delegate playerControlViewTapProgress:slider.value];
            }
        };
    }
    return _bottomLandscapeView;
}
@end
