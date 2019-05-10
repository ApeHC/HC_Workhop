//
//  HCPlayer.m
//  CreativeSpace
//
//  Created by HeChuang⌚️ on 2017/8/10.
//  Copyright © 2017年 HeChuang. All rights reserved.
//

#import "HCPlayer.h"
#import "HCPlayerBottomBar.h"
#import "HCControlPlay.h"
#import "Masonry.h"

#define kTransitionTime 0.2

@interface HCPlayer ()<
HCPlayBottomBarDelegate,
HCPauseOrPlayDelegate,
UIGestureRecognizerDelegate>{
    id _playbackTimeObserver;//Observer
}
@property (strong, nonatomic) HCPlayerBottomBar * BottonBar;

@property (strong, nonatomic) HCControlPlay * ControlPlay;

@property (strong, nonatomic) AVPlayerLayer * playLayer;

@property (strong, nonatomic) UIActivityIndicatorView * activityView;

@property (strong, nonatomic) UILabel * titlelabel;

@property (nonatomic,strong) NSArray *oldConstriants;//原始约束

@end

static NSInteger count = 0;

@implementation HCPlayer

#pragma mark - initPlayer

- (instancetype)initWithURL:(NSURL *)url{
    self = [super init];
    if (self) {
        [self CreatePlayerUI];
        [self InitPlayerWithUrl:url];
    }
    return self;
}

- (instancetype)initWithAsset:(AVURLAsset *)asset{
    self = [super init];
    if (self) {
        [self CreatePlayerUI];
        [self SetupPlayerWithAsset:asset];
    }
    return self;
}

- (void)play{
    if (self.player) {
        [self.player play];
    }
}

- (void)pause{
    if (self.player) {
        [self.player pause];
    }
}

- (void)drawRect:(CGRect)rect {
    [self CreatePlayerUI];
}

- (void)CreatePlayerUI{
    self.backgroundColor = [UIColor blackColor];
    [self.activityView startAnimating];
    [self addTitlelabel];
    [self addGestureEvent];
    [self addPauseAndPlayBtn];
    [self addBottonBar];
    [self addLoadView];
    [self initTimeLabels];
}

#pragma mark - SetupAVURLAsset
- (void)InitPlayerWithUrl:(NSURL *)url{
    NSDictionary * options = @{ AVURLAssetPreferPreciseDurationAndTimingKey : @YES };
    self.asset = [AVURLAsset URLAssetWithURL:url options:options];
    NSArray * array = @[@"duration"];
    [self.asset loadValuesAsynchronouslyForKeys:array completionHandler:^{
        NSError * error = nil;
        AVKeyValueStatus trackStatus = [self.asset statusOfValueForKey:@"duration" error:&error];
        switch (trackStatus) {
            case AVKeyValueStatusLoaded:{
                __weak typeof(self) weakSelf = self;
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (!CMTIME_IS_INDEFINITE(weakSelf.asset.duration)) {//如果时间不是无效的
                        CGFloat second = weakSelf.asset.duration.value / weakSelf.asset.duration.timescale;
                        weakSelf.BottonBar.totalTime = [weakSelf convertTime:second];
                        weakSelf.BottonBar.minValue = 0;
                        weakSelf.BottonBar.maxValue = second;
                    }
                });
            }
                break;
            case AVKeyValueStatusLoading:
                NSLog(@" AVKeyValueStatusLoading   - 加载");
                break;
            case AVKeyValueStatusUnknown:
                NSLog(@" AVKeyValueStatusUnknown   - 未知");
                break;
            case AVKeyValueStatusFailed:
                NSLog(@" AVKeyValueStatusFailed    - 失败");
                break;
            case AVKeyValueStatusCancelled:
                NSLog(@" AVKeyValueStatusCancelled - 取消");
                break;
        }
    }];
    [self SetupPlayerWithAsset:self.asset];
}

#pragma mark - CreatePlayer
- (void)SetupPlayerWithAsset:(AVURLAsset *)asset{
    self.playItem = [[AVPlayerItem alloc] initWithAsset:asset];
    self.player = [AVPlayer playerWithPlayerItem:self.playItem];
    [self.playLayer displayIfNeeded];
    [self.playLayer setVideoGravity:AVVideoScalingModeResizeAspect];
    [self monitoringPlayback:self.playItem];// 监听播放状态
    [self registerNotificationAndObserver];
    _audioTrackArray = [NSArray arrayWithArray:[asset tracksWithMediaType:AVMediaTypeAudio]];
    NSLog(@"audioArray:%@", _audioTrackArray);
    [self switchAudioTrackWithTrackIndex:0];
}

#pragma mark - 切换音轨
- (void)switchAudioTrackWithTrackIndex:(NSInteger)trackIndex{
    AVAssetTrack * assetAudioTrack = _audioTrackArray[trackIndex];
    AVMutableAudioMixInputParameters* audioInputParams = [AVMutableAudioMixInputParameters audioMixInputParameters];
    /********* 此处时间有问题,待修改 ********/
    [audioInputParams setVolume:10 atTime:kCMTimeZero];
    [audioInputParams setTrackID:[assetAudioTrack trackID]];
    NSArray* audioParams = [NSArray arrayWithObject:audioInputParams];
    AVMutableAudioMix* audioMix = [AVMutableAudioMix audioMix];
    [audioMix setInputParameters:audioParams];
    [self.playItem setAudioMix:audioMix];
}

#pragma mark - registerNotficationAndObserver
- (void)registerNotificationAndObserver{
    //监听播放状态
    [self.playItem addObserver:self
                    forKeyPath:@"status"
                       options:NSKeyValueObservingOptionNew
                       context:nil];
    //监听视频缓存加载状态
    [self.playItem addObserver:self
                    forKeyPath:@"loadedTimeRanges"
                       options:NSKeyValueObservingOptionNew
                       context:nil];
    //监听播放的区域缓存是否为空
    [self.playItem addObserver:self
                    forKeyPath:@"playbackBufferEmpty"
                       options:NSKeyValueObservingOptionNew
                       context:nil];
    //缓存可以播放的时候调用
    [self.playItem addObserver:self
                    forKeyPath:@"playbackLikelyToKeepUp"
                       options:NSKeyValueObservingOptionNew
                       context:nil];
    //监听暂停或者播放中
    [self.playItem addObserver:self
                    forKeyPath:@"rate"
                       options:NSKeyValueObservingOptionNew
                       context:nil];
    //播放完成的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayDidEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:[self.player currentItem]];
    //设备朝向改变通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deviceOrientationDidChange:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
    //程序退出通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(willResignActive:)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
}

#pragma mark - removeNotficationAndObserver
- (void)removeNotificationAndObserver{
    [self.playItem removeObserver:self forKeyPath:@"status"];
    [self.playItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    [self.playItem removeObserver:self forKeyPath:@"playbackBufferEmpty"];
    [self.playItem removeObserver:self forKeyPath:@"playbackLikelyToKeepUp"];
    [self.playItem removeObserver:self forKeyPath:@"rate"];
    [self.player removeTimeObserver:_playbackTimeObserver];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:AVPlayerItemDidPlayToEndTimeNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIDeviceOrientationDidChangeNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationWillResignActiveNotification
                                                  object:nil];
}

#pragma mark - AVPlayerItem KVO
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                       context:(void *)context{
    AVPlayerItem *playerItem = (AVPlayerItem *)object;
    if ([keyPath isEqualToString:@"status"]) {
        switch ([playerItem status]) {
            case AVPlayerStatusReadyToPlay:
                _status = HCPlayerStatusReadyToPlay;
                NSLog(@"Play Ready : AVPlayer Status ReadyToPlay");
                break;
            case AVPlayerStatusUnknown:
                _status = HCPlayerStatusUnknown;
                NSLog(@"Play Error : AVPlayer Status Unknown");
                break;
            case AVPlayerStatusFailed:
                _status = HCPlayerStatusFailed;
                NSLog(@"Play Error : AVPlayer Status Failed");
                break;
        }
    } else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        NSArray *loadedTimeRanges = [self.playItem loadedTimeRanges];
        CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];// 获取缓冲区域
        float startSeconds = CMTimeGetSeconds(timeRange.start);
        float durationSeconds = CMTimeGetSeconds(timeRange.duration);
        NSTimeInterval timeInterval = startSeconds + durationSeconds;// 计算缓冲总进度
        CMTime duration = self.playItem.duration;
        CGFloat totalDuration = CMTimeGetSeconds(duration);
        self.BottonBar.bufferValue = timeInterval / totalDuration;//缓存值
    } else if ([keyPath isEqualToString:@"playbackBufferEmpty"]) { //监听播放器在缓冲数据的状态
        _status = HCPlayerStatusBuffering;
        if (!self.activityView.isAnimating) [self.activityView startAnimating];
    } else if ([keyPath isEqualToString:@"playbackLikelyToKeepUp"]) {
        NSLog(@"缓冲达到可播放");
        [self.activityView stopAnimating];
    } else if ([keyPath isEqualToString:@"rate"]){//当rate==0时为暂停,rate==1时为播放,当rate等于负数时为回放
        if ([[change objectForKey:NSKeyValueChangeNewKey]integerValue] == 0) {
            _isPlaying = false;
            _status = HCPlayerStatusPlaying;
        }else{
            _isPlaying = true;
            _status = HCPlayerStatusStopped;
        }
    }
}

#pragma mark - 监听播放进度
- (void)monitoringPlayback:(AVPlayerItem *)playerItem{
    __weak typeof(self) weakSelf = self;
    _playbackTimeObserver = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1.f, 1.f) queue:NULL usingBlock:^(CMTime time) {
        weakSelf.BottonBar.currentValue = weakSelf.playItem.currentTime.value/weakSelf.playItem.currentTime.timescale;
        if (!CMTIME_IS_INDEFINITE(self.asset.duration)) {
            weakSelf.BottonBar.currentTime = [weakSelf convertTime:weakSelf.BottonBar.currentValue];
        }
        if (count>=5) {
            [weakSelf setSubViewsIsHide:YES];
        }else{
            [weakSelf setSubViewsIsHide:NO];
        }
        count += 1;
    }];
}

#pragma mark - NotificationAction
- (void)moviePlayDidEnd:(NSNotification *)notice{
    NSLog(@" video Play End");
    [self.playItem seekToTime:kCMTimeZero];
    [self setSubViewsIsHide:NO];
    count = 0;
    [self pause];
    [self.ControlPlay.imageBtn setSelected:NO];
}

- (void)deviceOrientationDidChange:(NSNotification *)notification{
    UIInterfaceOrientation _interfaceOrientation=[[UIApplication sharedApplication]statusBarOrientation];
    switch (_interfaceOrientation) {
        case UIInterfaceOrientationLandscapeLeft:
        case UIInterfaceOrientationLandscapeRight:{
            _isFullScreen = YES;
            if (!self.oldConstriants) {
                self.oldConstriants = [self getCurrentVC].view.constraints;
            }
            [self.BottonBar updateConstraintsIfNeeded];
            //删除UIView animate可以去除横竖屏切换过渡动画
            [UIView animateWithDuration:kTransitionTime delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0. options:UIViewAnimationOptionTransitionCurlUp animations:^{
                [[UIApplication sharedApplication].keyWindow addSubview:self];
                [self mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.mas_equalTo([UIApplication sharedApplication].keyWindow);
                }];
                [self layoutIfNeeded];
            } completion:nil];
        }
            break;
        case UIInterfaceOrientationPortraitUpsideDown:
        case UIInterfaceOrientationPortrait:{
            _isFullScreen = NO;
            [[self getCurrentVC].view addSubview:self];
            //删除UIView animate可以去除横竖屏切换过渡动画
            [UIView animateKeyframesWithDuration:kTransitionTime delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
                if (self.oldConstriants) {
                    [[self getCurrentVC].view addConstraints:self.oldConstriants];
                }
                [self layoutIfNeeded];
            } completion:nil];
        }
            break;
        case UIInterfaceOrientationUnknown:
            NSLog(@"UIInterfaceOrientationUnknown");
            break;
    }
    [[self getCurrentVC].view layoutIfNeeded];
}

- (void)willResignActive:(NSNotification *)notification{
    if (_isPlaying) {
        [self setSubViewsIsHide:NO];
        count = 0;
        [self pause];
        [self.ControlPlay.imageBtn setSelected:NO];
    }
}

#pragma mark - 将数值转换成时间
- (NSString *)convertTime:(CGFloat)second{
    NSDate *d = [NSDate dateWithTimeIntervalSince1970:second];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if (second/3600 >= 1) {
        [formatter setDateFormat:@"HH:mm:ss"];
    } else {
        [formatter setDateFormat:@"mm:ss"];
    }
    NSString *showtimeNew = [formatter stringFromDate:d];
    return showtimeNew;
}

#pragma mark - 获取当前屏幕显示的viewcontroller
- (UIViewController *)getCurrentVC{
    UIViewController *result = nil;
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal){
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows){
            if (tmpWin.windowLevel == UIWindowLevelNormal){
                window = tmpWin;
                break;
            }
        }
    }
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    return result;
}

#pragma mark - 旋转方向
- (void)interfaceOrientation:(UIInterfaceOrientation)orientation{
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector             = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val                  = orientation;
        
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
    if (orientation == UIInterfaceOrientationLandscapeRight||orientation == UIInterfaceOrientationLandscapeLeft) {
        // 设置横屏
    } else if (orientation == UIInterfaceOrientationPortrait) {
        // 设置竖屏
    }else if (orientation == UIInterfaceOrientationPortraitUpsideDown){
        // 设置倒立
    }
}

#pragma mark - AddSubView
- (void)addTitlelabel{
    [self addSubview:self.titlelabel];
    [self.titlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        make.top.mas_equalTo(self).offset(12);
        make.width.mas_equalTo(self.mas_width);
    }];
}

- (void)addBottonBar{
    [self addSubview:self.BottonBar];
    [self.BottonBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self);
        make.height.mas_equalTo(@44);
    }];
    [self layoutIfNeeded];
}

- (void)initTimeLabels{
    self.BottonBar.currentTime = @"00:00";
    self.BottonBar.totalTime = @"00:00";
}

- (void)addLoadView{
    [self addSubview:self.activityView];
    [self.activityView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(@80);
        make.center.mas_equalTo(self);
    }];
}

- (void)setSubViewsIsHide:(BOOL)isHide{
    self.BottonBar.hidden = isHide;
    self.ControlPlay.hidden = isHide;
    self.titlelabel.hidden = isHide;
}

- (void)addGestureEvent{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTapAction:)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
}

- (void)handleTapAction:(UITapGestureRecognizer *)gesture{
    [self setSubViewsIsHide:NO];
    count = 0;
}

- (void)addPauseAndPlayBtn{
    [self addSubview:self.ControlPlay];
    [self.ControlPlay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
}

#pragma mark - HCPlayBottomBarDelegate
- (void)controlView:(HCPlayerBottomBar *)controlView pointSliderLocationWithCurrentValue:(CGFloat)value{
    count = 0;
    CMTime pointTime = CMTimeMake(value * self.playItem.currentTime.timescale, self.playItem.currentTime.timescale);
    [self.playItem seekToTime:pointTime toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
}

- (void)controlView:(HCPlayerBottomBar *)controlView draggedPositionWithSlider:(UISlider *)slider{
    count = 0;
    CMTime pointTime = CMTimeMake(controlView.currentValue * self.playItem.currentTime.timescale, self.playItem.currentTime.timescale);
    [self.playItem seekToTime:pointTime toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
}

- (void)controlView:(HCPlayerBottomBar *)controlView withLargeButton:(UIButton *)button{
    count = 0;
    if (KPLAYERUISIZE.width < KPLAYERUISIZE.height) {
        [self interfaceOrientation:UIInterfaceOrientationLandscapeRight];
    }else{
        [self interfaceOrientation:UIInterfaceOrientationPortrait];
    }
}

#pragma mark - HCPauseOrPlayDelegate
- (void)pauseOrPlayView:(HCControlPlay *)pauseOrPlayView withState:(BOOL)state{
    count = 0;
    if (state) {
        [self play];
    }else{
        [self pause];
    }
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([touch.view isKindOfClass:[HCPlayerBottomBar class]]) {
        return NO;
    }
    return YES;
}

#pragma mark - lazyload
- (UIActivityIndicatorView *)activityView{
    if (_activityView == nil) {
        _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activityView.hidesWhenStopped = YES;
    }
    return _activityView;
}

- (UILabel *)titlelabel{
    if (_titlelabel == nil) {
        _titlelabel = [[UILabel alloc] init];
        _titlelabel.textAlignment = NSTextAlignmentCenter;
        _titlelabel.font = [UIFont systemFontOfSize:15];
        _titlelabel.backgroundColor = [UIColor clearColor];
        _titlelabel.numberOfLines = 1;
    }
    return _titlelabel;
}

- (HCControlPlay *)ControlPlay{
    if (_ControlPlay == nil) {
        _ControlPlay = [[HCControlPlay alloc]init];
        _ControlPlay.backgroundColor = [UIColor clearColor];
        _ControlPlay.delegate = self;
    }
    return _ControlPlay;
}

- (HCPlayerBottomBar *)BottonBar{
    if (_BottonBar == nil) {
        _BottonBar = [[HCPlayerBottomBar alloc]init];
        _BottonBar.delegate = self;
        _BottonBar.backgroundColor = [UIColor clearColor];
        [_BottonBar.tapGesture requireGestureRecognizerToFail:self.ControlPlay.imageBtn.gestureRecognizers.firstObject];
    }
    return _BottonBar;
}

#pragma mark - set get
+ (Class)layerClass{
    return [AVPlayerLayer class];
}

- (AVPlayer *)player{
    return self.playerLayer.player;
}

- (void)setPlayer:(AVPlayer *)player{
    self.playerLayer.player = player;
}

- (AVPlayerLayer *)playerLayer{
    return (AVPlayerLayer *)self.layer;
}

- (CGFloat)rate{
    return self.player.rate;
}

- (void)setRate:(CGFloat)rate{
    self.player.rate = rate;
}

- (void)setMethod:(HCLayerVideoGravity)method{
    switch (method) {
        case HCLayerVideoGravityResizeAspect:
            self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
            break;
        case HCLayerVideoGravityResizeAspectFill:
            self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
            break;
        case HCLayerVideoGravityResize:
            self.playerLayer.videoGravity = AVLayerVideoGravityResize;
            break;
    }
}

- (void)setTitle:(NSString *)title{
    self.titlelabel.text = title;
}

- (NSString *)title{
    return self.titlelabel.text;
}

#pragma mark - dealloc
- (void)dealloc{
    [self.player replaceCurrentItemWithPlayerItem:nil];
    [self removeNotificationAndObserver];
    if (self.player) {
        [self pause];
        self.asset = nil;
        self.playItem = nil;
        self.BottonBar.currentValue = 0;
        self.BottonBar.currentTime = @"00:00";
        self.BottonBar.totalTime = @"00:00";
        self.player = nil;
        self.activityView = nil;
        [self removeFromSuperview];
    }
}

- (void)stop{
    [self.player replaceCurrentItemWithPlayerItem:nil];
    [self removeNotificationAndObserver];
    if (self.player) {
        self.asset = nil;
        self.playItem = nil;
        self.BottonBar.currentValue = 0;
        self.BottonBar.currentTime = @"00:00";
        self.BottonBar.totalTime = @"00:00";
        self.player = nil;
        self.activityView = nil;
        [self removeFromSuperview];
    }
}

@end
