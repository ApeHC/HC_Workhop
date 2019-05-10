//
//  HCControlPlay.h
//  CreativeSpace
//
//  Created by HeChuang⌚️ on 2017/8/14.
//  Copyright © 2017年 HeChuang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HCControlPlay;

@protocol HCPauseOrPlayDelegate <NSObject>
@required
/**
 暂停和播放视图和状态
 
 @param pauseOrPlayView 暂停或者播放视图
 @param state 返回状态
 */
- (void)pauseOrPlayView:(HCControlPlay *)pauseOrPlayView withState:(BOOL)state;

@end

@interface HCControlPlay : UIView

@property (nonatomic,strong) UIButton *imageBtn;

@property (nonatomic,weak) id<HCPauseOrPlayDelegate> delegate;

@property (nonatomic,assign,readonly) BOOL state;

@end
