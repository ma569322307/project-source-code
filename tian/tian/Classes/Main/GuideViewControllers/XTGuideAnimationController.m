//
//  XTGuideAnimationController.m
//  tian
//
//  Created by Jiajun Zheng on 15/7/7.
//  Copyright (c) 2015年 音悦Tai. All rights reserved.
//

#import "XTGuideAnimationController.h"
#import "XTGuideManage.h"
#import <AVFoundation/AVPlayer.h>
#import <Mantle/EXTScope.h>
@interface XTGuideAnimationController ()
@property (nonatomic, weak) UIButton *enterButton;

@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@property (nonatomic, strong) AVAsset *asset;
@property (nonatomic, strong) AVPlayerItem *playerItem;
@end

@implementation XTGuideAnimationController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置背景颜色
    self.view.backgroundColor = UIColorFromRGB(0xffe707);
    // Do any additional setup after loading the view.
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"guideAnimation.mp4" withExtension:nil];
//    NSURL *url = [NSURL URLWithString:@"http://dd.yinyuetai.com/uploads/videos/common/7D77014E66720F5A099BFA4A4D4C4D21.mp4"];
    self.asset = [AVAsset assetWithURL:url];
    self.playerItem = [AVPlayerItem playerItemWithAsset:self.asset];
    self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    self.playerLayer.frame = self.view.bounds;
    [self.view.layer addSublayer:self.playerLayer];
    @weakify(self);
    [self.player addBoundaryTimeObserverForTimes:@[@21.0] queue:dispatch_get_main_queue() usingBlock:^{
        @strongify(self);
        [self.enterButton setImage:[UIImage imageNamed:@"GuideEnter"] forState:UIControlStateNormal];
    }];
    //添加约束
    [self addConstraints];
    //添加通知
    [self addNotificaions];
}
-(void)addConstraints{
    [self.enterButton makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(@-10);
        make.right.equalTo(self.view).offset(@-10);
    }];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.player play];
}
-(void)addNotificaions{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(active) name:UIApplicationDidBecomeActiveNotification object:nil];
}
-(void)active{
    [self.player play];
}
-(void)dealloc{
    NSLog(@"去了");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark -------------------视频播放结束委托--------------------
-(void)enterClick{
    [self.player pause];
//    [self.playerLayer removeFromSuperlayer];
    [UIApplication sharedApplication].keyWindow.rootViewController = [XTGuideManage createDispayViewController];
}
#pragma mark 懒加载
-(UIButton *)enterButton{
    if (_enterButton == nil) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.translatesAutoresizingMaskIntoConstraints = NO;
        _enterButton = btn;
        [btn setImage:[UIImage imageNamed:@"GuideSkip"] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn sizeToFit];
        [btn addTarget:self action:@selector(enterClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
    return _enterButton;
}

@end
