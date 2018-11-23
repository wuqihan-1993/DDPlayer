//
//  DDCaptureVideoShareView.m
//  DDPlayerProject
//
//  Created by wuqh on 2018/11/22.
//  Copyright © 2018 wuqh. All rights reserved.
//

#import "DDCaptureVideoShareView.h"
#import "DDCaptureVideoCommentView.h"
#import "DDPlayerTool.h"
#import "DDTextView.h"
#import "DDPlayerStatus.h"
#import <AVKit/AVKit.h>
#import "DDPlayerUIFactory.h"
#import "DDPlayerManager.h"

@interface DDCaptureVideoShareView()

@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UILabel *titleLable;
@property (nonatomic, strong) UIImageView *currentVideoImageView;

@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) UIView *playerView;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@property (nonatomic, strong) UIView *playerBgView;
//添加评论视图
@property (nonatomic, strong) UILabel *commentLabel;
@property (nonatomic, strong) UIButton *commentButton;

@property (nonatomic, strong) DDCaptureVideoCommentView *commentView;

@property (nonatomic, strong) NSMutableArray *shareItemBtnArray;

//显示截取视频 以及上传视频进度的视图
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UIView *progressView;

@property (nonatomic, assign) BOOL isClickBackButton;

@property(nonatomic, strong) AVAssetExportSession *assetExportSession;

@end

@implementation DDCaptureVideoShareView

- (void)dealloc {
    NSLog(@"%s",__FUNCTION__);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initialize];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(capturePlayerPlayEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
        
        // app从后台进入前台都会调用这个方法
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
        // 添加检测app进入后台的观察者
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive) name: UIApplicationWillResignActiveNotification object:nil];
    }
    return self;
}

#pragma mark - 截取 上传 等操作
- (void)captureVideoWithAsset:(AVAsset *)asset startTime:(CMTime)startTime duration:(CGFloat)duration success:(nonnull void (^)(NSString*))success failure:(nonnull void (^)(NSError * _Nonnull))failure {
    
    //截取当前视频的帧画面 并展示
    [self showCurrntVideoImage:[DDPlayerManager thumbnailImageWithAsset:asset currentTime:CMTimeMakeWithSeconds(CMTimeGetSeconds(startTime) + duration, NSEC_PER_SEC)]];
    
    //截取视频
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        weakSelf.assetExportSession = [DDPlayerManager captureVideoWithAsset:asset startTime:startTime duration:duration progress:^(CGFloat progress) {
            
            [weakSelf captureProgress:progress];
            
        } success:^(NSString * _Nonnull caputreVideoPath) {
            
            success(caputreVideoPath);
            
        } failure:^{
            
            failure(weakSelf.assetExportSession.error);
            
        }];
    });
    
}

- (void)showCurrntVideoImage:(UIImage *)currentVideoImage {
    self.currentVideoImageView.image = currentVideoImage;
    [self.currentVideoImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    //添加截取视频 进度视图
    self.statusLabel.text = @"截取中: 0%";
    self.progressView.alpha = 0;
    self.statusLabel.alpha = 0;
    [self.playerBgView addSubview:self.progressView];
    [self.playerBgView addSubview:self.statusLabel];
    
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.playerBgView);
    }];
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.playerBgView);
    }];
    [self layoutIfNeeded];
    
    [self.currentVideoImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).mas_offset(80);
        make.width.mas_equalTo(280);
        make.height.mas_equalTo(280*9/16);
        make.centerX.equalTo(self);
    }];
    
    [UIView animateWithDuration:0.4 animations:^{
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.statusLabel.alpha = 1;
        self.progressView.alpha = 1;
    }];
}

/**
 截取进度展示 0-50%
 
 @param progress （0~1）
 */
- (void)captureProgress:(CGFloat)progress {
    if (self.progressView.alpha != 1) {
        return;
    }
    self.statusLabel.text = [NSString stringWithFormat:@"截取中: %d%%",(int)(progress*100/2)];
    [self.progressView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.playerBgView).mas_offset(self.playerBgView.bounds.size.width * progress / 2);
    }];
    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self layoutIfNeeded];
    } completion:nil];
}

/**
 上传进度展示 50%~90%
 
 @param progress （0-1）
 */
- (void)uploadCaptureVideoProgress:(CGFloat)progress {
    
    if (self.progressView.alpha != 1) {
        return;
    }
    self.statusLabel.text = [NSString stringWithFormat:@"保存中: %d%%",(int)((progress)*100*0.4) + 50];
    [self.progressView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.playerBgView).mas_offset(self.playerBgView.bounds.size.width * (progress+0.5) / 2);
    }];
    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self layoutIfNeeded];
    } completion:nil];
    
}

/**
 上传成功

 @param videoUrl 视频地址
 */
- (void)uploadCaptureVideoSuccess:(NSURL *)videoUrl {
    self.statusLabel.text = @"上传完成： 100%";
    [self.progressView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.playerBgView).mas_offset(self.playerBgView.bounds.size.width);
    }];
    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self layoutIfNeeded];
        self.commentLabel.alpha = 1;
        self.commentButton.alpha = 1;
    } completion:^(BOOL finished) {
        [self playCaptureVideo:videoUrl];
        //显示4个分享图标
        for (int i = 0; i < self.shareItemBtnArray.count; i ++) {
            [UIView animateWithDuration:0.2 delay:i * 0.1 options:UIViewAnimationOptionCurveEaseOut animations:^{
                UIButton *shareTypeBtn = self.shareItemBtnArray[i];
                shareTypeBtn.alpha = 1;
            } completion:^(BOOL finished) {
                
            }];
        }
    }];
}

- (void)playCaptureVideo:(NSURL *)videoUrl {
    self.player = nil;
    [self.playerLayer removeFromSuperlayer];
    self.playerLayer = nil;
    
    self.player = [[AVPlayer alloc] initWithURL:videoUrl];
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    self.playerLayer.frame = self.playerBgView.bounds;
    
    [self.playerBgView.layer addSublayer:self.playerLayer];
    if (UIApplication.sharedApplication.applicationState == UIApplicationStateActive) {
        [self.player play];
    }
}


#pragma mark - action
- (void)backButtonClick:(UIButton *)button {
    NSLog(@"点击了返回按钮 正在截取中的时候");
    if (self.dismissBlock) {
        self.dismissBlock();
    }
    
    [self.assetExportSession cancelExport];
    
    
//    WTCVideoPlayerView *parentPlayer = (WTCVideoPlayerView *)self.superview;
//    //点击返回按钮时 ，如果正在上传中，则要停止上传
//    if ([parentPlayer.eventDelegate respondsToSelector:@selector(videoPlayerCancelUploadCapture)]) {
//        [parentPlayer.eventDelegate videoPlayerCancelUploadCapture];
//    }
//    parentPlayer.isCaptureing = NO;
//    //删除该页面。继续播放视频
//    [self removeFromSuperview];
//    [parentPlayer playDependCurrentRate];
//    if ([parentPlayer.eventDelegate respondsToSelector:@selector(videoPlayerDismissCapture)]) {
//        [parentPlayer.eventDelegate respondsToSelector:@selector(videoPlayerDismissCapture)];
//    }
}
- (void)commentButtonClick {
    if (self.player) {//player存在代表 上传肯定是已经成功了。上传成功才能评论
        [self.commentView.textView becomeFirstResponder];
    }
}

- (void)shareItemBtnClick:(UIButton *)btn {
    DDShareType shareType = btn.tag - 3000;
//    WTCVideoPlayerView *parentPlayer = (WTCVideoPlayerView *)self.superview;
//    if ([parentPlayer.eventDelegate respondsToSelector:@selector(videoPlayerClickCaptureShareTypeBtn:success:fail:)]) {
//        [parentPlayer.eventDelegate videoPlayerClickCaptureShareTypeBtn:shareType success:^{
//
//        } fail:^{
//
//        }];
//    }
    
}



#pragma mark - notification
- (void)capturePlayerPlayEnd:(NSNotification *)notification{
    if (!self.player){
        return;
    }
    CGFloat a=0;
    NSInteger dragedSeconds = floorf(a);
    CMTime dragedCMTime = CMTimeMake(dragedSeconds, 1);
    [self.player seekToTime:dragedCMTime];
    [self.player play];
}
- (void)keyboardWillChangeFrame:(NSNotification *)nf {
    
    double duration = [nf.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect endKeyboardFrame = [nf.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    if (endKeyboardFrame.origin.y == DDPlayerTool.screenWidth) {
        //键盘隐藏
        [self.inputView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self).mas_offset(self.inputView.bounds.size.height);
        }];
    }else {
        //键盘弹出
        [self.inputView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self).mas_offset(-endKeyboardFrame.size.height);
        }];
    }
    
    [UIView animateWithDuration:duration animations:^{
        [self layoutIfNeeded];
    }];
}
- (void)applicationBecomeActive {
    [self.player play];
}
- (void)applicationWillResignActive {
    [self.player pause];
}

- (void)initialize {
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];

    [self addSubview:self.backButton];
    [self addSubview:self.titleLable];
    [self addSubview:self.currentVideoImageView];
    [self addSubview:self.playerBgView];
    [self addSubview:self.commentLabel];
    [self addSubview:self.commentButton];
    [self addSubview:self.commentView];
    
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).mas_offset(33);
        make.left.equalTo(self).mas_offset(DDPlayerTool.isiPhoneX ? 44 : 20);
        make.width.mas_equalTo(68);
        make.height.mas_equalTo(26);
    }];
    
    [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self.backButton);
    }];
    
    [self.currentVideoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.playerBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).mas_offset(80);
        make.width.mas_equalTo(280);
        make.height.mas_equalTo(280*9/16);
        make.centerX.equalTo(self);
    }];
    
    [self.commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.playerBgView.mas_bottom).mas_offset(20);
        make.left.equalTo(self.playerBgView);
        make.right.equalTo(self.commentButton.mas_left).offset(-12);
    }];
    [self.commentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.commentLabel);
        make.right.equalTo(self.playerBgView);
        make.width.height.mas_equalTo(30);
    }];
    [self.commentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.bottom.equalTo(self).offset(self.commentView.bounds.size.height);
    }];
    
    NSArray *sharedItemTitleArray = @[@"微信好友",@"朋友圈",@"新浪微博",@"QQ"];
    NSArray *sharedItemImageArray = @[@"DDPlayer_Btn_Wechat",@"DDPlayer_Btn_Friend",@"DDPlayer_Btn_Weibo",@"DDPlayer_Btn_QQ"];
    
    self.shareItemBtnArray = @[].mutableCopy;
    UIView *shareItemContainerView = [[UIView alloc] init];
    [self addSubview:shareItemContainerView];
    for (int i = 0; i < sharedItemTitleArray.count; i++) {
        UIButton *shareItemBtn = [DDPlayerUIFactory attributeButtonWithImage:[UIImage imageNamed:sharedItemImageArray[i]] title:sharedItemTitleArray[i] font:[DDPlayerTool PingFangSCRegularAndSize:11] titleColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:1] spacing:3.5];
        [shareItemBtn addTarget:self action:@selector(shareItemBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        shareItemBtn.tag = 3000+i;
        shareItemBtn.alpha = 0;
        [self.shareItemBtnArray addObject:shareItemBtn];
        [shareItemContainerView addSubview:shareItemBtn];
        if (i == 0) {
            [shareItemBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(shareItemContainerView);
                make.bottom.equalTo(shareItemContainerView);
                make.top.equalTo(shareItemContainerView);
            }];
        }else if(i == sharedItemTitleArray.count - 1) {
            UIButton *lastButton = self.shareItemBtnArray[i-1];
            [shareItemBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(lastButton.mas_right).offset(20);
                make.centerY.equalTo(lastButton);
                make.right.equalTo(shareItemContainerView);
            }];
        }else {
            UIButton *lastButton = self.shareItemBtnArray[i-1];
            [shareItemBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(lastButton.mas_right).offset(20);
                make.centerY.equalTo(lastButton);
            }];
        }
    }
    [shareItemContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self).offset(-20);
    }];
}

#pragma mark - getter
- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backButton setTitle:@"返回" forState:UIControlStateNormal];
        [_backButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _backButton.titleLabel.font = [DDPlayerTool PingFangSCRegularAndSize:15];
        _backButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
        _backButton.layer.cornerRadius = 13;
        _backButton.layer.masksToBounds = true;
        [_backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}
- (UILabel *)titleLable {
    if (!_titleLable) {
        _titleLable = [[UILabel alloc]init];
        _titleLable.font = [DDPlayerTool PingFangSCRegularAndSize:14];
        _titleLable.textColor = UIColor.whiteColor;
        _titleLable.textAlignment = NSTextAlignmentCenter;
        _titleLable.text = @"截取视频片段";
    }
    return _titleLable;
}
- (UIImageView *)currentVideoImageView {
    if (!_currentVideoImageView) {
        _currentVideoImageView = [[UIImageView alloc] init];
        _currentVideoImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _currentVideoImageView;
}
- (UIView *)playerBgView {
    if (!_playerBgView) {
        _playerBgView = [[UIView alloc] init];
    }
    return _playerBgView;
}
- (UILabel *)statusLabel {
    if (!_statusLabel) {
        _statusLabel = [[UILabel alloc]init];
        _statusLabel.font = [DDPlayerTool PingFangSCRegularAndSize:13];
        _statusLabel.textColor = UIColor.whiteColor;
    }
    return _statusLabel;
}
- (UIView *)progressView {
    if (!_progressView) {
        _progressView = [[UIView alloc] init];
        _progressView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    }
    return _progressView;
}
- (UILabel *)commentLabel {
    if (!_commentLabel) {
        _commentLabel = [[UILabel alloc] init];
        _commentLabel.textColor = UIColor.whiteColor;
        _commentLabel.font = [UIFont systemFontOfSize:16];
        _commentLabel.backgroundColor = UIColor.clearColor;
        _commentLabel.text = @"分享我的课程感悟......";
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commentButtonClick)];
        [_commentLabel setUserInteractionEnabled:YES];
        [_commentLabel addGestureRecognizer:tap];
        _commentLabel.alpha = 0.2;
    }
    return _commentLabel;
}
- (UIButton *)commentButton {
    if (!_commentButton) {
        _commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_commentButton setImage:[UIImage imageNamed:@"DDPlayer_Btn_VideoCapture_Comment"] forState:UIControlStateNormal];
        [_commentButton addTarget:self action:@selector(commentButtonClick) forControlEvents:UIControlEventTouchUpInside];
        _commentButton.alpha = 0.2;
    }
    return _commentButton;
}
- (DDCaptureVideoCommentView *)commentView {
    if (!_commentView) {
        _commentView = [[DDCaptureVideoCommentView alloc] initWithFrame:CGRectMake(0, 0, DDPlayerTool.screenHeight, DDPlayerTool.screenWidth)];
        __weak typeof(self) weakSelf = self;
        _commentView.confirmBlock = ^(NSString * _Nonnull content) {
            if (content.length > 0) {
                if (weakSelf.confirmCommentBlock) {
                    weakSelf.confirmCommentBlock(content, ^{
                        //评论更新成功
                        weakSelf.commentLabel.text = content;
                        [weakSelf.commentView.textView resignFirstResponder];
                        weakSelf.commentButton.hidden = YES;
                        weakSelf.commentLabel.userInteractionEnabled = NO;
                    }, ^{
                        //评论更新失败
                        [weakSelf.commentView.textView resignFirstResponder];
                    });
                }
            }else {
                [weakSelf.commentView.textView resignFirstResponder];
            }
            
        };
    }
    return _commentView;
}

@end
