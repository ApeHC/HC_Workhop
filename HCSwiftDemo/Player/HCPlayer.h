//
//  HCPlayer.h
//  CreativeSpace
//
//  Created by HeChuang⌚️ on 2017/8/10.
//  Copyright © 2017年 HeChuang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

/**
 播放器的填充模式

 - HCLayerVideoGravityResizeAspect:     原比例不满屏
 - HCLayerVideoGravityResizeAspectFill: 满屏裁剪
 - HCLayerVideoGravityResize:           满屏拉伸
 */
typedef NS_ENUM (NSInteger,HCLayerVideoGravity){
    HCLayerVideoGravityResizeAspect,
    HCLayerVideoGravityResizeAspectFill,
    HCLayerVideoGravityResize,
};

/**
 播放器状态
 */
typedef NS_ENUM(NSInteger,HCPlayerStatus){
    HCPlayerStatusFailed,
    HCPlayerStatusReadyToPlay,
    HCPlayerStatusUnknown,
    HCPlayerStatusBuffering,
    HCPlayerStatusPlaying,
    HCPlayerStatusStopped,
};

@interface HCPlayer : UIView

@property (strong, nonatomic) AVURLAsset * asset;

@property (strong, nonatomic) AVPlayerItem * playItem;

@property (strong, nonatomic) AVPlayer * player;

@property (assign, nonatomic) CGFloat rate;

@property (assign, nonatomic) HCLayerVideoGravity method;

@property (copy  , nonatomic) NSString * title;

@property (assign, nonatomic, readonly) BOOL isPlaying;

@property (assign, nonatomic, readonly) BOOL isFullScreen;

@property (assign, nonatomic, readonly) HCPlayerStatus status;

@property (strong, nonatomic, readonly) NSArray * audioTrackArray;

- (instancetype)initWithAsset:(AVURLAsset *)asset;

- (instancetype)initWithURL:(NSURL *)url;

- (void)play;

- (void)pause;

- (void)stop;


/**
 切换音轨

 @param trackIndex 指定音轨
 */
- (void)switchAudioTrackWithTrackIndex:(NSInteger)trackIndex;

@end
