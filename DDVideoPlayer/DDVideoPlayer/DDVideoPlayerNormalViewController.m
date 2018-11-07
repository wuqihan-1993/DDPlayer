//
//  DDVideoPlayerNormalViewController.m
//  DDVideoPlayer
//
//  Created by wuqh on 2018/11/7.
//  Copyright © 2018 wuqh. All rights reserved.
//

#import "DDVideoPlayerNormalViewController.h"
#import "DDVideoPlayer.h"
#import "Masonry.h"
@interface DDVideoPlayerNormalViewController ()<UITableViewDataSource,UITableViewDelegate,DDVideoPlayerContainerViewDelegate>

@property (nonatomic, strong) DDVideoPlayer *videoPlayer;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation DDVideoPlayerNormalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColor.whiteColor;
    [self initDataArray];
    [self initPlayer];
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

#pragma mark - private method
- (void)initPlayer {
    self.videoPlayer = [[DDVideoPlayer alloc] init];
    self.videoPlayer.componentContainerView.delegate = self;
    __weak typeof(self) weakSelf = self;
    self.videoPlayer.portraitUI = ^(MASConstraintMaker * _Nonnull make) {
        make.left.right.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.view).offset(34);
        make.height.mas_equalTo(DDVideoPlayerTool.screenWidth * 9 / 16);
    };
    self.videoPlayer.landscapeUI = ^(MASConstraintMaker * _Nonnull make) {
        make.left.right.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.view);
        make.height.mas_equalTo(DDVideoPlayerTool.screenWidth);
    };
    [self.view addSubview:self.videoPlayer];
    [self.videoPlayer mas_makeConstraints:self.videoPlayer.portraitUI];
}
- (void)initUI {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.videoPlayer.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
}

#pragma mark - override method
- (BOOL)shouldAutorotate {
    return YES;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationLandscapeLeft;
}

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

#pragma mark - DDVideoPlayerContainerViewDelegate
- (void)videoPlayerContainerView:(DDVideoPlayerContainerView *)containerView clickBackTitleButton:(UIButton *)button {
    [self.navigationController popViewControllerAnimated:YES];
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
    NSString *url = self.dataArray[indexPath.row][@"url"];
    DDVideoLineModel *lineModel = [DDVideoLineModel new];
    lineModel.lineUrl = url;
    
    [self.videoPlayer playVideoLines:@[lineModel].mutableCopy];
}

#pragma mark data
- (void)initDataArray {
    self.dataArray = @[@{@"url":@"http://221.228.226.23/11/t/j/v/b/tjvbwspwhqdmgouolposcsfafpedmb/sh.yinyuetai.com/691201536EE4912BF7E4F1E2C67B8119.mp4",@"videoName":@"喜欢你"},
                       @{@"url":@"http://221.228.226.5/14/z/w/y/y/zwyyobhyqvmwslabxyoaixvyubmekc/sh.yinyuetai.com/4599015ED06F94848EBF877EAAE13886.mp4",@"videoName":@"ONE"},
                       @{@"url":@"http://221.228.226.5/15/t/s/h/v/tshvhsxwkbjlipfohhamjkraxuknsc/sh.yinyuetai.com/88DC015DB03C829C2126EEBBB5A887CB.mp4",@"videoName":@"三生三世十里桃花"},
                       @{@"url":@"http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4",@"videoName":@"Big Buck"}];
}

@end
