//
//  DDVideoNormalViewController.m
//  DDPlayerProject
//
//  Created by wuqh on 2018/11/9.
//  Copyright © 2018 wuqh. All rights reserved.
//

#import "DDVideoNormalViewController.h"
#import "DDPlayerView.h"
#import "DDPlayerView+ShowSubView.h"
#import "Masonry.h"
#import "DDPlayerContainerView.h"

@interface DDVideoNormalViewController ()<UITableViewDataSource,UITableViewDelegate,DDPlayerViewDelegate,DDPlayerDelegate>

@property(nonatomic, strong) DDPlayerView *playerView;
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSArray *dataArray;
@property(nonatomic, nonnull, strong) UITableView *chapterView;

@end


@implementation DDVideoNormalViewController

- (void)dealloc {
    NSLog(@"%s",__FUNCTION__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColor.whiteColor;
    [self initDataArray];
    [self initPlayer];
    [self initUI];
    // 屏幕旋转
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(screenRotation:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;

}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    [self.playerView.player stop];
}

- (void)screenRotation:(NSNotification *)nf {
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    switch (orientation) {
        case UIDeviceOrientationLandscapeLeft:
        {
            [self.playerView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.view);
            }];
        }
            break;
        case UIDeviceOrientationLandscapeRight:
        {
            [self.playerView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.view);
            }];
        }
            break;
        case UIDeviceOrientationPortrait:
        {
            [self.playerView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self.view);
                make.top.equalTo(self.view).mas_offset(DDPlayerTool.isiPhoneX ? 44 : 0);
                make.height.mas_equalTo(DDPlayerTool.screenWidth * 9 /16);
            }];
        }
            break;
        default:
            break;
    }
}

#pragma mark - private method
- (void)initPlayer {
    self.playerView = [[DDPlayerView alloc] init];
    self.playerView.delegate = self;
    self.playerView.player.delegateController = self;
    self.playerView.isHiddenClarity = NO;
    [self.view addSubview:self.playerView];
    [self.playerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).mas_offset(DDPlayerTool.isiPhoneX ? 44 : 0);
        make.height.mas_equalTo(DDPlayerTool.screenWidth * 9 /16);
    }];
    self.playerView.coverImageName = @"ronaldo";
}
- (void)initUI {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.playerView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
}

#pragma mark - override method
#pragma mark 控制屏幕旋转方法
- (BOOL)shouldAutorotate {
    return self.playerView.isAutorotate;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

- (BOOL)prefersHomeIndicatorAutoHidden {
    return YES;
}

//- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
//    return UIInterfaceOrientationLandscapeLeft;
//}

#pragma mark - getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellId"];
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}
- (UITableView *)chapterView {
    if (!_chapterView) {
        _chapterView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        [_chapterView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellId"];
        _chapterView.dataSource = self;
        _chapterView.delegate = self;
    }
    return _chapterView;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId" forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",self.dataArray[indexPath.row][@"videoName"]];
    return cell;
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    //网络视频
    NSString *url = self.dataArray[indexPath.row][@"url"];
    //    DDVideoLineModel *lineModel = [DDVideoLineModel new];
    //    lineModel.lineUrl = url;
    if ([self.dataArray[indexPath.row][@"videoName"] isEqualToString:@"本地视频"]) {
        url = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"mp4"];
    }
    
    [self.playerView.player playWithUrl:url];
//    [self.playerView.player play];
    
    //播放本地视频
//    [self.playerView.player replaceWithUrl:[NSURL fileURLWithPath:[[NSBundle mainBundle]pathForResource:@"play.mp4" ofType:nil]]];
}

#pragma mark data
- (void)initDataArray {
    self.dataArray = @[@{@"url":@"http://221.228.226.23/11/t/j/v/b/tjvbwspwhqdmgouolposcsfafpedmb/sh.yinyuetai.com/691201536EE4912BF7E4F1E2C67B8119.mp4",@"videoName":@"喜欢你"},
                       @{@"url":@"http://alivideo.g2s.cn/zhs_yanfa_150820/createcourse/demo/201804/5a165205fb924d709e7a6449653bb63f_512.mp4",@"videoName":@"管理课"},
                       @{@"url":@"/Users/wuqihan/Library/Developer/CoreSimulator/Devices/B748B1EC-D97C-45F9-A85B-40E0644FA996/data/Containers/Bundle/Application/792ED4DF-CF0E-477B-B41B-DFECEEDF1A18/DDPlayerProject.app/test.mp4",@"videoName":@"本地视频"},
                       @{@"url":@"http://221.228.226.5/14/z/w/y/y/zwyyobhyqvmwslabxyoaixvyubmekc/sh.yinyuetai.com/4599015ED06F94848EBF877EAAE13886.mp4",@"videoName":@"ONE"},
                       @{@"url":@"http://221.228.226.5/15/t/s/h/v/tshvhsxwkbjlipfohhamjkraxuknsc/sh.yinyuetai.com/88DC015DB03C829C2126EEBBB5A887CB.mp4",@"videoName":@"三生三世十里桃花"},
                       @{@"url":@"http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4",@"videoName":@"Big Buck"},
                       @{@"url":@"http://clips.vorwaerts-gmbh.de/big_buck_bunny11.mp4",@"videoName":@"网络错误视频"}];
}

#pragma mark - DDPlayerViewDelegate
- (void)playerViewClickBackButton:(UIButton *)button {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)playerViewClickCoverPlayButton:(UIButton *)button {
    [self.playerView.player playWithUrl:@"http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4"];
}
- (void)playerViewClickForwardButton:(UIButton *)button {
    
}
- (void)playerViewClickLockScreenButton:(UIButton *)button {
    
}
- (void)playerViewClickCaptureImageButton:(UIButton *)button {
    
}
- (void)playerViewClickCaptureVideoButton:(UIButton *)button {
    
}
- (void)playerViewClickChapterButton:(UIButton *)button {
    
    [self.playerView show:self.chapterView origin:DDPlayerShowOriginRight isDismissControl:YES isPause:NO dismissCompletion:nil];
}
- (void)playerViewChooseClarity:(DDPlayerClarity)clarity success:(void (^)(NSString * _Nonnull))success failure:(void (^)(void))failure {
    success(@"http://221.228.226.23/11/t/j/v/b/tjvbwspwhqdmgouolposcsfafpedmb/sh.yinyuetai.com/691201536EE4912BF7E4F1E2C67B8119.mp4");
}

#pragma mark - DDPlayerDelegate

/**
 播放器时间发生变化

 @param currentTime 当前时间(s)
 */
- (void)playerTimeChanged:(double)currentTime {
//    NSLog(@"%lf",currentTime);
}

/**
 播放器准备好即将播放
 */
- (void)playerReadyToPlay {
    self.playerView.title = @"DDPlayerProject";
}
/**
 播放器播放结束
 */
- (void)playerPlayFinish {
    
}


@end
